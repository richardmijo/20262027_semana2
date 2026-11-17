import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int totalWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToggleWifi;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.promedio,
    required this.totalWifi,
    required this.soloWifi,
    required this.onToggleWifi,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row  (
            children : [
              Icon(Icons.coffee_rounded, 
              size: 32,
              color: colores.onPrimaryContainer,
              ),
            SizedBox(width: 12,),
            Expanded(child: Text('$total cafeterías disponibles',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colores.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
            ),
            ),
            ],
          ),
          SizedBox(height: 16),
          Text('Calificacion promedio: ${promedio.toStringAsFixed(1)} - $totalWifi con WiFi', 
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colores.onPrimaryContainer,
            ),
          ),
          Divider (height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filtrar solo con Wi-Fi', 
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colores.onPrimaryContainer,
                ),
              ),
              Switch(
                value: soloWifi,
                onChanged: onToggleWifi,
                activeColor: colores.primary,
              ),
            ],


          ),

        

      
          
        ],
        
        )
    );
  }
}

