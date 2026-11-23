import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/main.dart';

void main() {
  testWidgets('La aplicación inicia con el título de Cafés de Loja', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CafesLojaApp());
    await tester.pump(const Duration(seconds: 11));

    expect(find.text('Cafés de Loja'), findsOneWidget);
  });
}
