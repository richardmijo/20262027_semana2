import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/models/cafe_model.dart';

import 'servicio_falso.dart';

void main() {
  test('la dirección se lee del JSON real', () {
    final primero = leerCafesReales().first;
    expect(primero.nombre, 'Emporio Lojano');
    expect(primero.direccion, 'Calle 10 de Agosto (entre Bolívar y Sucre)');
    expect(primero.calificacion, 4.9);
  });

  test('todas las cafeterías del JSON real traen dirección', () {
    expect(leerCafesReales().every((c) => c.direccion != null), isTrue);
  });

  test('acepta la clave alternativa "address"', () {
    final cafe = CafeModel.fromJson({
      'id': 1,
      'title': 'Prueba',
      'address': '  Av. Universitaria  ',
    });
    expect(cafe.direccion, 'Av. Universitaria');
  });

  test('sin dirección ni calificación no se inventan valores', () {
    final cafe = CafeModel.fromJson({'id': 7, 'title': 'Prueba'});
    expect(cafe.direccion, isNull);
    expect(cafe.calificacion, isNull);
  });

  test('calificación como texto numérico se convierte a double', () {
    final cafe = CafeModel.fromJson({'id': 1, 'calificacion': '4.5'});
    expect(cafe.calificacion, 4.5);
  });
}
