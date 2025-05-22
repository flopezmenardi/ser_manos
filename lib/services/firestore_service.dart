import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> crearVoluntariado(Map<String, dynamic> data) async {
    await _db.collection('voluntariados').add(data);
  }

  Future<void> crearNoticia(Map<String, dynamic> data) async {
    await _db.collection('novedades').add(data);
  }

  Stream<QuerySnapshot> obtenerVoluntariados() {
    return _db.collection('voluntariados').snapshots();
  }
}