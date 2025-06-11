import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/auth/controllers/auth_controller.dart';

import '../../../infrastructure/user_service.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final userRepo = ref.read(userRepositoryProvider);
  final authNotifier = ref.read(authNotifierProvider.notifier);
  return AuthControllerImpl(ref, userRepo, authNotifier);
});

class AuthControllerImpl implements AuthController {
  final Ref ref;
  final UserRepository _userRepository;
  final AuthNotifier _authNotifier;

  AuthControllerImpl(this.ref, this._userRepository, this._authNotifier);

  Future<String?> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) async {
    try {
      await _authNotifier.register(
        nombre: nombre,
        apellido: apellido,
        email: email,
        password: password,
      );
      return null; // Success
    } catch (e, stack) {
      // Optionally log error (Crashlytics, Analytics)
      return e.toString();
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _authNotifier.login(email: email, password: password);
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }
}
