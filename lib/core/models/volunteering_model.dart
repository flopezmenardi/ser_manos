import 'package:cloud_firestore/cloud_firestore.dart';

class Volunteering {
  final String id;
  final String title;
  final String description;
  final String summary;
  final String creator;
  final int vacants;
  final String requirements;
  final String address;
  final GeoPoint location;
  final String imageURL;
  final Timestamp? creationDate;
  final int likes;
  final Timestamp? startDate;
  final double? cost;

  Volunteering({
    required this.id,
    required this.title,
    required this.description,
    required this.summary,
    required this.creator,
    required this.vacants,
    required this.requirements,
    required this.address,
    required this.location,
    required this.imageURL,
    required this.creationDate,
    required this.likes,
    required this.startDate,
    this.cost,
  });

  factory Volunteering.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Volunteering(
      id: doc.id,
      title: data['titulo'] ?? '',
      description: data['descripcion'] ?? '',
      summary: data['resumen'] ?? '',
      creator: data['emisor'] ?? '',
      vacants: data['vacantes'] ?? 0,
      requirements: data['requisitos'] ?? '',
      address: data['direccion'] ?? '',
      location: data['ubicacion'] ?? '',
      imageURL: data['imagenURL'] ?? '',
      creationDate: data['fechaCreacion'],
      likes: data['likes'] ?? 0,
      startDate: data['fechaInicio'],
      cost: data['costo']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': title,
      'descripcion': description,
      'resumen': summary,
      'emisor': creator,
      'vacantes': vacants,
      'requisitos': requirements,
      'direccion': address,
      'ubicacion': location,
      'imagenURL': imageURL,
      'fechaCreacion': creationDate,
      'likes': likes,
      'fechaInicio': startDate,
      'costo': cost,
    };
  }

  Volunteering copyWith({
    String? id,
    String? title,
    String? description,
    String? summary,
    String? creator,
    int? vacants,
    String? requirements,
    String? address,
    GeoPoint? location,
    String? imageURL,
    Timestamp? creationDate,
    int? likes,
    Timestamp? startDate,
    double? cost,
  }) {
    return Volunteering(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      summary: summary ?? this.summary,
      creator: creator ?? this.creator,
      vacants: vacants ?? this.vacants,
      requirements: requirements ?? this.requirements,
      address: address ?? this.address,
      location: location ?? this.location,
      imageURL: imageURL ?? this.imageURL,
      creationDate: creationDate ?? this.creationDate,
      likes: likes ?? this.likes,
      startDate: startDate ?? this.startDate,
      cost: cost ?? this.cost,
    );
  }
}
