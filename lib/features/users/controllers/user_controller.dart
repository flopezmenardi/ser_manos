import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:image_picker/image_picker.dart';

import '../../../core/models/user_model.dart';

abstract class UserController {
  Future<User?> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  });

  Future<User?> loginUser({required String email, required String password});

  Future<void> logout();

  Future<void> updateUser(String userId, Map<String, dynamic> data);

  Future<void> uploadProfilePicture(String userId, XFile xfile);

  Future<User?> getCurrentUser();

  fb_auth.User? get currentFirebaseUser;
}
