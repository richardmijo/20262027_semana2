import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToogleWifi;

  const CabeceraResumen({
    super.key,
    required this.total,
    required this.promedio,
    required this.conWifi,
    required this.soloWifi,
    required this.onToogleWifi,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final colores = Theme.of(context).colorScheme; //busca el tema de la aplicación y obtiene la paleta de colores

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //dependiendo la configuración del teléfono, el texto puede estar alineado a la izquierda o a la derecha
        children: [
          Row(
            children:[
=======
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
>>>>>>> origin/main
              Icon(
                Icons.coffee_rounded,
                size: 36,
                color: colores.onPrimaryContainer,
              ),
              SizedBox(width: 12),

<<<<<<< HEAD
              Expanded(child: Text('$total Cafeterías disponibles', 
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color:colores.onPrimaryContainer,
              fontWeight: FontWeight.bold),)
              ),
            ]
          ),
        SizedBox(height: 16),
        Text('Calificación promedio ${promedio.toStringAsFixed(1)} - $conWifi con Wi-fi',
        ),
        Divider(height:20,),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween, //ocupar todo el espacio de forma vertical y separar los elementos
         children: [
          Text('Filtrar solo con Wi-fi'),
          Switch(value:soloWifi, onChanged: onToogleWifi)
         ],
         ),
=======
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
              Text('Filtrar solo con Wi-Fi'),
              Switch(value: soloWifi, onChanged: onToogleWifi),
            ],
          ),
>>>>>>> origin/main
        ],
      ),
    );
  }
}
