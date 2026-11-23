import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToogleWifi;
  final bool soloMejorCalificadas;
  final ValueChanged<bool> onToogleMejorCalificadas;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.onToogleWifi,
    required this.soloMejorCalificadas,
    required this.onToogleMejorCalificadas,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    // La cabecera ocupa espacio fijo sobre la lista: se limita su escalado de
    // texto para que con la letra al máximo no desborde la pantalla ni deje
    // la lista sin espacio.
    final escala = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: escala),
      child: _construir(context, colores),
    );
  }

  Widget _construir(BuildContext context, ColorScheme colores) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
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
          Text(
            'Calificacion promedio ${promedio.toStringAsFixed(1)} - $conWifi con Wi-Fi',
          ),
          Divider(height: 20),
          Row(
            children: [
              const Expanded(child: Text('Filtrar solo con Wi-Fi')),
              Switch(value: soloWifi, onChanged: onToogleWifi),
            ],
          ),
          Row(
            children: [
              const Expanded(child: Text('Mejor calificadas')),
              Switch(
                value: soloMejorCalificadas,
                onChanged: onToogleMejorCalificadas,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
