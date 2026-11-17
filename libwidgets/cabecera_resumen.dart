import 'package:flutter/material.dart';

import '../models/cafe_model.dart';
import '../utils/cafe_helpers.dart';

/// Cabecera que muestra un resumen de la lista de cafés:
/// calificación promedio y cuántos tienen Wi-Fi.
class CabeceraResumen extends StatelessWidget {
  final List<CafeModel> cafes;

  const CabeceraResumen({super.key, required this.cafes});

  @override
  Widget build(BuildContext context) {
    final (promedio, conWifi) = resumen(cafes);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        border: Border(
          bottom: BorderSide(color: Colors.amber.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Valor(
            icono: Icons.star,
            valor: promedio.toStringAsFixed(1),
            etiqueta: 'Calificación promedio',
          ),
          _Valor(
            icono: Icons.wifi,
            valor: conWifi.toString(),
            etiqueta: 'Con Wi‑Fi',
          ),
        ],
      ),
    );
  }
}

class _Valor extends StatelessWidget {
  final/icono;
  final String valor;
  final String etiqueta;

  const _Valor({
    required this.icono,
    required this.valor,
    required this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: Colors.amber[800]),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          etiqueta,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}