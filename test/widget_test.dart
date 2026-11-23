import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

void main() {
  // Prueba sencilla: la cabecera debe tener los dos filtros
  testWidgets('La cabecera muestra los dos filtros', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CabeceraResumen(
            total: 28,
            promedio: 4.5,
            conWifi: 20,
            soloWifi: false,
            onToogleWifi: (_) {},
            soloMejorCalificadas: false,
            onToogleMejorCalificadas: (_) {},
            notaMinima: 4.5,
          ),
        ),
      ),
    );

    expect(find.text('Filtrar solo con Wi-Fi'), findsOneWidget);
    expect(find.text('Mejor calificadas (4.5+)'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(2));
  });

  // Prueba sencilla: la tarjeta muestra los datos nuevos y no se desborda
  testWidgets('La tarjeta muestra direccion, horario y precio',
      (WidgetTester tester) async {
    final cafe = CafeModel(
      id: 1,
      nombre: 'Emporio Lojano',
      descripcion: 'Casona patrimonial del centro historico.',
      ingredientes: const [],
      imagenUrl: null,
      precio: 2.75,
      calificacion: 4.9,
      tieneWifi: true,
      direccion: 'Calle 10 de Agosto (entre Bolívar y Sucre)',
      horario: '07:30 - 21:00',
    );

    await tester.pumpWidget(
      MaterialApp(
        // Simulamos la letra del celular al máximo (2x)
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(2.0)),
          child: child!,
        ),
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: SingleChildScrollView(
              child: TarjetaCafe(cafe: cafe, alVisitar: () {}),
            ),
          ),
        ),
      ),
    );

    expect(find.text(r'$2.75'), findsOneWidget);
    expect(find.text(cafe.direccion), findsOneWidget);
    expect(find.text(cafe.horario), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
