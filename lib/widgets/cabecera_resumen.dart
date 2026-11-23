import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final bool soloMejorCalificadas;
  final ValueChanged<bool> onToogleWifi;
  final ValueChanged<bool> onToogleMejorCalificadas;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.soloMejorCalificadas,
    required this.onToogleWifi,
    required this.onToogleMejorCalificadas,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colores.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.coffee, size: 36, color: colores.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$total Cafeterias disponibles',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colores.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Calificacion promedio: ${promedio.toStringAsFixed(1)} - '
            '$conWifi con Wi-Fi',
          ),
          Divider(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Filtrar solo con Wi-Fi'),
                  Switch(value: soloWifi, onChanged: onToogleWifi),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Mejor calificadas'),
                  Switch(
                    value: soloMejorCalificadas,
                    onChanged: onToogleMejorCalificadas,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
