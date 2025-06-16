import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos/features/users/screens/profile_screen.dart';
import 'package:ser_manos/models/user_model.dart';
import 'package:ser_manos/features/users/controllers/user_controller_impl.dart';

// import '../mocks/auth_notifier_mock.mocks.dart';
import '../mocks/auth_notifier_listener_mock.mocks.dart';


import 'package:ser_manos/features/users/controllers/user_controller_impl.dart';

// ----------------------------
// FAKES & HELPERS
// ----------------------------

class FakeAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  FakeAuthNotifier(AuthState state) : super(state);

  @override
  Future<void> logout() async {}

  @override
  Future<void> refreshUser() async {}

  @override
  Future<bool> login({required String email, required String password}) async => true;

  @override
  Future<void> register({required String nombre, required String apellido, required String email, required String password}) async {}

  @override
  Future<void> updateUser(Map<String, dynamic> data) async {}
}

void main() {
  testWidgets('ProfileScreen golden test - filled profile', (WidgetTester tester) async {
    final testUser = User(
      uuid: 'u1',
      nombre: 'Juan Pérez',
      apellido: 'Pérez',
      email: 'juan@example.com',
      fechaNacimiento: '2000-01-01',
      fechaRegistro: Timestamp.fromDate(DateTime(2023, 1, 1)),
      genero: 'Masculino',
      telefono: '123456789',
      voluntariado: null,
      photoUrl: null,
      voluntariadoAceptado: false,
      favoritos: [],
    );

    final authState = AuthState(
      isInitializing: false,
      isLoading: false,
      currentUser: testUser,
    );

    final container = ProviderContainer(overrides: [
      authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(authState)),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProfileScreen),
      matchesGoldenFile('goldens/profile_filled.png'),
    );
  });
}