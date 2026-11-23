import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final int mostradas;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final bool soloMejoresCalificadas;
  final ValueChanged<bool> onToggleWifi;
  final ValueChanged<bool> onToggleMejoresCalificadas;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.mostradas,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.soloMejoresCalificadas,
    required this.onToggleWifi,
    required this.onToggleMejoresCalificadas,
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
                  mostradas == total
                      ? '$total Cafeterias disponibles'
                      : '$mostradas de $total Cafeterias',
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
          ),
          const Divider(height: 20),
          _FilaFiltro(
            texto: 'Filtrar solo con Wi-Fi',
            valor: soloWifi,
            onChanged: onToggleWifi,
          ),
          _FilaFiltro(
            texto: 'Mejor calificadas',
            valor: soloMejoresCalificadas,
            onChanged: onToggleMejoresCalificadas,
          ),
        ],
      ),
    );
  }
}

class _FilaFiltro extends StatelessWidget {
  final String texto;
  final bool valor;
  final ValueChanged<bool> onChanged;

  const _FilaFiltro({
    required this.texto,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(texto)),
        const SizedBox(width: 8),
        Switch(value: valor, onChanged: onChanged),
      ],
    );
  }
}
