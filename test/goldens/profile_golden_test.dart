import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ser_manos/features/users/controllers/user_controller_impl.dart';
import 'package:ser_manos/features/users/screens/profile_screen.dart';
import 'package:ser_manos/core/models/user_model.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

// ----------------------------
// FAKES & HELPERS
// ----------------------------

class FakeAuthNotifier extends StateNotifier<AuthState>
    implements AuthNotifier {
  FakeAuthNotifier(super.state);

  @override
  Future<void> logout() async {}

  @override
  Future<void> refreshUser() async {}

  @override
  Future<bool> login({required String email, required String password}) async =>
      true;

  @override
  Future<void> register({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> updateUser(Map<String, dynamic> data) async {}
  
  @override
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

void main() {
  testWidgets('ProfileScreen golden test - filled profile', (
    WidgetTester tester,
  ) async {
    final testUser = User(
      id: 'u1',
      name: 'Juan Pérez',
      surname: 'Pérez',
      email: 'juan@example.com',
      birthDate: Timestamp.fromDate(DateTime(2000, 1, 1)),
      registerDate: Timestamp.fromDate(DateTime(2023, 1, 1)),
      gender: 'Masculino',
      phoneNumber: '123456789',
      volunteering: null,
      photoUrl: null,
      acceptedVolunteering: false,
      favorites: [],
    );

    final authState = AuthState(
      isInitializing: false,
      isLoading: false,
      currentUser: testUser,
    );

    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(authState)),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProfileScreen),
      matchesGoldenFile('goldens/profile_filled.png'),
    );
  });
}
