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
            Row(
              children: [
                Text(
                  cafe.precio.usd,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Text('• ${etiqueta(cafe.calificacion)}'),
                if (cafe.tieneWifi) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.wifi, size: 14, color: Colors.blue),
                ],
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '⭐ ${cafe.calificacion.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.touch_app, size: 16, color: Colors.grey),
          ],
        ),
        onTap: alVisitar,
      ),
    );
  }
}
