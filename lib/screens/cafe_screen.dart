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

  // filtros
  bool _soloWifi = false;
  bool _soloMejores = false; // calificación >= 4.5
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
    // Los dos filtros se combinan (AND): solo pasan las que cumplen ambos
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
      // CustomScrollView: la cabecera se desplaza junto con la lista,
      // así con letra/zoom grande nada se desborda (sin franja amarilla)
      body: RefreshIndicator(
        onRefresh: _cargarCafes,
        child: CustomScrollView(
          slivers: [
            if (!_cargando && _error == null)
              SliverToBoxAdapter(
                child: CabeceraResumen(
                  total: visibles.length, // cambia según los filtros activos
                  promedio: promedio,
                  conWifi: conWifi,
                  soloWifi: _soloWifi,
                  onToogleWifi: (val) => setState(() {
                    _soloWifi = val;
                  }),
                  soloMejores: _soloMejores,
                  onToggleMejores: (val) => setState(() {
                    _soloMejores = val;
                  }),
                ),
              ),
            _construirCuerpo(visibles),
            // espacio para que el botón flotante no tape la última tarjeta
            const SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
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
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EstadoCargando(),
      );
    }
    // Estado 2: Error
    if (_error != null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EstadoError(mensaje: _error!, onReintentar: _cargarCafes),
      );
    }
    // Estado 3: Vacio
    if (visibles.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EstadoVacio(
          etiquetaAccion: 'Quitar filtros',
          onAccion: () => setState(() {
            _soloWifi = false;
            _soloMejores = false;
          }),
        ),
      );
    }
    // Estado 4: los datos
    return SliverList.builder(
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
    );
  }
}
