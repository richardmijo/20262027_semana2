// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:semana2/widgets/cabecera_resumen.dart';

void main() {
  testWidgets('Muestra los dos filtros de la cabecera', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CabeceraResumen(
            total: 3,
            promedio: 4.6,
            conWifi: 2,
            soloWifi: false,
            soloMejorCalificadas: false,
            onToogleWifi: (_) {},
            onToogleMejorCalificadas: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Filtrar solo con Wi-Fi'), findsOneWidget);
    expect(find.text('Mejor calificadas'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(2));
  });
}
