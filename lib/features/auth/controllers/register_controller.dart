import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/providers/user_provider.dart';

import '../../../providers/firestore_provider.dart';

final registerControllerProvider = Provider<RegisterController>((ref) {
  return RegisterController(ref);
});

class RegisterController {
  final Ref ref;
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  RegisterController(this.ref);

  Future<String?> registerUser({
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

      final uid = userCredential.user!.uid;

      final firestore = ref.read(firestoreServiceProvider);
      await firestore.createUser(uid, nombre, apellido, email);

      final user = await firestore.getUserById(uid);
      if (user != null) {
        ref.read(userProvider.notifier).setUser(user);
      }

      return null;
    } on fb_auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error desconocido';
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final firestore = ref.read(firestoreServiceProvider);
      final user = await firestore.getUserById(uid);

      if (user != null) {
        ref.read(userProvider.notifier).setUser(user);
      }

      return null;
    } on fb_auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error desconocido';
    }
  }
}
