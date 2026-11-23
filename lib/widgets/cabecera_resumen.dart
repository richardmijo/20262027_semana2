import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToogleWifi;
  final bool mejorCalificadas;
  final ValueChanged<bool> onToogleMejorCalificadas;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.onToogleWifi,
    required this.mejorCalificadas,
    required this.onToogleMejorCalificadas,
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
              const SizedBox(width: 12),

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
          const SizedBox(height: 16),
          Text(
            'Calificacion promedio ${promedio.toStringAsFixed(1)} - $conWifi con Wi-Fi',
            style: TextStyle(color: colores.onPrimaryContainer),
          ),
          const Divider(height: 20),
          _FilaFiltro(
            etiqueta: 'Filtrar solo con Wi-Fi',
            valor: soloWifi,
            onCambio: onToogleWifi,
          ),
          _FilaFiltro(
            etiqueta: 'Solo mejor calificadas (4.5+)',
            valor: mejorCalificadas,
            onCambio: onToogleMejorCalificadas,
          ),
        ],
      ),
    );
  }
}

class _FilaFiltro extends StatelessWidget {
  final String etiqueta;
  final bool valor;
  final ValueChanged<bool> onCambio;

  const _FilaFiltro({
    required this.etiqueta,
    required this.valor,
    required this.onCambio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(etiqueta)),
        Switch(value: valor, onChanged: onCambio),
      ],
    );
  }
}
