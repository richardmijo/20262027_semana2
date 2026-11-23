import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToogleWifi;
  final bool soloMejorCalificadas;
  final ValueChanged<bool> onToogleMejorCalificadas;
  final double notaMinima;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.onToogleWifi,
    required this.soloMejorCalificadas,
    required this.onToogleMejorCalificadas,
    required this.notaMinima,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: colores.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.coffee_rounded,
                size: 36,
                color: colores.onPrimaryContainer,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$total Cafeterias disponibles',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colores.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Calificacion promedio ${promedio.toStringAsFixed(1)} - $conWifi con Wi-Fi',
              maxLines: 2,
            ),
          ),
          Divider(height: 20),
          Column(
            children: [
              _filaSwitch(
                texto: 'Filtrar solo con Wi-Fi',
                valor: soloWifi,
                alCambiar: onToogleWifi,
              ),
              _filaSwitch(
                texto: 'Mejor calificadas (${notaMinima.toStringAsFixed(1)}+)',
                valor: soloMejorCalificadas,
                alCambiar: onToogleMejorCalificadas,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Una fila con texto y switch. El Expanded evita que se desborde
  // cuando la letra del celular está grande.
  Widget _filaSwitch({
    required String texto,
    required bool valor,
    required ValueChanged<bool> alCambiar,
  }) {
    return Row(
      children: [
        Expanded(child: Text(texto)),
        const SizedBox(width: 8),
        Switch(value: valor, onChanged: alCambiar),
      ],
    );
  }
}
