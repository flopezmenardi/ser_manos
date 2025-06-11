import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/user_service.dart';

final registerControllerProvider = Provider<RegisterController>((ref) {
  final userRepo = ref.read(userRepositoryProvider);
  final authNotifier = ref.read(authNotifierProvider.notifier);
  return RegisterController(ref, userRepo, authNotifier);
});

class RegisterController {
  final Ref ref;
  final UserRepository _userRepository;
  final AuthNotifier _authNotifier;

  RegisterController(this.ref, this._userRepository, this._authNotifier);

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
