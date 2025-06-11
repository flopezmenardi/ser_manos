import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

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
      'telefono': '',
      'genero': '',
      'fechaNacimiento': '',
      'voluntariado': null,
      'voluntariadoAceptado': false,
      'favoritos': <String>[],
    });
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
