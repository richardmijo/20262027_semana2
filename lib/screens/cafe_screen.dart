import 'dart:async';

import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

import '../utils/cafe_helpers.dart';
import '../utils/conexion.dart';

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

  // filtros
  bool _soloWifi = false;
  bool _soloMejores = false;
  int _visitas = 0;

  StreamSubscription<bool>? _conexionSub;

  @override
  void initState() {
    super.initState();
    _cargarCafes();

    // Reacciona solo cuando se pierde o vuelve la conexión.
    _conexionSub = cambiosDeConexion().listen((hayConexion) {
      if (!mounted) return;
      if (hayConexion) {
        // Volvió el internet: si estaba en error, recarga automáticamente.
        if (_error != null) _cargarCafes();
      } else {
        // Se perdió el internet: muestra el estado de error sin recargar.
        setState(() {
          _error = 'No hay conexión a internet';
          _cargando = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _conexionSub?.cancel();
    super.dispose();
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
    // Los dos filtros se combinan con AND: un café debe cumplir los que estén activos.
    final visibles = _cafes
        .where((c) => !_soloWifi || c.tieneWifi)
        .where((c) => !_soloMejores || c.calificacion >= 4.5)
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
      body: Column(
        children: [
          if (!_cargando && _error == null)
            CabeceraResumen(
              mostrando: visibles.length,
              total: _cafes.length,
              promedio: promedio,
              conWifi: conWifi,
              soloWifi: _soloWifi,
              onToogleWifi: (val) => setState(() {
                _soloWifi = val;
              }),
              soloMejores: _soloMejores,
              onToogleMejores: (val) => setState(() {
                _soloMejores = val;
              }),
            ),
          Expanded(child: _construirCuerpo(visibles)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cargarCafes,
        label: Text('Recargar API'),
        icon: Icon(Icons.refresh),
      ),
    );
  }

  Widget _construirCuerpo(List<CafeModel> visibles) {
    // Etado 1: cargando
    if (_cargando) {
      return EstadoCargando();
    }
    // Estado 2: Error
    if (_error != null) {
      return EstadoError(mensaje: _error!, onReintentar: _cargarCafes);
    }
    // Estado 3: Vacio
    if (visibles.isEmpty) {
      return EstadoVacio(
        etiquetaAccion: 'Quitar filtros',
        onAccion: () => setState(() {
          _soloWifi = false;
          _soloMejores = false;
        }),
      );
    }
    // Estado 4: los datos
    return RefreshIndicator(
      onRefresh: _cargarCafes,
      child: ListView.builder(
        itemCount: visibles.length,
        itemBuilder: (context, index) {
          final cafe = visibles[index];
          return TarjetaCafe(
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
