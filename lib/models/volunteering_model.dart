import 'package:cloud_firestore/cloud_firestore.dart';

class Volunteering {
  final String id;
  final String titulo;
  final String descripcion;
  final String resumen;
  final String emisor;
  final int vacantes;
  final String requisitos;
  final String direccion;
  final GeoPoint ubicacion;
  final String imagenURL;
  final Timestamp fechaCreacion;
  final int likes;
  final Timestamp fechaInicio;

  Volunteering({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.resumen,
    required this.emisor,
    required this.vacantes,
    required this.requisitos,
    required this.direccion,
    required this.ubicacion,
    required this.imagenURL,
    required this.fechaCreacion,
    required this.likes,
    required this.fechaInicio,
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
      requisitos: data['requisitos'] ?? '',
      direccion: data['direccion'] ?? '',
      ubicacion: data['ubicacion'] ?? '',
      imagenURL: data['imagenURL'] ?? '',
      fechaCreacion: data['fechaCreacion'] ?? '',
      likes: data['likes'] ?? 0,
      fechaInicio: data['fechaInicio'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'resumen': resumen,
      'emisor': emisor,
      'vacantes': vacantes,
      'requisitos': requisitos,
      'direccion': direccion,
      'ubicacion': ubicacion,
      'imagenURL': imagenURL,
      'fechaCreacion': fechaCreacion,
      'likes': likes,
      'fechaInicio': fechaInicio,
    };
  }

  Volunteering copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    String? resumen,
    String? emisor,
    int? vacantes,
    String? requisitos,
    String? direccion,
    GeoPoint? ubicacion,
    String? imagenURL,
    Timestamp? fechaCreacion,
    int? likes,
    Timestamp? fechaInicio,
  }) {
    return Volunteering(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      resumen: resumen ?? this.resumen,
      emisor: emisor ?? this.emisor,
      vacantes: vacantes ?? this.vacantes,
      requisitos: requisitos ?? this.requisitos,
      direccion: direccion ?? this.direccion,
      ubicacion: ubicacion ?? this.ubicacion,
      imagenURL: imagenURL ?? this.imagenURL,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      likes: likes ?? this.likes,
      fechaInicio: fechaInicio ?? this.fechaInicio,
    );
  }
}
