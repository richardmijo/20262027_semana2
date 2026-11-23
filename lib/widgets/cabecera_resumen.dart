import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToogleWifi;
  final bool soloMejores;
  final ValueChanged<bool> onToogleMejores;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.onToogleWifi,
    required this.soloMejores,
    required this.onToogleMejores,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Filtrar solo con Wi-Fi')),
              Switch(value: soloWifi, onChanged: onToogleWifi),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Mejor calificadas (4.5 o mas)')),
              Switch(value: soloMejores, onChanged: onToogleMejores),
            ],
          ),
        ],
      ),
    );
  }
}
