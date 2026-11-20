import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/screens/cafe_screen.dart';
import 'package:semana2/services/cafe_service.dart';

class _CafeServiceDePrueba extends CafeService {
  @override
  Future<List<CafeModel>> obtenerCafes() async => [
    CafeModel(
      id: 1,
      nombre: 'Café de prueba',
      descripcion: 'Café de Loja',
      ingredientes: ['Leche'],
    ),
  ];
}

void main() {
  testWidgets('Muestra los favoritos al volver por la flecha y el sistema', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: CafeScreen(cafeService: _CafeServiceDePrueba())),
    );
    await tester.pumpAndSettle();

    final cafe = find.text('Café de prueba');
    final punto = tester.getCenter(cafe);
    await tester.tapAt(punto);
    await tester.tapAt(punto);
    await tester.pumpAndSettle();

    final control = find.byType(SwitchListTile);
    expect(control, findsOneWidget);
    await tester.tap(control);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(control, findsNothing);
    expect(find.byIcon(Icons.star), findsOneWidget);

    await tester.tap(cafe);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(control).value, isTrue);
    await tester.tap(control);
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(control, findsNothing);
    expect(find.byIcon(Icons.star), findsNothing);
    expect(find.text('Quitado de favoritos'), findsOneWidget);
  });
}
