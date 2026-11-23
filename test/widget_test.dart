import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/screens/cafe_screen.dart';
import 'package:semana2/services/cafe_service.dart';

class ServicioDePrueba implements CafeService {
  bool sinConexion = false;

  @override
  Future<List<CafeModel>> obtenerCafes() async {
    if (sinConexion) throw Exception('Sin conexión');
    final datos = jsonDecode(
      File('test/fixtures/cafes_demo.json').readAsStringSync(),
    ) as List;
    return datos
        .map(
          (item) => CafeModel.fromJson({
            ...item as Map<String, dynamic>,
            'image': null,
          }),
        )
        .toList();
  }
}

void main() {
  testWidgets(
    'Horario, filtros combinados, error y reintento con letra grande',
    (tester) async {
      final service = ServicioDePrueba();
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: CafeScreen(service: service),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Horario: 08:00 - 20:00'), findsOneWidget);
      Future<void> pulsar(String texto) async {
        final control = find.text(texto);
        await tester.ensureVisible(control);
        await tester.tap(control);
        await tester.pumpAndSettle();
      }

      await pulsar('Mejor calificadas');
      expect(find.text('Café Puerta de la Ciudad'), findsOneWidget);
      expect(find.text('Kaweh Coffee Shop'), findsNothing);
      await pulsar('Filtrar solo con Wi-Fi');
      await pulsar('Quitar filtros');
      expect(find.text('Kaweh Coffee Shop'), findsOneWidget);
      service.sinConexion = true;
      await pulsar('Recargar API');
      expect(find.text('Sin conexión'), findsOneWidget);
      service.sinConexion = false;
      await pulsar('Reintentar conexión');
      expect(find.text('Kaweh Coffee Shop'), findsOneWidget);
    },
  );
}
