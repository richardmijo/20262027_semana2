import 'package:flutter/material.dart';

import '../models/cafe_model.dart';
import '../utils/cafe_helpers.dart';

/// Tarjeta para cada elemento de la lista de cafés proveniente de la API REST.
class TarjetaCafe extends StatelessWidget {
  final CafeModel cafe;
  final VoidCallback alVisitar;

  const TarjetaCafe({super.key, required this.cafe, required this.alVisitar});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        leading: cafe.imagenUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cafe.imagenUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const CircleAvatar(child: Icon(Icons.coffee)),
                ),
              )
            : const CircleAvatar(child: Icon(Icons.coffee)),
        title: Text(
          cafe.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cafe.descripcion,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // DATO NUEVO: dirección que viene del JSON ("direccion")
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.location_on_outlined, size: 14),
                ),
                const SizedBox(width: 4),
                Expanded(child: Text(cafe.direccion)),
              ],
            ),
            const SizedBox(height: 4),
            // Wrap en vez de Row: si la letra es grande, baja de línea
            // en lugar de mostrar la franja amarilla de desborde.
            Wrap(
              spacing: 8,
              runSpacing: 2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  cafe.precio.usd,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                Text('⭐ ${cafe.calificacion.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('• ${etiqueta(cafe.calificacion)}'),
                if (cafe.tieneWifi)
                  const Icon(Icons.wifi, size: 14, color: Colors.blue),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.touch_app, size: 16, color: Colors.grey),
        onTap: alVisitar,
      ),
    );
  }
}
