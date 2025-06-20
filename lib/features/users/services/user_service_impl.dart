import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/users/services/user_service.dart';

import '../../../models/user_model.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserServiceImpl();
});

class UserServiceImpl implements UserService {
  final fb_auth.FirebaseAuth _auth;
  final FirebaseFirestore _db;

  UserServiceImpl({fb_auth.FirebaseAuth? auth, FirebaseFirestore? db})
    : _auth = auth ?? fb_auth.FirebaseAuth.instance,
      _db = db ?? FirebaseFirestore.instance;

  @override
  Future<User?> getUserById(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    if (!doc.exists) return null;
    return User.fromDocumentSnapshot(doc);
  }

  @override
  Future<User?> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final uid = userCredential.user!.uid;

    await createUser(uid, nombre, apellido, email);
    return getUserById(uid);
  }

  @override
  Future<void> createUser(String uid, String nombre, String apellido, String email) async {
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

  @override
  Future<User?> loginUser({required String email, required String password}) async {
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final uid = userCredential.user!.uid;
    return getUserById(uid);
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('usuarios').doc(uid).update(data);
  }

  @override
  fb_auth.User? get currentFirebaseUser => _auth.currentUser;
}
