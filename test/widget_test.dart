import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/main.dart';

void main() {
  testWidgets('Muestra la pantalla inicial de cafés', (tester) async {
    await tester.pumpWidget(const CafesLojaApp());

    expect(find.text('Cafés de Loja'), findsOneWidget);
    expect(find.text('Visitas: 0'), findsOneWidget);
  });
}
