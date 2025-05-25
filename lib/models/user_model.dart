import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uuid;
  final String nombre;
  final String apellido;
  final String email;
  final String fechaNacimiento;
  final Timestamp fechaRegistro;
  final String genero;
  final String telefono;
  final String? voluntariado;
  final bool voluntariadoAceptado;
  final List<String> favoritos;

  User({
    required this.uuid,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.fechaNacimiento,
    required this.fechaRegistro,
    required this.genero,
    required this.telefono,
    this.voluntariado,
    required this.voluntariadoAceptado,
    required this.favoritos,
  });

  factory User.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uuid: doc.id,
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      email: data['email'] ?? '',
      fechaNacimiento: data['fechaNacimiento'] ?? '',
      fechaRegistro: data['fechaRegistro'] ?? '',
      genero: data['genero'] ?? '',
      telefono: data['telefono'] ?? '',
      voluntariado: data['voluntariado'] ?? '',
      voluntariadoAceptado: data['voluntariadoAceptado'] ?? false,
      favoritos: List<String>.from(data['favoritos'] ?? []),
    );
  }
}
