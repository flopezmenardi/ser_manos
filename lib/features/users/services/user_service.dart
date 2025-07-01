import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../../core/models/user_model.dart';

abstract class UserService {
  Future<User?> getUserById(String userId);
  Future<User?> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  });
  Future<void> createUser(
    String userId,
    String nombre,
    String apellido,
    String email,
  );
  Future<User?> loginUser({required String email, required String password});
  Future<void> logout();
  Future<void> updateUser(String userId, Map<String, dynamic> data);
  fb_auth.User? get currentFirebaseUser;
}
