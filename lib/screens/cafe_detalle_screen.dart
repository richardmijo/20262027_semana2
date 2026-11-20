import 'package:flutter/material.dart';

import '../models/cafe_model.dart';
import '../utils/cafe_helpers.dart';

class CafeDetalleScreen extends StatefulWidget {
  const CafeDetalleScreen({
    super.key,
    required this.cafe,
    required this.favoritoInicial,
    required this.alCambiarFavorito,
  });

  final CafeModel cafe;
  final bool favoritoInicial;
  final ValueChanged<bool> alCambiarFavorito;

  @override
  State<CafeDetalleScreen> createState() => _CafeDetalleScreenState();
}

class _CafeDetalleScreenState extends State<CafeDetalleScreen> {
  late bool _favorito = widget.favoritoInicial;

  @override
  Widget build(BuildContext context) {
    final cafe = widget.cafe;
    return Scaffold(
      appBar: AppBar(title: Text(cafe.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(cafe.descripcion),
          const SizedBox(height: 16),
          Text('Ingredientes: ${cafe.resumenIngredients}'),
          Text('Precio: ${cafe.precio.usd}'),
          Text('Calificación: ${cafe.calificacion.toStringAsFixed(1)}'),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Favorito'),
            value: _favorito,
            onChanged: (valor) {
              setState(() => _favorito = valor);
              widget.alCambiarFavorito(valor);
            },
          ),
        ],
      ),
    );
  }
}
