class CafeModel {
  final int id;
  final String nombre;
  final String descripcion;
  final String? horario;
  final List<String> ingredientes;
  final String? imagenUrl;
  final double precio;
  final double calificacion;
  final bool tieneWifi;

  CafeModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.horario,
    required this.ingredientes,
    this.imagenUrl,
    this.precio = 2.25,
    this.calificacion = 4.5,
    this.tieneWifi = true,
  });

  factory CafeModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = rawId is int ? rawId : int.tryParse('$rawId') ?? 0;
    final rawIngredients = json['ingredients'] ?? json['ingredientes'];
    final ingredients = rawIngredients is List
        ? rawIngredients.map((item) => item.toString()).toList()
        : <String>[];

    return CafeModel(
      id: id,
      nombre: (json['title'] ?? json['nombre'] ?? 'Café especial').toString(),
      descripcion:
          (json['description'] ?? json['descripcion'] ?? 'Delicioso café tostado')
              .toString(),
      ingredientes: ingredients,
      horario: (json['horario'] ?? json['hours'])?.toString(),
      imagenUrl: (json['image'] ?? json['imagenUrl']) as String?,
      precio: (json['precio'] as num?)?.toDouble() ?? (1.75 + (id % 4) * 0.50),
      calificacion:
          (json['calificacion'] as num?)?.toDouble() ?? (4.0 + (id % 10) * 0.1),
      tieneWifi: json['wifi'] as bool? ?? id.isEven,
    );
  }

  String get resumenIngredientes =>
      ingredientes.isEmpty ? 'Café de altura' : ingredientes.join(', ');
}
