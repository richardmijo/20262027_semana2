import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

import '../utils/cafe_helpers.dart';

class CafeScreen extends StatefulWidget {
  /// Servicio opcional: en la app se usa el real; en las pruebas se pasa uno
  /// controlado para poder provocar los estados vacío y error.
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

  void _limpiarFiltros() {
    setState(() {
      _soloWifi = false;
      _soloMejorCalificadas = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: _construirCuerpo(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cargarCafes,
        label: Text('Recargar API'),
        icon: Icon(Icons.refresh),
      ),
    );
  }

  Widget _construirCuerpo() {
    // Estado 1: cargando
    if (_cargando) {
      return EstadoCargando();
    }
    // Estado 2: error de carga (red, tiempo de espera, servidor o formato)
    if (_error != null) {
      return EstadoError(mensaje: _error!, onReintentar: _cargarCafes);
    }

    final visibles = filtrarCafes(
      _cafes,
      soloWifi: _soloWifi,
      soloMejorCalificadas: _soloMejorCalificadas,
    );
    final (promedio, conWifi) = resumen(_cafes);

    // La cabecera va dentro del scroll: con letra grande no se desborda.
    return RefreshIndicator(
      onRefresh: _cargarCafes,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: CabeceraResumen(
              total: _cafes.length,
              mostrando: visibles.length,
              promedio: promedio,
              conWifi: conWifi,
              soloWifi: _soloWifi,
              onToogleWifi: (val) => setState(() {
                _soloWifi = val;
              }),
              soloMejorCalificadas: _soloMejorCalificadas,
              onToggleMejorCalificadas: (val) => setState(() {
                _soloMejorCalificadas = val;
              }),
            ),
          ),
          // Estado 3: datos cargados, pero ningún resultado con estos filtros
          if (visibles.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EstadoVacio(onAccion: _limpiarFiltros),
            )
          // Estado 4: los datos
          else
            SliverList.builder(
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
          // Espacio para que el botón flotante no tape la última tarjeta.
          const SliverToBoxAdapter(child: SizedBox(height: 88)),
        ],
      ),
    );
  }
}
