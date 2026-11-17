import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';

import '../utils/cafe_helpers.dart';

class CafeScreen extends StatefulWidget {
  const CafeScreen({super.key});

  @override
  State<CafeScreen> createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> {
  final CafeService _cafeService = CafeService();

  bool _cargando = true;
  String? _error;
  List<CafeModel> _cafes = [];

  //filtros
  bool _soloWifi = false;
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
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _cafes.where((c) => !_soloWifi || c.tieneWifi).toList();
    final (promedio, conWifi) = resumen(_cafes);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafés de LOja'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Badge(
                label: Text('Visitas: $_visitas'),
                child: Icon(Icons.place_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_cargando && _error == null)
            CabeceraResumen(
              total: _cafes.length,
              promedio: promedio,
              conWifi: conWifi,
              soloWifi: _soloWifi,
              onToogleWifi: (value) {
                setState(() {
                  _soloWifi = value;
                });
              },
            ),
          Expanded(child: _construitCuerpo(visibles)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cargarCafes,
        label: Text('Recargar Api'),
        icon: Icon(Icons.refresh),
      ),
    );
  }

  Widget _construitCuerpo(List<CafeModel> visibles) {
    if (_cargando) {
      return EstadoCargando();
    }
    // estado de error
    if (_error != null) {
      return EstadoError(mensaje: _error!, onReintentar: _cargarCafes);
    }
    // estado vacio
    if (visibles.isEmpty) {
      return EstadoVacio(
        onAccion: () => setState(() {
          _soloWifi = false;
        }),
        // estado los datos que vamos a presentar
      );
    }

    // estado los datos que vamos a presentar
    return RefreshIndicator(
      onRefresh: _CargarCafes,
      child: ListView.builder(
        itemCount: visibles.length,
        itemBuilder: (context, index) {
          final cafe = visibles[index];
          return TartjetaCafe(
            cafe: cafe,
            alVisitar: () {
              setState(() {
                _visitas++;
              });
            },
          );
        },
      ),
    );
  }
}
