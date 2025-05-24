import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/controllers/register_controller.dart';
import '../models/user_model.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

final refreshUserProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    await ref.read(authStateProvider.notifier).refreshUser();
  };
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthState.initial());

  RegisterController get _controller => ref.read(registerControllerProvider);

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

    print(
      error == null
          ? '✅ Usuario registrado correctamente'
          : '❌ Error al registrar usuario: $error',
    );

    state = state.copyWith(isLoading: false, errorMessage: error);
  }

  Future<void> login({required String email, required String password}) async {
    print('🟡 Dentro de AuthNotifier.login()');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final error = await _controller.loginUser(email: email, password: password);

    if (error == null) {
      final user = fb.FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('usuarios')
                .doc(user.uid)
                .get();
        final appUser = User.fromDocumentSnapshot(doc);

        state = state.copyWith(isLoading: false, currentUser: appUser);
        print('✅ Usuario logueado correctamente con UID: ${appUser.uuid}');
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No se pudo obtener el usuario actual de Firebase',
        );
      }
    } else {
      print('❌ Error al loguear usuario: $error');
      state = state.copyWith(isLoading: false, errorMessage: error);
    }
  }

  Future<void> refreshUser() async {
    final firebaseUser = fb.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(firebaseUser.uid)
            .get();

    final appUser = User.fromDocumentSnapshot(doc);

    state = state.copyWith(currentUser: appUser);
  }
}

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final User? currentUser;

  AuthState({required this.isLoading, this.errorMessage, this.currentUser});

  factory AuthState.initial() => AuthState(isLoading: false, currentUser: null);

  get user => currentUser;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? currentUser,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
