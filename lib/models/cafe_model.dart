class CafeModel {
  final int id;
  final String nombre;
  final String descripcion;
  final List<String> ingredientes;
  final String? imagenUrl;
  final double precio;
  final double calificacion;
  final bool tieneWIFI;

  const CafeModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ingredientes,
    this.imagenUrl,
    this.precio = 2.25,
    this.calificacion = 4.5,
    this.tieneWIFI = false,
  });

  // Serializar
  factory CafeModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final parsedId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;

    final rawIngredientes = json['ingredientes'] ?? json['ingredients'];
    final parsedIngredientes = rawIngredientes is List
        ? rawIngredientes.map((item) => item.toString()).toList()
        : <String>[];

    final rawPrecio = json['precio'] ?? json['price'];
    final rawCalificacion = json['calificacion'] ?? json['rating'];

    return CafeModel(
      id: parsedId,
      nombre: (json['title'] ?? json['nombre'] ?? 'Café especial').toString(),
      descripcion: (json['descripcion'] ??
              json['description'] ??
              'Delicioso café tostado')
          .toString(),
      ingredientes: parsedIngredientes,
      imagenUrl: (json['imagenUrl'] ?? json['imageUrl'])?.toString(),
      precio: rawPrecio is num
          ? rawPrecio.toDouble()
          : 1.75 + (parsedId % 4) * 0.5,
      calificacion: rawCalificacion is num
          ? rawCalificacion.toDouble()
          : 4.0 + (parsedId % 10) * 0.1,
      tieneWIFI: json['wifi'] as bool? ?? (parsedId % 2 == 0)

    );
  }

  String get resumenIngredientes =>
      ingredientes.isEmpty ? 'Café de altura' : ingredientes.join(', ');
}
