import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/screens/cafe_screen.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/utils/cafe_helpers.dart';

CafeModel _cafe(int id, double nota, bool wifi) => CafeModel(
  id: id,
  nombre: 'Cafe $id',
  descripcion: 'Descripcion $id',
  ingredientes: const [],
  calificacion: nota,
  tieneWifi: wifi,
  direccion: 'Direccion $id',
);

class _ServicioFalso extends CafeService {
  final List<Future<List<CafeModel>> Function()> respuestas;
  int llamadas = 0;

  _ServicioFalso(this.respuestas);

  @override
  Future<List<CafeModel>> obtenerCafes() =>
      respuestas[llamadas++ < respuestas.length ? llamadas - 1 : 0]();
}

void main() {
  final cafes = [
    _cafe(1, 4.9, true),
    _cafe(2, 4.5, false),
    _cafe(3, 4.4, true),
    _cafe(4, 3.9, false),
  ];

  group('filtrarCafes', () {
    List<int> ids(bool wifi, bool mejores) => filtrarCafes(
      cafes,
      soloWifi: wifi,
      soloMejoresCalificadas: mejores,
    ).map((c) => c.id).toList();

    test(
      'sin filtros devuelve todo',
      () => expect(ids(false, false), [1, 2, 3, 4]),
    );
    test('solo Wi-Fi', () => expect(ids(true, false), [1, 3]));
    test(
      'solo mejor calificadas (>= 4.5)',
      () => expect(ids(false, true), [1, 2]),
    );
    test('ambos filtros', () => expect(ids(true, true), [1]));
    test('no modifica la lista original', () {
      ids(true, true);
      expect(cafes.length, 4);
    });
  });

  Future<void> abrir(WidgetTester tester, CafeService servicio) async {
    await tester.pumpWidget(MaterialApp(home: CafeScreen(servicio: servicio)));
    await tester.pumpAndSettle();
  }

  testWidgets('muestra dirección, estado vacío y recupera la lista', (
    tester,
  ) async {
    await abrir(
      tester,
      _ServicioFalso([
        () async => [_cafe(4, 3.9, false)],
      ]),
    );

    expect(find.text('Direccion 4'), findsOneWidget);

    await tester.tap(find.byType(Switch).last);
    await tester.pumpAndSettle();
    expect(
      find.text('No encontramos cafeterías con estos filtros'),
      findsOneWidget,
    );

    await tester.tap(find.text('Quitar filtros'));
    await tester.pumpAndSettle();
    expect(find.text('Cafe 4'), findsOneWidget);
  });

  testWidgets('error de carga y recuperación al reintentar', (tester) async {
    final servicio = _ServicioFalso([
      () async => throw Exception('No hay conexión a internet'),
      () async => cafes,
    ]);
    await abrir(tester, servicio);

    expect(find.text('No hay conexión a internet'), findsOneWidget);

    await tester.tap(find.text('Reintentar conexión'));
    await tester.pumpAndSettle();
    expect(find.text('Cafe 1'), findsOneWidget);
  });

  testWidgets('sin desbordamiento con fuente máxima', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2.0)),
          child: child!,
        ),
        home: CafeScreen(servicio: _ServicioFalso([() async => cafes])),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
