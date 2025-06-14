import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../../models/user_model.dart';

abstract class UserService {
  Future<User?> getUserById(String uid);
  Future<User?> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  });
  Future<void> createUser(String uid, String nombre, String apellido, String email);
  Future<User?> loginUser({required String email, required String password});
  Future<void> logout();
  Future<void> updateUser(String uid, Map<String, dynamic> data);
  fb_auth.User? get currentFirebaseUser;
}
