import 'package:flutter/material.dart';

/*void main() {
  runApp(const MyApp());
}*/

void main() => runApp(CafesLojaApp());

enum Barrio {
  centro(codigo: 'B01', nombre: 'Centro'),
  sanSebastian(nombre: 'San Sebastian', codigo: 'B02'),
  elValle(codigo: 'B03', nombre: 'El Valle'),
  zamorahuayco(codigo: 'B04', nombre: 'Zamora Huayco');

  const Barrio({
    required this.codigo,
    required this.nombre,
  }); // parametros por nombre

  final String codigo;
  final String nombre;
}

class Cafe {
  final String nombre;
  final Barrio barrio;
  final double precio;
  final double? calificacion;
  final bool wifi;

  const Cafe({
    required this.nombre,
    required this.barrio,
    this.precio = 1.50,
    this.calificacion,
    this.wifi = false,
  });
}

// extensiones
extension Moneda on double {
  String get usd => '\$${toStringAsFixed(2)}';
}

// SWITCH

String etiqueta(double? calificacion) => switch (calificacion) {
  null => 'Sin reseñas todavía',
  double c when c >= 4.5 => 'Imperdible',
  double c when c >= 3.5 => 'Recomendado',
  _ => 'Para probar',
};

// RECORDS
(double promedio, int conWifi) resumen(List<Cafe> lista) {
  final calificados = lista
      .map((c) => c.calificacion)
      .whereType<double>()
      .toList();

  final promedio = calificados.isEmpty
      ? 0.0
      : calificados.reduce((a, b) => a + b) / calificados.length;

  final conWifi = lista.where((c) => c.wifi).length;

  return (promedio, conWifi);
}

const cafes = [
  Cafe(
    nombre: 'Café de la Puerta',
    barrio: Barrio.centro,
    calificacion: 4.7,
    wifi: true,
  ),
  Cafe(
    barrio: Barrio.elValle,
    nombre: 'Cafe el Valle',
    precio: 2.25,
    calificacion: 4.2,
  ),
  Cafe(
    barrio: Barrio.sanSebastian,
    nombre: 'Rincón de San Sebastián',
    wifi: true,
  ),
  Cafe(
    nombre: 'Café del Zamora',
    barrio: Barrio.zamorahuayco,
    precio: 1.25,
    calificacion: 3.1,
    wifi: true,
  ),
];

class CafesLojaApp extends StatelessWidget {
  const CafesLojaApp({super.key});
  // parametros
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.amber),
      home: PantallaCafes(),
    );
  }
}

class PantallaCafes extends StatefulWidget {
  const PantallaCafes({super.key});

  @override
  _PantallaCafesState createState() => _PantallaCafesState();
}

class _PantallaCafesState extends State<PantallaCafes> {
  bool _soloWifi = false;
  int _visitas = 0;

  @override
  Widget build(BuildContext context) {
    final visibles = cafes.where((c) => !_soloWifi || c.wifi).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafés de Loja'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: Text('Visitas: $_visitas')),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabecera Cafes
        ],
      ),
    );
  }
}
