// extensiones
import 'package:semana2/models/cafe_model.dart';

extension Moneda on double {
  String get usd => '\$${toStringAsFixed(2)}';
}

// SWITCH

String etiqueta(double? calificacion) => switch (calificacion) {
  null => 'Sin reseñas todavía',
  double c when c >= 4.7 => 'Imperdible',
  double c when c >= 4.0 => 'Recomendado',
  _ => 'Para probar',
};

// FILTROS

/// Calificación mínima (inclusiva) para el filtro "Mejor calificadas".
const double calificacionMinimaDestacada = 4.5;

/// `true` solo si la cafetería tiene calificación y es >= 4.5.
/// Una cafetería sin calificación (`null`) no cuenta como mejor calificada.
bool esMejorCalificada(CafeModel cafe) {
  final calificacion = cafe.calificacion;
  return calificacion != null && calificacion >= calificacionMinimaDestacada;
}

/// Aplica los dos filtros a la vez. Cada filtro apagado deja pasar a todas;
/// con ambos encendidos la cafetería debe cumplir las dos condiciones (&&).
List<CafeModel> filtrarCafes(
  List<CafeModel> cafes, {
  required bool soloWifi,
  required bool soloMejorCalificadas,
}) {
  return cafes.where((cafe) {
    final cumpleWifi = !soloWifi || cafe.tieneWifi;
    final cumpleCalificacion = !soloMejorCalificadas || esMejorCalificada(cafe);
    return cumpleWifi && cumpleCalificacion;
  }).toList();
}

// RECORDS
(double promedio, int conWifi) resumen(List<CafeModel> lista) {
  final calificados = lista
      .map((c) => c.calificacion)
      .whereType<double>()
      .toList();

  final promedio = calificados.isEmpty
      ? 0.0
      : calificados.reduce((a, b) => a + b) / calificados.length;

  final conWifi = lista.where((c) => c.tieneWifi).length;

  return (promedio, conWifi);
}
