import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ser_manos/models/news_model.dart';
import 'package:ser_manos/models/volunteering_model.dart';

import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(
    String uid,
    String nombre,
    String apellido,
    String email,
  ) async {
    await _db.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'fechaRegistro': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<News>> getNews() {
    return _db.collection('novedades').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => News.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  Future<News?> getNewsById(String id) async {
    final doc = await _db.collection('novedades').doc(id).get();
    if (doc.exists) {
      return News.fromDocumentSnapshot(doc);
    }
    return null; //Pedrolopez1
  }

  Future<List<Volunteering>> getAllVolunteerings() async {
    final snapshot = await _db.collection('voluntariados').get();
    return snapshot.docs
        .map((doc) => Volunteering.fromDocumentSnapshot(doc))
        .toList();
  }

  Future<Volunteering?> getVolunteeringById(String id) async {
    final doc = await _db.collection('voluntariados').doc(id).get();
    if (!doc.exists) return null;
    return Volunteering.fromDocumentSnapshot(doc);
  }

  Future<User?> getUserById(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    if (!doc.exists) return null;
    return User.fromDocumentSnapshot(doc);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('usuarios').doc(uid).update(data);
  }
}
