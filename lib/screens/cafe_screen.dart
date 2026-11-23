import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

import '../utils/cafe_helpers.dart';

// Nota mínima para el filtro "Mejor calificadas".
// Para probar el estado vacío, cámbiala a 5.0 temporalmente y vuelve a 4.5.
const double notaMinima = 4.5;

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
  bool _soloMejorCalificadas = false;
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
    // Los dos filtros se aplican al mismo tiempo (AND)
    final visibles = _cafes.where((cafe) {
      final cumpleWifi = !_soloWifi || cafe.tieneWifi;
      final cumpleNota =
          !_soloMejorCalificadas || cafe.calificacion >= notaMinima;
      return cumpleWifi && cumpleNota;
    }).toList();
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
              total: _cafes.length,
              promedio: promedio,
              conWifi: conWifi,
              soloWifi: _soloWifi,
              onToogleWifi: (val) => setState(() {
                _soloWifi = val;
              }),
              soloMejorCalificadas: _soloMejorCalificadas,
              onToogleMejorCalificadas: (val) => setState(() {
                _soloMejorCalificadas = val;
              }),
              notaMinima: notaMinima,
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
    // Estado 1: cargando
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
        mensaje: 'No hay cafeterías con estos filtros. Prueba quitando uno.',
        etiquetaAccion: 'Quitar filtros',
        onAccion: () => setState(() {
          _soloWifi = false;
          _soloMejorCalificadas = false;
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
