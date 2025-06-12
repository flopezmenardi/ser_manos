import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/infrastructure/user_service.dart';

import '../models/user_model.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserServiceImpl();
});

class UserServiceImpl implements UserService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> getUserById(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    if (!doc.exists) return null;
    return User.fromDocumentSnapshot(doc);
  }

  Future<User?> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final uid = userCredential.user!.uid;

    await createUser(uid, nombre, apellido, email);
    return getUserById(uid);
  }

  Future<void> createUser(String uid, String nombre, String apellido, String email) async {
    await _db.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'fechaRegistro': FieldValue.serverTimestamp(),
      'telefono': '',
      'genero': '',
      'fechaNacimiento': '',
      'voluntariado': null,
      'voluntariadoAceptado': false,
      'favoritos': <String>[],
    });
  }

  Future<User?> loginUser({required String email, required String password}) async {
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final uid = userCredential.user!.uid;
    return getUserById(uid);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('usuarios').doc(uid).update(data);
  }

  fb_auth.User? get currentFirebaseUser => _auth.currentUser;
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final userService = ref.read(userServiceProvider);
  return AuthNotifier(userService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final UserService _userRepo;

  AuthNotifier(this._userRepo) : super(AuthState.initial()) {
    _init();
  }

  Future<void> _init() async {
    final fbUser = _userRepo.currentFirebaseUser;
    if (fbUser != null) {
      final user = await _userRepo.getUserById(fbUser.uid);
      state = state.copyWith(currentUser: user, isInitializing: false);
    } else {
      state = state.copyWith(isInitializing: false);
    }
  }

  Future<void> register({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final user = await _userRepo.registerUser(nombre: nombre, apellido: apellido, email: email, password: password);
      state = state.copyWith(currentUser: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final user = await _userRepo.loginUser(email: email, password: password);
      state = state.copyWith(currentUser: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> logout() async {
    await _userRepo.logout();
    state = AuthState.initial();
  }

  Future<void> refreshUser() async {
    final fbUser = _userRepo.currentFirebaseUser;
    if (fbUser == null) return;
    final user = await _userRepo.getUserById(fbUser.uid);
    state = state.copyWith(currentUser: user);
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    final uid = state.currentUser?.uuid;
    if (uid == null) return;
    await _userRepo.updateUser(uid, data);
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
