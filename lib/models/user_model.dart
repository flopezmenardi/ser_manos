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
  final String? photoUrl;
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
    this.photoUrl,
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
      photoUrl: data['photoUrl'] as String?,
      favoritos: List<String>.from(data['favoritos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'fechaNacimiento': fechaNacimiento,
      'fechaRegistro': fechaRegistro,
      'genero': genero,
      'telefono': telefono,
      'voluntariado': voluntariado,
      'voluntariadoAceptado': voluntariadoAceptado,
      'photoUrl': photoUrl,
      'favoritos': favoritos,
    };
  }

  User copyWith({
    String? uuid,
    String? nombre,
    String? apellido,
    String? email,
    String? fechaNacimiento,
    Timestamp? fechaRegistro,
    String? genero,
    String? telefono,
    String? voluntariado,
    String? photoUrl,
    bool? voluntariadoAceptado,
    List<String>? favoritos,
  }) {
    return User(
      uuid: uuid ?? this.uuid,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      genero: genero ?? this.genero,
      telefono: telefono ?? this.telefono,
      voluntariado: voluntariado ?? this.voluntariado,
      photoUrl: photoUrl ?? this.photoUrl,
      voluntariadoAceptado: voluntariadoAceptado ?? this.voluntariadoAceptado,
      favoritos: favoritos ?? this.favoritos,
    );
  }
}
