import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/utils/cafe_helpers.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

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
    final visibles = _cafes.where((cafe) {
      final cumpleWifi = !_soloWifi || cafe.tieneWifi;
      final cumpleCalificacion =
          !_soloMejorCalificadas || cafe.calificacion >= 4.5;
      return cumpleWifi && cumpleCalificacion;
    }).toList();
    final (promedio, conWifi) = resumen(visibles);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafés de Loja'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Badge(
                label: Text('$_visitas'),
                child: const Icon(Icons.place_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_cargando && _error == null)
            CabeceraResumen(
              total: visibles.length,
              promedio: promedio,
              conWifi: conWifi,
              soloWifi: _soloWifi,
              soloMejorCalificadas: _soloMejorCalificadas,
              onToogleWifi: (value) => setState(() {
                _soloWifi = value;
              }),
              onToogleMejorCalificadas: (value) => setState(() {
                _soloMejorCalificadas = value;
              }),
            ),
          Expanded(child: _construirCuerpo(visibles)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cargarCafes,
        label: const Text('Recargar API'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _construirCuerpo(List<CafeModel> visibles) {
    if (_cargando) return const EstadoCargando();
    if (_error != null) {
      return EstadoError(mensaje: _error!, onReintentar: _cargarCafes);
    }
    if (visibles.isEmpty) {
      return EstadoVacio(
        onAccion: () => setState(() {
          _soloWifi = false;
          _soloMejorCalificadas = false;
        }),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarCafes,
      child: ListView.builder(
        itemCount: visibles.length,
        itemBuilder: (context, index) {
          final cafe = visibles[index];
          return TarjetaCafe(
            cafe: cafe,
            alVisitar: () => setState(() {
              _visitas++;
            }),
          );
        },
      ),
    );
  }
}
