import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/screens/cafe_screen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

import 'servicio_falso.dart';

/// Pantalla de teléfono (393 x 873 dp) con la escala de texto indicada.
Future<void> _montar(
  WidgetTester tester,
  ServicioFalso servicio, {
  double escalaTexto = 1.0,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(escalaTexto)),
        child: child!,
      ),
      home: CafeScreen(servicio: servicio),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tocarFiltro(WidgetTester tester, String etiqueta) async {
  await tester.tap(find.widgetWithText(SwitchListTile, etiqueta));
  await tester.pumpAndSettle();
}

CafeModel _cafe(int id, {required double calificacion, required bool wifi}) =>
    CafeModel(
      id: id,
      nombre: 'Cafe $id',
      descripcion: 'Descripción $id',
      ingredientes: const [],
      calificacion: calificacion,
      tieneWifi: wifi,
      direccion: 'Dirección $id',
    );

void main() {
  testWidgets('los dos filtros se combinan con los datos reales', (
    tester,
  ) async {
    final cafes = leerCafesReales();
    await _montar(tester, ServicioFalso([() async => cafes]));

    expect(find.text('Mostrando 28 de 28'), findsOneWidget);

    await _tocarFiltro(tester, 'Filtrar solo con Wi-Fi');
    expect(find.text('Mostrando 20 de 28'), findsOneWidget);

    await _tocarFiltro(tester, 'Mejor calificadas');
    expect(find.text('Mostrando 16 de 28'), findsOneWidget);

    await _tocarFiltro(tester, 'Filtrar solo con Wi-Fi');
    expect(find.text('Mostrando 18 de 28'), findsOneWidget);

    await _tocarFiltro(tester, 'Mejor calificadas');
    expect(find.text('Mostrando 28 de 28'), findsOneWidget);
  });

  testWidgets('la tarjeta muestra la dirección del JSON', (tester) async {
    await _montar(tester, ServicioFalso([() async => leerCafesReales()]));
    expect(
      find.text('Calle 10 de Agosto (entre Bolívar y Sucre)'),
      findsOneWidget,
    );
  });

  testWidgets('estado vacío con datos controlados y Limpiar filtros', (
    tester,
  ) async {
    // Datos de PRUEBA: con el JSON real ninguna combinación da cero.
    final datos = [
      _cafe(1, calificacion: 4.4, wifi: true),
      _cafe(2, calificacion: 4.8, wifi: false),
    ];
    await _montar(tester, ServicioFalso([() async => datos]));

    await _tocarFiltro(tester, 'Filtrar solo con Wi-Fi');
    await _tocarFiltro(tester, 'Mejor calificadas');

    expect(
      find.text('No encontramos cafeterías con estos filtros.'),
      findsOneWidget,
    );
    expect(find.byType(EstadoError), findsNothing);
    expect(find.byType(TarjetaCafe), findsNothing);

    await tester.tap(find.text('Limpiar filtros'));
    await tester.pumpAndSettle();

    expect(find.byType(EstadoVacio), findsNothing);
    expect(find.byType(TarjetaCafe), findsNWidgets(2));
  });

  testWidgets('estado de error y Reintentar vuelve a cargar', (tester) async {
    final servicio = ServicioFalso([
      () async => throw Exception('No hay conexión a internet'),
      () async => [_cafe(1, calificacion: 4.6, wifi: true)],
    ]);
    await _montar(tester, servicio);

    expect(
      find.text(
        'No pudimos cargar las cafeterías. '
        'Revisa tu conexión e inténtalo de nuevo.',
      ),
      findsOneWidget,
    );
    expect(find.text('No hay conexión a internet'), findsOneWidget);
    expect(find.byType(EstadoVacio), findsNothing);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(servicio.llamadas, 2);
    expect(find.byType(EstadoError), findsNothing);
    expect(find.byType(TarjetaCafe), findsOneWidget);
  });

  for (final escala in [2.0, 3.0]) {
    testWidgets('sin overflow con texto al ${escala}x', (tester) async {
      await _montar(
        tester,
        ServicioFalso([() async => leerCafesReales()]),
        escalaTexto: escala,
      );
      await _tocarFiltro(tester, 'Mejor calificadas');

      // Recorre la lista completa: cualquier RenderFlex overflowed
      // hace fallar la prueba automáticamente.
      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, -20000),
        3000,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('estados vacío y error sin overflow al ${escala}x', (
      tester,
    ) async {
      await _montar(
        tester,
        ServicioFalso([
          () async => throw Exception('No hay conexión a internet'),
        ]),
        escalaTexto: escala,
      );
      expect(find.byType(EstadoError), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
