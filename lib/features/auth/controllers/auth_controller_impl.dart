import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ser_manos/features/auth/controllers/auth_controller.dart';

import '../../../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/auth_service_impl.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final userService = ref.read(userServiceProvider);
  return AuthControllerImpl(userService);
});

class AuthControllerImpl implements AuthController {
  final UserService _userService;

  AuthControllerImpl(this._userService);

  @override
  Future<User?> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) {
    return _userService.registerUser(nombre: nombre, apellido: apellido, email: email, password: password);
  }

  @override
  Future<User?> loginUser({required String email, required String password}) {
    return _userService.loginUser(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return _userService.logout();
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) {
    return _userService.updateUser(uid, data);
  }

  Future<void> uploadProfilePicture(String uid, XFile xfile) async {
    final ref = FirebaseStorage.instance
        .ref('users/$uid/profile_picture.jpg');

    UploadTask task;
    if (kIsWeb) {
      final bytes = await xfile.readAsBytes();
      task = ref.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } else {
      task = ref.putFile(
        File(xfile.path),
        SettableMetadata(contentType: 'image/jpeg'),
      );
    }

    // debug logs
    debugPrint('Uploading profile picture for user $uid');

    final snapshot = await task.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();

    debugPrint('Profile picture uploaded successfully: $url');
    await _userService.updateUser(uid, {'photoUrl': url});
    debugPrint('User $uid updated with new profile picture URL: $url');
  }

  @override
  Future<User?> getCurrentUser() {
    final fbUser = _userService.currentFirebaseUser;
    if (fbUser == null) return Future.value(null);
    return _userService.getUserById(fbUser.uid);
  }

  @override
  fb_auth.User? get currentFirebaseUser => _userService.currentFirebaseUser;
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authController = ref.read(authControllerProvider);
  return AuthNotifier(authController);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthController _authController;

  AuthNotifier(this._authController) : super(AuthState.initial()) {
    _init();
  }

  Future<void> _init() async {
    final user = await _authController.getCurrentUser();
    state = state.copyWith(currentUser: user, isInitializing: false);
  }

  Future<void> register({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final user = await _authController.registerUser(
        nombre: nombre,
        apellido: apellido,
        email: email,
        password: password,
      );
      state = state.copyWith(currentUser: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final user = await _authController.loginUser(email: email, password: password);

      if (user == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'Usuario no encontrado');
        return false;
      }

      state = state.copyWith(currentUser: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authController.logout();
    state = AuthState.initial();
  }

  Future<void> refreshUser() async {
    final user = await _authController.getCurrentUser();
    state = state.copyWith(currentUser: user);
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    final uid = state.currentUser?.uuid;
    if (uid == null) return;
    await _authController.updateUser(uid, data);
    await refreshUser();
  }
}

class AuthState {
  final bool isInitializing;
  final bool isLoading;
  final String? errorMessage;
  final User? currentUser;

  AuthState({required this.isInitializing, required this.isLoading, this.errorMessage, this.currentUser});

  factory AuthState.initial() => AuthState(isInitializing: true, isLoading: false, currentUser: null);

  AuthState copyWith({bool? isInitializing, bool? isLoading, String? errorMessage, User? currentUser}) {
    return AuthState(
      isInitializing: isInitializing ?? this.isInitializing,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
