import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

Widget conTextoGrande(Widget child) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(
        size: Size(360, 640),
        textScaler: TextScaler.linear(2.0),
      ),
      child: Scaffold(body: child),
    ),
  );
}

Widget cabecera({bool filtros = true}) {
  return CabeceraResumen(
    total: 28,
    promedio: 4.6,
    conWifi: 20,
    soloWifi: filtros,
    mejorCalificadas: filtros,
    onToogleWifi: (_) {},
    onToogleMejorCalificadas: (_) {},
  );
}

CafeModel cafe(int id) {
  return CafeModel(
    id: id,
    nombre: 'Emporio Lojano de la Ruta del Cafe $id',
    descripcion: 'Casona patrimonial centenaria en el centro historico con cafe de especialidad.',
    ingredientes: const [],
    calificacion: 4.9,
    tieneWifi: true,
    horario: '07:30 - 21:00',
  );
}

void usarPantallaPequena(WidgetTester tester) {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('lista con cabecera sin desbordes con letra maxima', (
    tester,
  ) async {
    usarPantallaPequena(tester);
    await tester.pumpWidget(
      conTextoGrande(
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: cabecera()),
            SliverList.builder(
              itemCount: 3,
              itemBuilder: (context, index) =>
                  TarjetaCafe(cafe: cafe(index), alVisitar: () {}),
            ),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('estado vacio con cabecera sin desbordes', (tester) async {
    usarPantallaPequena(tester);
    await tester.pumpWidget(
      conTextoGrande(
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: cabecera()),
            SliverFillRemaining(
              hasScrollBody: false,
              child: EstadoVacio(onAccion: _noop),
            ),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('estado de error sin desbordes', (tester) async {
    usarPantallaPequena(tester);
    await tester.pumpWidget(
      conTextoGrande(
        EstadoError(mensaje: 'No hay conexión a internet', onReintentar: _noop),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}
