import 'package:flutter_test/flutter_test.dart';

import 'package:semana2/main.dart';

void main() {
  testWidgets('CafesLojaApp muestra la pantalla de cafés de Loja', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const CafesLojaApp());
    });

    // El título de la pantalla principal aparece en la AppBar de CafeScreen.
    expect(find.text('Cafes de Loja'), findsOneWidget);
  });
}
