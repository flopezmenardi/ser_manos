import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String id;
  final String titulo;
  final String descripcion;
  final String emisor;
  final String resumen;
  final String imagenURL;

  News({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.emisor,
    required this.resumen,
    required this.imagenURL,
  });

  factory News.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return News(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      emisor: data['emisor'] ?? '',
      resumen: data['resumen'] ?? '',
      imagenURL: data['imagenURL'] ?? '',
    );
  }
}