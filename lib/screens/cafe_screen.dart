import 'package:flutter/material.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/models/cafe_model.dart';
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
  final CafeService _CafeService = CafeService();

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
      //cada q hago setstate se llama al build
      _cargando = true;
      _error = null;
    });

    try {
      final resultado = await _CafeService.obtenerCafes();
      if (!mounted) return; //controlar si el usuario cambia de pantalla mientras se carga la información, si no está montado, no se hace nada

      setState(() {
        //si el usuario sigue en la pantalla, se actualiza el estado con los datos obtenidos
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
    final visibles =
        _cafes.where((c) => !_soloWifi || c.tieneWifi).toList();
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
                child: Icon(Icons.coffee_rounded),
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
    //ESTADO 1_ CARGANDO
    if (_cargando) {
      return const EstadoCargando();
    }
    // ESTADO 2: ERROR
    if (_error != null) {
      return EstadoError(
        mensaje: _error!,
        onReintentar: _cargarCafes,
      );
    }
    //ESTADO 3: VACIO
    if (visibles.isEmpty) {
      return EstadoVacio(
        onAccion: () => setState(() {
          _soloWifi = false;
        }),
      );
    }

    //ESTADO 4: LISTA DE CAFES
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