import 'package:flutter/material.dart';

class CabeceraResumen extends StatelessWidget {
  final int total;
  final double promedio;
  final int conWifi;
  final bool soloWifi;
  final ValueChanged<bool> onToogleWifi;
  
  
  const CabeceraResumen({super.key, required this.total, required this.promedio, required this.conWifi, required this.soloWifi, required this.onToogleWifi});


  @override
  Widget build(BuildContext context) {
    
    final colores = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.al,     
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: column
      crossAxisAlignment: CrossAxisAlignment.start
      children: [],
    ), //colunm
  }
}