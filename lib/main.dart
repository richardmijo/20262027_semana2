import 'package:flutter/material.dart';
import 'package:semana2/screens/cafe_screen.dart';

void main() => runApp(const CafesLojaApp());

class CafesLojaApp extends StatelessWidget {
  const CafesLojaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cafés de Loja',
      theme: ThemeData(colorSchemeSeed: Colors.amber, useMaterial3: true),
      home: const CafeScreen(),
    );
  }
}
