class CafeModel {
  final int id;
  final String nombre;
  final String descripcion;
  final List<String> ingredientes;
  final String? imagenUrl;
  final double precio;

  /// Calificación tal como viene en el JSON. Es `null` si la cafetería no
  /// tiene calificación: así nunca entra por error en "Mejor calificadas".
  final double? calificacion;
  final bool tieneWifi;

  /// Dirección real tomada del JSON (`direccion` o `address`).
  /// Es `null` si el JSON no la trae; no se inventa una dirección.
  final String? direccion;
  final String horario;

  CafeModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ingredientes,
    this.imagenUrl,
    this.precio = 2.25,
    this.calificacion,
    this.tieneWifi = true,
    this.direccion,
    this.horario = '07:30 - 21:00',
  });

  factory CafeModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final int parsedId = rawId is int
        ? rawId
        : (int.tryParse(rawId?.toString() ?? '') ?? 0);
    final rawIngredients = json['ingredients'] ?? json['ingredientes'];
    final List<String> parsedIngredients = rawIngredients is List
        ? rawIngredients.map((item) => item.toString()).toList()
        : [];
    return CafeModel(
      id: parsedId,
      nombre: (json['title'] ?? json['nombre'] ?? 'Cafe Especial') as String,
      descripcion:
          (json['description'] ??
          json['descripcion'] ??
          'Delicioso cafe tostado.'),
      imagenUrl: (json['image'] ?? json['imagenUrl']) as String?,
      ingredientes: parsedIngredients,
      precio:
          (json['precio'] as num?)?.toDouble() ??
          (1.75 + (parsedId % 4) * 0.50),
      calificacion: _numeroOpcional(json['calificacion']),
      tieneWifi: json['wifi'] as bool? ?? (parsedId % 2 == 0),
      direccion: _textoOpcional(json['direccion'] ?? json['address']),
      horario:
          (json['horario'] ??
                  json['schedule'] ??
                  '0${7 + (parsedId % 3)}:00 - 2${0 + (parsedId % 3)}:00')
              as String,
    );
  }

  String get resumenIngredients =>
      ingredientes.isEmpty ? 'Cafe de altura' : ingredientes.join(', ');

  /// Acepta un número (`4.5`) o un texto numérico (`"4.5"`); si no, `null`.
  static double? _numeroOpcional(Object? valor) => switch (valor) {
    num n => n.toDouble(),
    String s => double.tryParse(s.trim()),
    _ => null,
  };

  /// Devuelve el texto sin espacios sobrantes, o `null` si viene vacío.
  static String? _textoOpcional(Object? valor) {
    final texto = valor?.toString().trim() ?? '';
    return texto.isEmpty ? null : texto;
  }
}
