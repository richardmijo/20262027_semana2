import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/utils/cafe_helpers.dart';

CafeModel cafe({
  required int id,
  required bool wifi,
  required double calificacion,
}) {
  return CafeModel(
    id: id,
    nombre: 'Cafe $id',
    descripcion: 'Descripcion $id',
    ingredientes: const [],
    calificacion: calificacion,
    tieneWifi: wifi,
  );
}

void main() {
  final cafes = [
    cafe(id: 1, wifi: true, calificacion: 4.6),
    cafe(id: 2, wifi: false, calificacion: 4.9),
    cafe(id: 3, wifi: true, calificacion: 4.0),
    cafe(id: 4, wifi: false, calificacion: 3.0),
  ];

  group('filtrarCafes', () {
    test('sin filtros devuelve todos', () {
      final resultado = filtrarCafes(
        cafes,
        soloWifi: false,
        mejorCalificadas: false,
      );
      expect(resultado.length, 4);
    });

    test('solo Wi-Fi', () {
      final resultado = filtrarCafes(
        cafes,
        soloWifi: true,
        mejorCalificadas: false,
      );
      expect(resultado.map((c) => c.id), [1, 3]);
    });

    test('solo mejor calificadas (>= 4.5)', () {
      final resultado = filtrarCafes(
        cafes,
        soloWifi: false,
        mejorCalificadas: true,
      );
      expect(resultado.map((c) => c.id), [1, 2]);
    });

    test('ambos filtros se combinan', () {
      final resultado = filtrarCafes(
        cafes,
        soloWifi: true,
        mejorCalificadas: true,
      );
      expect(resultado.map((c) => c.id), [1]);
    });

    test('ambos filtros sin coincidencias devuelve vacio', () {
      final resultado = filtrarCafes(
        [cafe(id: 5, wifi: true, calificacion: 4.0)],
        soloWifi: true,
        mejorCalificadas: true,
      );
      expect(resultado, isEmpty);
    });
  });
}
