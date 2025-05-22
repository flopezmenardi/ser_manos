// features/auth/controllers/register_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/firestore_service.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  /// Registers a user with FirebaseAuth and stores extra data in Firestore.
  /// Returns `null` if successful, or an error message string otherwise.
  Future<String?> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) async {
    print('🟡 Dentro de RegisterController.registerUser()');
    try {
      // Step 1: Create Firebase Auth user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Usuario creado con UID: ${userCredential.user?.uid}');

      final uid = userCredential.user!.uid;

      // Step 2: Add extra info to Firestore under 'usuarios/{uid}'
      await _firestoreService.createUser(uid, nombre, apellido, email);
      print('✅ Usuario guardado en Firestore');

      return null; // success
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.message}');
      return e.message;
    } catch (e) {
      print('❌ Error desconocido: $e');
      return 'Error desconocido';
    }
  }
}