import 'package:cloud_firestore/cloud_firestore.dart';

class Volunteering {
  final String id;
  final String titulo;
  final String descripcion;
  final String resumen;
  final String emisor;
  final int vacantes;
  final List<String> requisitos;
  final String direccion;
  final String imagenURL;

  Volunteering({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.resumen,
    required this.emisor,
    required this.vacantes,
    required this.requisitos,
    required this.direccion,
    required this.imagenURL,
  });

  factory Volunteering.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Volunteering(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      resumen: data['resumen'] ?? '',
      emisor: data['emisor'] ?? '',
      vacantes: data['vacantes'] ?? 0,
      requisitos: List<String>.from(data['requisitos'] ?? []),
      direccion: data['direccion'] ?? '',
      imagenURL: data['imagenURL'] ?? '',
    );
  }
}