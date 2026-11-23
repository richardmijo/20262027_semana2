import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

import '../utils/cafe_helpers.dart';
import 'cafe_detalle_screen.dart';

class CafeScreen extends StatefulWidget {
  const CafeScreen({super.key, this.cafeService});

  final CafeService? cafeService;

  @override
  State<CafeScreen> createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> {
  late final CafeService _cafeService = widget.cafeService ?? CafeService();
  final Set<int> _favoritos = {};
  bool _abriendoDetalle = false;

  bool _cargando = true;
  String? _error;
  List<CafeModel> _cafes = [];

  // filtros
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

  Future<void> _abrirDetalle(BuildContext context, CafeModel cafe) async {
    if (_abriendoDetalle) return;

    final favoritoInicial = _favoritos.contains(cafe.id);
    bool? cambioFavorito;
    _abriendoDetalle = true;
    try {
      final favorito = await Navigator.of(context).push(
        _RutaDetalleCafe(
          resultadoAlVolver: () => cambioFavorito,
          builder: (_) => CafeDetalleScreen(
            cafe: cafe,
            favoritoInicial: favoritoInicial,
            alCambiarFavorito: (valor) {
              cambioFavorito = valor == favoritoInicial ? null : valor;
            },
          ),
        ),
      );
      if (!context.mounted) return;

      setState(() {
        _visitas++;
        if (favorito == true) _favoritos.add(cafe.id);
        if (favorito == false) _favoritos.remove(cafe.id);
      });
      if (favorito == null) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              favorito ? 'Añadido a favoritos' : 'Quitado de favoritos',
            ),
          ),
        );
    } finally {
      _abriendoDetalle = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _cafes.where((c) => !_soloWifi || c.tieneWifi).toList();
    final (promedio, conWifi) = resumen(_cafes);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafés de Loja'),
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
        onAccion: () => setState(() {
          _soloWifi = false;
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
            favorito: _favoritos.contains(cafe.id),
            alVisitar: () => _abrirDetalle(this.context, cafe),
          );
        },
      ),
    );
  }
}

class _RutaDetalleCafe extends MaterialPageRoute<bool> {
  _RutaDetalleCafe({required super.builder, required this.resultadoAlVolver});

  final bool? Function() resultadoAlVolver;

  // La flecha y el retroceso del sistema cierran la ruta sin resultado explícito.
  @override
  bool? get currentResult => resultadoAlVolver();
}
