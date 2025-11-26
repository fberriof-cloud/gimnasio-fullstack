// lib/model/cliente.dart
class Cliente {
  final int id;
  final String nombre;
  final int edad;
  final String membresia;
  final bool activo;

  Cliente({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.membresia,
    required this.activo,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      edad: json['edad'] as int,
      membresia: json['membresia'] as String,
      activo: json['activo'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
      'membresia': membresia,
      'activo': activo,
    };
  }
}
