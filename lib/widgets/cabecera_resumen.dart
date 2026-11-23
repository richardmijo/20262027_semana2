import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final int mostrando;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToogleWifi;
  final bool soloMejorCalificadas;
  final ValueChanged<bool> onToggleMejorCalificadas;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.mostrando,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.onToogleWifi,
    required this.soloMejorCalificadas,
    required this.onToggleMejorCalificadas,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    // Material (en vez de Container con color) para que los interruptores
    // muestren su efecto al tocarlos sobre el fondo de color.
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: colores.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _contenido(context, colores),
        ),
      ),
    );
  }

  Widget _contenido(BuildContext context, ColorScheme colores) {
    return Column(
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
        SizedBox(height: 4),
        Text(
          'Mostrando $mostrando de $total',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Divider(height: 20),
        _FiltroSwitch(
          etiqueta: 'Filtrar solo con Wi-Fi',
          icono: Icons.wifi,
          valor: soloWifi,
          alCambiar: onToogleWifi,
        ),
        _FiltroSwitch(
          etiqueta: 'Mejor calificadas',
          descripcion: 'Calificación de 4,5 o más',
          icono: Icons.star_rounded,
          valor: soloMejorCalificadas,
          alCambiar: onToggleMejorCalificadas,
        ),
      ],
    );
  }
}

/// Fila de filtro: el texto ocupa el espacio libre y puede saltar de línea,
/// así no se desborda aunque el teléfono tenga la letra al máximo.
class _FiltroSwitch extends StatelessWidget {
  final String etiqueta;
  final String? descripcion;
  final IconData icono;
  final bool valor;
  final ValueChanged<bool> alCambiar;

  const _FiltroSwitch({
    required this.etiqueta,
    this.descripcion,
    required this.icono,
    required this.valor,
    required this.alCambiar,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icono),
      title: Text(etiqueta),
      subtitle: descripcion == null ? null : Text(descripcion!),
      value: valor,
      onChanged: alCambiar,
    );
  }
}
