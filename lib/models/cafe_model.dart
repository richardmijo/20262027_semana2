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

  // serializar
  factory CafeModel.fromJson( Map<String, dynamic> json){
    final rawId = json['id'];
    final int parsedId = rawId is int 
        ? rawId
        : (int.tryParse(rawId?.toString() ?? '') ?? 0);
    final rawIngredients = json['ingredients'] ?? json ['ingredientes'];
    final List<String> parsedIngredients = rawIngredients is List
        ? rawIngredients.map((item) => item.toString()).toList()
        : [];
    return CafeModel(
      id: parsedId, 
      nombre: (json['title'] ?? json['nombre'] ?? 'Cafe Especial') as String, 
      descripcion: 
        (json['description'] ?? 
        json['descripcion'] ?? 
        'Delicioso Cafe Tostado' ), 
      ingredientes: parsedIngredients,
      precio: 
        (json['precio'] as num?)?.toDouble() ?? 
        (1.75 + (parsedId % 4) * 0.50),
      calificacion: 
        (json['calificacion'] as num?)?.toDouble() ??
        (4.0 + (parsedId % 10) *0.1),
      tieneWifi: json['wifi'] as bool? ?? (parsedId % 2 == 0),
    );
  }

  String get resumenIngredientes => 
      ingredientes.isEmpty ? 'Cafe de altura' : ingredientes.join(', ');

}