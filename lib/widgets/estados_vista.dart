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
  final bool esErrorConexion;

  const EstadoError({
    super.key,
    required this.mensaje,
    required this.onReintentar,
    this.esErrorConexion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              esErrorConexion ? Icons.wifi_off : Icons.cloud_off,
              size: 70,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              esErrorConexion
                  ? 'Sin conexión a internet'
                  : '¡Ups! No pudimos obtener los cafés',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              esErrorConexion
                  ? 'Revisa tu conexión (Wi-Fi o datos móviles) y vuelve a intentarlo.'
                  : mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: onReintentar,
              label: const Text('Reintentar conexión'),
              icon: const Icon(Icons.replay),
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
    this.mensaje = 'No hay resultados: ninguna cafetería cumple con los filtros activos.',
    required this.onAccion,
    this.etiquetaAccion = 'Quitar filtros',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.orange),
            const SizedBox(height: 12),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: onAccion, child: Text(etiquetaAccion)),
          ],
        ),
      ),
    );
  }
}
