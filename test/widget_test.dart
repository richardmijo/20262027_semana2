import 'package:flutter_test/flutter_test.dart';

import 'package:semana2/main.dart';

void main() {
  testWidgets('La pantalla de cafés se muestra', (WidgetTester tester) async {
    await tester.pumpWidget(const CafesLojaApp());

    expect(find.text('Cafes de Loja'), findsOneWidget);
    expect(find.text('Recargar API'), findsOneWidget);

    // Deja vencer el tiempo de espera de Dio para no dejar timers pendientes.
    await tester.pump(const Duration(seconds: 10));
  });
}
