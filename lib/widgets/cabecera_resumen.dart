import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToggleWifi;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.onToggleWifi,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
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
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filtrar solo con Wi-Fi'),
              Switch(value: soloWifi, onChanged: onToggleWifi),
            ],
          ),
        ],
      ),
    );
  }
}
