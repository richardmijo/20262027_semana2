import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

import '../utils/cafe_helpers.dart';

class CafeScreen extends StatefulWidget {
  final CafeService? service;

  const CafeScreen({super.key, this.service});

  @override
  State<CafeScreen> createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> {
  late final CafeService _cafeService = widget.service ?? CafeService();

  bool _cargando = true;
  String? _error;
  List<CafeModel> _cafes = [];

  // filtros
  bool _soloWifi = false;
  bool _mejorCalificadas = false;
  int _visitas = 0;

  @override
  void initState() {
    super.initState();
    _cargarCafes();
  }

  Future<void> _cargarCafes() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final resultado = await _cafeService.obtenerCafes();
      if (!mounted) return;

      setState(() {
        _cafes = resultado;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _cafes
        .where(
          (cafe) =>
              (!_soloWifi || cafe.tieneWifi) &&
              (!_mejorCalificadas || cafe.calificacion >= 4.5),
        )
        .toList();
    final (promedio, conWifi) = resumen(_cafes);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafes de Loja'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Badge(
                label: Text('$_visitas'),
                child: Icon(Icons.place_outlined),
              ),
            ),
          ),
        ],
      ),
      body: _cargando
          ? const EstadoCargando()
          : _error != null
          ? Center(
              child: SingleChildScrollView(
                child: EstadoError(
                  mensaje: _error!,
                  onReintentar: _cargarCafes,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _cargarCafes,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: visibles.isEmpty ? 2 : visibles.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return CabeceraResumen(
                      total: _cafes.length,
                      conWifi: conWifi,
                      promedio: promedio,
                      soloWifi: _soloWifi,
                      onToogleWifi: (valor) =>
                          setState(() => _soloWifi = valor),
                      mejorCalificadas: _mejorCalificadas,
                      onCambiarCalificacion: (valor) =>
                          setState(() => _mejorCalificadas = valor),
                    );
                  }
                  if (visibles.isEmpty) {
                    return EstadoVacio(
                      etiquetaAccion: 'Quitar filtros',
                      onAccion: () => setState(() {
                        _soloWifi = false;
                        _mejorCalificadas = false;
                      }),
                    );
                  }
                  return TarjetaCafe(
                    cafe: visibles[index - 1],
                    alVisitar: () => setState(() => _visitas++),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cargando ? null : _cargarCafes,
        label: const Text('Recargar API'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
