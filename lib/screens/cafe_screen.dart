import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';
=======
import 'package:semana2/models/cafe_model.dart';
import 'package:semana2/services/cafe_service.dart';
import 'package:semana2/widgets/cabecera_resumen.dart';
import 'package:semana2/widgets/estados_vista.dart';
import 'package:semana2/widgets/tarjeta_cafe.dart';

>>>>>>> origin/main
import '../utils/cafe_helpers.dart';

class CafeScreen extends StatefulWidget {
  const CafeScreen({super.key});

  @override
  State<CafeScreen> createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> {
<<<<<<< HEAD
  final CafeService _CafeService = CafeService();
=======
  final CafeService _cafeService = CafeService();
>>>>>>> origin/main

  bool _cargando = true;
  String? _error;
  List<CafeModel> _cafes = [];

<<<<<<< HEAD
  //filtros
=======
  // filtros
>>>>>>> origin/main
  bool _soloWifi = false;
  int _visitas = 0;

  @override
  void initState() {
    super.initState();
    _cargarCafes();
  }

  Future<void> _cargarCafes() async {
    setState(() {
<<<<<<< HEAD
      //cada q hago setstate se llama al build
=======
>>>>>>> origin/main
      _cargando = true;
      _error = null;
    });

    try {
<<<<<<< HEAD
      final resultado = await _CafeService.obtenerCafes();
      if (!mounted) return; //controlar si el usuario cambia de pantalla mientras se carga la información, si no está montado, no se hace nada

      setState(() {
        //si el usuario sigue en la pantalla, se actualiza el estado con los datos obtenidos
=======
      final resultado = await _cafeService.obtenerCafes();
      if (!mounted) return;

      setState(() {
>>>>>>> origin/main
        _cafes = resultado;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
<<<<<<< HEAD
        _error = e.toString();
=======
        _error = e.toString().replaceFirst('Exception: ', '');
>>>>>>> origin/main
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final visibles =
        _cafes.where((c) => !_soloWifi || c.tieneWifi).toList();
=======
    final visibles = _cafes.where((c) => !_soloWifi || c.tieneWifi).toList();
>>>>>>> origin/main
    final (promedio, conWifi) = resumen(_cafes);

    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text('Cafés de Loja'),
=======
        title: Text('Cafes de Loja'),
>>>>>>> origin/main
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Badge(
                label: Text('$_visitas'),
<<<<<<< HEAD
                child: Icon(Icons.coffee_rounded),
=======
                child: Icon(Icons.place_outlined),
>>>>>>> origin/main
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
<<<<<<< HEAD
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
=======
    // Etado 1: cargando
    if (_cargando) {
      return EstadoCargando();
    }
    // Estado 2: Error
    if (_error != null) {
      return EstadoError(mensaje: _error!, onReintentar: _cargarCafes);
    }
    // Estado 3: Vacio
>>>>>>> origin/main
    if (visibles.isEmpty) {
      return EstadoVacio(
        onAccion: () => setState(() {
          _soloWifi = false;
        }),
      );
    }
<<<<<<< HEAD

    //ESTADO 4: LISTA DE CAFES
=======
    // Estado 4: los datos
>>>>>>> origin/main
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
