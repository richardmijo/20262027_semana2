import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

import '../utils/cafe_helpers.dart';

class CafeScreen extends StatefulWidget {
  final CafeService? servicio;

  const CafeScreen({super.key, this.servicio});

  @override
  State<CafeScreen> createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> {
  late final CafeService _cafeService = widget.servicio ?? CafeService();

  bool _cargando = true;
  String? _error;
  List<CafeModel> _cafes = [];

  // filtros
  bool _soloWifi = false;
  bool _soloMejores = false;

  // Solo para demostraciones en modo debug: fuerza un resultado vacío sin
  // alterar los datos ni las reglas de los filtros.
  bool _demoSinResultados = false;
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
    final visibles = _demoSinResultados
        ? <CafeModel>[]
        : filtrarCafes(
            _cafes,
            soloWifi: _soloWifi,
            soloMejoresCalificadas: _soloMejores,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafes de Loja'),
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: 'Demo: simular sin resultados',
              isSelected: _demoSinResultados,
              icon: const Icon(Icons.science_outlined),
              selectedIcon: const Icon(Icons.science),
              onPressed: () =>
                  setState(() => _demoSinResultados = !_demoSinResultados),
            ),
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
      body: _construirCuerpo(visibles),
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
    final (promedio, conWifi) = resumen(visibles);
    final cabecera = CabeceraResumen(
      total: _cafes.length,
      mostradas: visibles.length,
      promedio: promedio,
      conWifi: conWifi,
      soloWifi: _soloWifi,
      soloMejoresCalificadas: _soloMejores,
      onToggleWifi: (val) => setState(() => _soloWifi = val),
      onToggleMejoresCalificadas: (val) => setState(() => _soloMejores = val),
    );

    // Estado 3: Vacio por filtros (la cabecera sigue visible)
    if (visibles.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                cabecera,
                if (_demoSinResultados)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Chip(
                      label: Text('Modo demo: resultado vacío simulado'),
                    ),
                  ),
                const SizedBox(height: 24),
                EstadoVacio(
                  onAccion: () => setState(() {
                    _soloWifi = false;
                    _soloMejores = false;
                    _demoSinResultados = false;
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // Estado 4: los datos
    return RefreshIndicator(
      onRefresh: _cargarCafes,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: visibles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return cabecera;
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
