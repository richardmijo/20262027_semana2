import 'package:flutter_test/flutter_test.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/utils/cafe_helpers.dart';

import 'servicio_falso.dart';

CafeModel _cafe(int id, {double? calificacion, bool wifi = false}) => CafeModel(
  id: id,
  nombre: 'Cafe $id',
  descripcion: '',
  ingredientes: const [],
  calificacion: calificacion,
  tieneWifi: wifi,
);

void main() {
  group('Filtros con el cafes.json real', () {
    final cafes = leerCafesReales();

    List<CafeModel> filtrar({required bool wifi, required bool mejor}) =>
        filtrarCafes(cafes, soloWifi: wifi, soloMejorCalificadas: mejor);

    test('el JSON real trae 28 cafeterías', () {
      expect(cafes, hasLength(28));
    });

    test('ningún filtro activado: muestra todas', () {
      expect(filtrar(wifi: false, mejor: false), hasLength(28));
    });

    test('solo Wi-Fi: 20 cafeterías, todas con Wi-Fi', () {
      final resultado = filtrar(wifi: true, mejor: false);
      expect(resultado, hasLength(20));
      expect(resultado.every((c) => c.tieneWifi), isTrue);
    });

    test('solo Mejor calificadas: 18 cafeterías, todas >= 4.5', () {
      final resultado = filtrar(wifi: false, mejor: true);
      expect(resultado, hasLength(18));
      expect(resultado.every((c) => c.calificacion! >= 4.5), isTrue);
    });

    test('ambos filtros: 16 cafeterías que cumplen las dos condiciones', () {
      final resultado = filtrar(wifi: true, mejor: true);
      expect(resultado, hasLength(16));
      expect(
        resultado.every((c) => c.tieneWifi && c.calificacion! >= 4.5),
        isTrue,
      );
    });
  });

  group('Límite de Mejor calificadas', () {
    test('4.5 entra (límite inclusivo) y 4.4 no entra', () {
      expect(esMejorCalificada(_cafe(1, calificacion: 4.5)), isTrue);
      expect(esMejorCalificada(_cafe(2, calificacion: 4.4)), isFalse);
      expect(esMejorCalificada(_cafe(3, calificacion: 4.9)), isTrue);
    });

    test('una cafetería sin calificación nunca es mejor calificada', () {
      expect(esMejorCalificada(_cafe(1)), isFalse);
      final resultado = filtrarCafes(
        [_cafe(1), _cafe(2, calificacion: 4.6)],
        soloWifi: false,
        soloMejorCalificadas: true,
      );
      expect(resultado.map((c) => c.id), [2]);
    });

    test('combinación que no deja resultados devuelve lista vacía', () {
      final resultado = filtrarCafes(
        [
          _cafe(1, calificacion: 4.4, wifi: true),
          _cafe(2, calificacion: 4.8, wifi: false),
        ],
        soloWifi: true,
        soloMejorCalificadas: true,
      );
      expect(resultado, isEmpty);
    });
  });
}
