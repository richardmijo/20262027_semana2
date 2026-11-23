import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

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
      if (_cafeService.usandoRespaldo) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('API temporalmente fuera de servicio; mostramos datos locales.'),
          ),
        );
      }
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
    final visibles = _cafes.where((c) =>
        (!_soloWifi || c.tieneWifi) &&
        (!_mejorCalificadas || c.calificacion >= 4.5)).toList();
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
      body: _construirCuerpo(visibles, promedio, conWifi),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cargarCafes,
        label: Text('Recargar API'),
        icon: Icon(Icons.refresh),
      ),
    );
  }

  Widget _construirCuerpo(
    List<CafeModel> visibles,
    double promedio,
    int conWifi,
  ) {
    //Estado 1: cargando
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
        onAccion: () => setState(() {
          _soloWifi = false;
          _mejorCalificadas = false;
        }),
      );
    }

    // Estado 4: los datos
    return RefreshIndicator(
      onRefresh: _cargarCafes,
      child: ListView.builder(
        itemCount: visibles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return CabeceraResumen(
              total: _cafes.length,
              promedio: promedio,
              conWifi: conWifi,
              soloWifi: _soloWifi,
              onToogleWifi: (val) => setState(() => _soloWifi = val),
              mejorCalificadas: _mejorCalificadas,
              onToggleMejorCalificadas: (val) =>
                  setState(() => _mejorCalificadas = val),
            );
          }
          final cafe = visibles[index - 1];
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
