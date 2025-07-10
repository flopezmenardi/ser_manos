import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/users/services/user_service.dart';

import '../../../core/models/user_model.dart';

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
  Future<User?> getUserById(String userId) async {
    final doc = await _db.collection('usuarios').doc(userId).get();
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
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      await createUser(userId, nombre, apellido, email);
      return getUserById(userId);
    } on fb_auth.FirebaseAuthException catch (_) {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
      }
      rethrow;
    }
  }

  @override
  Future<void> createUser(
    String userId,
    String name,
    String surname,
    String email,
  ) async {
    await _db.collection('usuarios').doc(userId).set({
      'nombre': name,
      'apellido': surname,
      'email': email,
      'fechaRegistro': FieldValue.serverTimestamp(),
      'telefono': '',
      'genero': '',
      'fechaNacimiento': null, // Changed from empty string to null
      'voluntariado': null,
      'voluntariadoAceptado': false,
      'favoritos': <String>[],
    });
  }

  @override
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userId = userCredential.user!.uid;
    return getUserById(userId);
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('usuarios').doc(userId).update(data);
  }

  @override
  fb_auth.User? get currentFirebaseUser => _auth.currentUser;
}
