import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/controllers/register_controller.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  final _controller = RegisterController();

  Future<void> register({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) async {
    print('🟡 Dentro de AuthNotifier.register()');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final error = await _controller.registerUser(
      nombre: nombre,
      apellido: apellido,
      email: email,
      password: password,
    );
    print(error == null ? '✅ Usuario registrado correctamente' : '❌ Error al registrar usuario: $error');

    state = state.copyWith(isLoading: false, errorMessage: error);
  }
}

class AuthState {
  final bool isLoading;
  final String? errorMessage;

  AuthState({required this.isLoading, this.errorMessage});

  factory AuthState.initial() => AuthState(isLoading: false);

  AuthState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}