import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/main.dart';
import 'package:semana2/widgets/estados_vista.dart';

void main() {
  testWidgets('CafesLojaApp arranca mostrando la carga de cafeterías', (
    tester,
  ) async {
    await tester.pumpWidget(const CafesLojaApp());

    expect(find.text('Cafes de Loja'), findsOneWidget);
    expect(find.byType(EstadoCargando), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // En las pruebas Flutter bloquea internet, así que la petición real de Dio
    // falla. Se deja pasar el tiempo de espera (8 s) para que termine y la
    // pantalla quede en el estado de error, sin temporizadores pendientes.
    await tester.pump(const Duration(seconds: 10));
    expect(find.byType(EstadoError), findsOneWidget);
  });
}
