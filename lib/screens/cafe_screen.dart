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

  String get _mensajeFiltrosVacios {
    if (_soloWifi && _mejorCalificadas) {
      return 'No hay cafeterías con Wi-Fi y calificación de 4.5 o más.';
    }
    if (_soloWifi) {
      return 'No hay cafeterías con Wi-Fi disponible.';
    }
    if (_mejorCalificadas) {
      return 'No hay cafeterías con calificación de 4.5 o más.';
    }
    return 'No hay cafeterías para mostrar.';
  }

  @override
  Widget build(BuildContext context) {
    final visibles = filtrarCafes(
      _cafes,
      soloWifi: _soloWifi,
      mejorCalificadas: _mejorCalificadas,
    );
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
    // Etado 1: cargando
    if (_cargando) {
      return const EstadoCargando();
    }
    // Estado 2: Error
    if (_error != null) {
      return EstadoError(mensaje: _error!, onReintentar: _cargarCafes);
    }

    // La cabecera viaja dentro del scroll para soportar letra grande sin
    // desbordar la pantalla.
    final cabecera = CabeceraResumen(
      total: _cafes.length,
      promedio: promedio,
      conWifi: conWifi,
      soloWifi: _soloWifi,
      mejorCalificadas: _mejorCalificadas,
      onToogleWifi: (val) => setState(() {
        _soloWifi = val;
      }),
      onToogleMejorCalificadas: (val) => setState(() {
        _mejorCalificadas = val;
      }),
    );

    return RefreshIndicator(
      onRefresh: _cargarCafes,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: cabecera),
          // Estado 3: vacio (con cabecera visible para poder quitar filtros)
          if (visibles.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EstadoVacio(
                mensaje: _mensajeFiltrosVacios,
                etiquetaAccion: 'Quitar filtros',
                onAccion: () => setState(() {
                  _soloWifi = false;
                  _mejorCalificadas = false;
                }),
              ),
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
        ],
      ),
    );
  }
}
