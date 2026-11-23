import 'dart:convert';
import 'dart:io';

import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';

/// Servicio de PRUEBA: no usa internet. Cada llamada a [obtenerCafes]
/// ejecuta la siguiente respuesta de la lista (la última se repite).
/// Sirve para provocar de forma controlada los estados error y vacío.
class ServicioFalso extends CafeService {
  ServicioFalso(this._respuestas);

  final List<Future<List<CafeModel>> Function()> _respuestas;
  int llamadas = 0;

  @override
  Future<List<CafeModel>> obtenerCafes() {
    final indice = llamadas < _respuestas.length
        ? llamadas
        : _respuestas.length - 1;
    llamadas++;
    return _respuestas[indice]();
  }
}

/// Lee el `cafes.json` real del repositorio (el mismo que publica la API).
List<CafeModel> leerCafesReales() {
  final datos =
      jsonDecode(File('cafes.json').readAsStringSync()) as List<dynamic>;
  return datos
      .map((item) => CafeModel.fromJson(item as Map<String, dynamic>))
      .toList();
}
