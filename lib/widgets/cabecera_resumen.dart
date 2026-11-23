import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final int mostrando;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToogleWifi;

  final bool mejorCalificadas;
  final ValueChanged<bool> onCambiarCalificacion;

  const CabeceraResumen({
    super.key,
    required this.mejorCalificadas,
    required this.onCambiarCalificacion,
    required this.total,
    required this.mostrando,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.onToogleWifi,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: colores.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      mostrando == total
                          ? '$total Cafeterias disponibles'
                          : 'Mostrando $mostrando de $total cafeterias',
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
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Filtrar solo con Wi-Fi'),
                value: soloWifi,
                onChanged: onToogleWifi,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mejor calificadas'),
                value: mejorCalificadas,
                onChanged: onCambiarCalificacion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
