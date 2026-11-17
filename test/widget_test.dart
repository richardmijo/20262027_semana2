import 'package:flutter_test/flutter_test.dart';

import 'package:semana2/main.dart';

void main() {
  testWidgets('Muestra la pantalla principal de Cafés de Loja', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CafesLojaApp());

    expect(find.text('Cafés de Loja'), findsOneWidget);
  });
}
