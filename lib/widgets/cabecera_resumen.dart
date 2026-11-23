import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToogleWifi;
  // Segundo filtro: "Mejor calificadas" (4,5 o más)
  final bool soloMejores;
  final ValueChanged<bool> onToggleMejores;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.onToogleWifi,
    required this.soloMejores,
    required this.onToggleMejores,
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
          _filaFiltro('Filtrar solo con Wi-Fi', soloWifi, onToogleWifi),
          _filaFiltro(
            'Mejor calificadas (4,5 o más)',
            soloMejores,
            onToggleMejores,
          ),
        ],
      ),
    );
  }

  // Expanded evita la franja amarilla cuando la letra del teléfono es grande
  Widget _filaFiltro(String texto, bool valor, ValueChanged<bool> alCambiar) {
    return Row(
      children: [
        Expanded(child: Text(texto)),
        Switch(value: valor, onChanged: alCambiar),
      ],
    );
  }
}
