class SalonModel {
  final String id;
  final String nombre;

  SalonModel({
    required this.id,
    required this.nombre,
  });

  factory SalonModel.fromMap(Map<String, dynamic> map) {
    return SalonModel(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
    };
  }
}