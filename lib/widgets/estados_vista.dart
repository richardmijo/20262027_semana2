import 'package:flutter/material.dart';

// Estado 1: Estado mientras DIO realiza la peticion
class EstadoCargando extends StatelessWidget {
  final String mensaje;

  const EstadoCargando({super.key, this.mensaje = 'Consultado API con DIO'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(mensaje, style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

// Estado 2: mostrar errores
class EstadoError extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const EstadoError({
    super.key,
    required this.mensaje,
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 70, color: Colors.redAccent),
            SizedBox(height: 16),
            Text(
              '¡Ups! No pudimos obtenes los cafes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),

            SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: onReintentar,
              label: Text('Reintentar conexión'),
              icon: Icon(Icons.replay),
            ),
          ],
        ),
      ),
    );
  }
}

// Estado 3: Cuando no hay elementos
class EstadoVacio extends StatelessWidget {
  final String mensaje;
  final VoidCallback onAccion;
  final String etiquetaAccion;

  const EstadoVacio({
    super.key,
    this.mensaje = 'No hay cafeterías que coincidan con el filtro.',
    required this.onAccion,
    this.etiquetaAccion = 'Quitar filtro de Wi-Fi',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.orange),
          const SizedBox(height: 12),
          Text(mensaje, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextButton(onPressed: onAccion, child: Text(etiquetaAccion)),
        ],
      ),
    );
  }
}
