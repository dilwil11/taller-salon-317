class UsuarioModel {
  final String id;
  final String nombre;
  final String rol;
  final String correo;
  final String? avatarUrl;

  UsuarioModel({
    required this.id,
    required this.nombre,
    required this.rol,
    required this.correo,
    this.avatarUrl,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      rol: map['rol'] ?? 'aprendiz',
      correo: map['correo'] ?? '',
      avatarUrl: map['avatar_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'rol': rol,
      'correo': correo,
      'avatar_url': avatarUrl,
    };
  }
}