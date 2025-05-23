import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ser_manos/models/news_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(String uid, String nombre, String apellido, String email) async {
    await _db.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'fechaRegistro': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createVolunteering(Map<String, dynamic> data) async {
    await _db.collection('voluntariados').add(data);
  }

  Future<void> createNews(Map<String, dynamic> data) async {
    await _db.collection('novedades').add(data);
  }

  Stream<QuerySnapshot> getVolunteers() {
    return _db.collection('voluntariados').snapshots();
  }

  Stream<List<News>> getNews() {
    return _db.collection('novedades').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => News.fromDocumentSnapshot(doc)).toList();
    });
  }

  Future<News?> getNewsById(String id) async {
    final doc = await _db.collection('novedades').doc(id).get();
    if (doc.exists) {
      return News.fromDocumentSnapshot(doc);
    }
    return null;
  }
}