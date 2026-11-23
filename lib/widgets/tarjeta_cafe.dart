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
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alVisitar,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImagenCafe(imagenUrl: cafe.imagenUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cafe.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cafe.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          cafe.precio.usd,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        Text(etiqueta(cafe.calificacion)),
                        Text(
                          '⭐ ${cafe.calificacion.toStringAsFixed(1)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (cafe.tieneWifi)
                          const Icon(Icons.wifi, size: 18, color: Colors.blue),
                        _IconoTexto(icono: Icons.schedule, texto: cafe.horario),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagenCafe extends StatelessWidget {
  final String? imagenUrl;

  const _ImagenCafe({required this.imagenUrl});

  @override
  Widget build(BuildContext context) {
    if (imagenUrl == null) {
      return const CircleAvatar(child: Icon(Icons.coffee));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imagenUrl!,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            const CircleAvatar(child: Icon(Icons.coffee)),
      ),
    );
  }
}

class _IconoTexto extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _IconoTexto({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 4),
        Flexible(child: Text(texto)),
      ],
    );
  }
}
