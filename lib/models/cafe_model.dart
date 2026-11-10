class CafeModel {
  final int id;
  final String nombre;
  final String descripcion;
  final List<String> ingredientes;
  final String? imagenUrl;
  final double precio;
  final double calificacion;
  final bool tieneWifi;

  CafeModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ingredientes,
    this.imagenUrl,
    this.precio = 2.25,
    this.calificacion = 4.5,
    this.tieneWifi = true,
  });
  //serealizar
  factory CafeModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final int parseId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    final rawIngredientes = json['ingredientes'] ?? json['ingredientes'];
    final List<String> parsedIngredientes = rawIngredientes is List
        ? rawIngredientes.map((item) => item.toString()).toList()
        : [];
    return CafeModel(
      id: parseId,
      nombre: (json['title'] ?? json['nombre'] ?? 'Cafe Especial') as String,
      descripcion:
          (json['descripcion'] ??
          json['description'] ??
          'Delicioso café tostado'),
      ingredientes: parsedIngredientes,
      precio:
          (json['precio'] as num?)?.toDouble() ?? (1.75 + (parseId % 4) * 0.5),
      calificacion:
          (json['calificacion'] as num?)?.toDouble() ??
          (4.0 + (parseId % 10) * 0.1),
      tieneWifi: json['Wifi'] as bool? ?? (parseId % 2 == 0),
    );
  }
  String get resumenIngredientes =>
      ingredientes.isEmpty ? 'Cafe de altura' : ingredientes.join(', ');
}
