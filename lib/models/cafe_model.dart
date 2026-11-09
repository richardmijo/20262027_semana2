class CafeModel {
  final int id;
  final String nombre;
  final String descripcion;
  final List<String> ingredientes;
  final String? imageUrl;
  final double price;
  final double calificacion;
  final bool tieneWifi;

CafeModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ingredientes,
    this.imageUrl,
    this.price =2.25,
    this.calificacion = 4.5,
    this.tieneWifi = true,
  });
  //serializar 
  factory CafeModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final int parsedId = rawId is int
        ? rawId
        : (int.tryParse(rawId?.toString() ?? '') ?? 0);

    final rawIngredientes = json['ingredientes'] ?? [];
    final List<String> parsedIngredientes = rawIngredientes is List
        ? rawIngredientes.map((item) => item.toString()).toList()
        : [];

    return CafeModel(
      id: parsedId,
      nombre: (json['nombre'] ?? json['title'] ?? 'Café especial') as String,
      descripcion: (json['descripcion'] ?? json['description'] ?? 'Delicioso café con sabor único') as String,
      ingredientes: parsedIngredientes,
      price: (json['precio'] as num?)?.toDouble() ?? (1.75 + (parsedId % 4) * 0.5),
      calificacion: (json['calificacion'] as num?)?.toDouble() ?? (4.0 + (parsedId % 10) * 0.1),
      tieneWifi: json['wifi'] as bool? ?? (parsedId % 2 == 0),
    );
  }

  String get resumenIngredientes => 
      ingredientes.isEmpty ? 'cafe de altura' : ingredientes.join(', ');
}
