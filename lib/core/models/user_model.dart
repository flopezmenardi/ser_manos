import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/date_utils.dart' as app_date_utils;

class User {
  final String id;
  final String name;
  final String surname;
  final String email;
  final Timestamp? birthDate;
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
    this.birthDate,
    this.registerDate,
    required this.gender,
    required this.phoneNumber,
    this.volunteering,
    this.photoUrl,
    required this.acceptedVolunteering,
    required this.favorites,
  });

  /// Returns birth date as a DD-MM-YYYY string for display
  String get birthDateString => app_date_utils.DateUtils.timestampToString(birthDate);

  factory User.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Handle both old string format and new timestamp format for backwards compatibility
    Timestamp? birthDateTimestamp;
    final birthDateData = data['fechaNacimiento'];
    
    if (birthDateData == null) {
      birthDateTimestamp = null;
    } else if (birthDateData is Timestamp) {
      birthDateTimestamp = birthDateData;
    } else if (birthDateData is String) {
      if (birthDateData.isEmpty) {
        birthDateTimestamp = null;
      } else {
        // Handle both DD-MM-YYYY and DD/MM/YYYY formats for backwards compatibility
        String normalizedDate = birthDateData.replaceAll('/', '-');
        birthDateTimestamp = app_date_utils.DateUtils.stringToTimestamp(normalizedDate);
      }
    } else {
      // Handle any other type by setting to null
      birthDateTimestamp = null;
    }
    
    return User(
      id: doc.id,
      name: data['nombre'] ?? '',
      surname: data['apellido'] ?? '',
      email: data['email'] ?? '',
      birthDate: birthDateTimestamp,
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
    Timestamp? birthDate,
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
