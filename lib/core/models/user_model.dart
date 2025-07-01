import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String birthDate;
  final Timestamp? registerDate;
  final String gender;
  final String phoneNumber;
  final String? volunteering;
  final String? photoUrl;
  final bool acceptedVolunteering;
  final List<String> favorites;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.birthDate,
    this.registerDate,
    required this.gender,
    required this.phoneNumber,
    this.volunteering,
    this.photoUrl,
    required this.acceptedVolunteering,
    required this.favorites,
  });

  factory User.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['nombre'] ?? '',
      surname: data['apellido'] ?? '',
      email: data['email'] ?? '',
      birthDate: data['fechaNacimiento'] ?? '',
      registerDate: data['fechaRegistro'],
      gender: data['genero'] ?? '',
      phoneNumber: data['telefono'] ?? '',
      volunteering: data['voluntariado'] ?? '',
      acceptedVolunteering: data['voluntariadoAceptado'] ?? false,
      photoUrl: data['photoUrl'] as String?,
      favorites: List<String>.from(data['favoritos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'apellido': surname,
      'email': email,
      'fechaNacimiento': birthDate,
      'fechaRegistro': registerDate,
      'genero': gender,
      'telefono': phoneNumber,
      'voluntariado': volunteering,
      'voluntariadoAceptado': acceptedVolunteering,
      'photoUrl': photoUrl,
      'favoritos': favorites,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    String? birthDate,
    Timestamp? registerDate,
    String? gender,
    String? phoneNumber,
    String? volunteering,
    String? photoUrl,
    bool? acceptedVolunteering,
    List<String>? favorites,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      registerDate: registerDate ?? this.registerDate,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      volunteering: volunteering ?? this.volunteering,
      photoUrl: photoUrl ?? this.photoUrl,
      acceptedVolunteering: acceptedVolunteering ?? this.acceptedVolunteering,
      favorites: favorites ?? this.favorites,
    );
  }
}
