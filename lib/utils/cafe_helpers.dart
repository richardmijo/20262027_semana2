// extensiones
import 'package:semana2/models/cafe_model.dart';

const double calificacionMinima = 4.5;

extension Moneda on double {
  String get usd => '\$${toStringAsFixed(2)}';
}

// FILTROS COMBINADOS
List<CafeModel> filtrarCafes(
  List<CafeModel> lista, {
  required bool soloWifi,
  required bool mejorCalificadas,
}) {
  return lista
      .where(
        (c) =>
            (!soloWifi || c.tieneWifi) &&
            (!mejorCalificadas || c.calificacion >= calificacionMinima),
      )
      .toList();
}

// SWITCH

String etiqueta(double? calificacion) => switch (calificacion) {
  null => 'Sin reseñas todavía',
  double c when c >= 4.7 => 'Imperdible',
  double c when c >= 4.0 => 'Recomendado',
  _ => 'Para probar',
};

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
