import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String id;
  final String title;
  final String description;
  final String creator;
  final String summary;
  final String imageURL;
  final Timestamp? creationDate;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.creator,
    required this.summary,
    required this.imageURL,
    required this.creationDate,
  });

  factory News.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return News(
      id: doc.id,
      title: data['titulo'] ?? '',
      description: data['descripcion'] ?? '',
      creator: data['emisor'] ?? '',
      summary: data['resumen'] ?? '',
      imageURL: data['imagenURL'] ?? '',
      creationDate: data['fechaCreacion'],
    );
  }
}

extension NewsToMap on News {
  Map<String, dynamic> toMap() {
    return {
      'titulo': title,                
      'descripcion': description,
      'resumen': summary,
      'emisor': creator,
      'imagenURL': imageURL,
      'fechaCreacion': creationDate,
    };
  }
}
