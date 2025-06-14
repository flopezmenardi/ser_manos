import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos/features/users/controllers/user_controller_impl.dart';
import 'package:ser_manos/models/user_model.dart';

import '../mocks/user_service_mock.mocks.dart';

void main() {
  late MockUserService mockUserService;
  late UserControllerImpl userController;

  const userId = 'test-uid';
  final testUser = User(
    uuid: userId,
    nombre: 'Juan',
    apellido: 'Pérez',
    email: 'juan@example.com',
    fechaNacimiento: '2000-01-01',
    fechaRegistro: Timestamp.fromDate(DateTime.now()),
    genero: 'Masculino',
    telefono: '123456789',
    voluntariado: null,
    photoUrl: null,
    voluntariadoAceptado: false,
    favoritos: [],
  );

  setUp(() {
    mockUserService = MockUserService();
    userController = UserControllerImpl(mockUserService);
  });

  group('registerUser', () {
    test('should call userService.registerUser and return User', () async {
      when(
        mockUserService.registerUser(
          nombre: anyNamed('nombre'),
          apellido: anyNamed('apellido'),
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => testUser);

      final result = await userController.registerUser(
        nombre: 'Juan',
        apellido: 'Pérez',
        email: 'juan@example.com',
        password: 'password123',
      );

      expect(result, testUser);
      verify(
        mockUserService.registerUser(
          nombre: 'Juan',
          apellido: 'Pérez',
          email: 'juan@example.com',
          password: 'password123',
        ),
      ).called(1);
    });
  });

  group('loginUser', () {
    test('should call userService.loginUser and return User', () async {
      when(
        mockUserService.loginUser(email: anyNamed('email'), password: anyNamed('password')),
      ).thenAnswer((_) async => testUser);

      final result = await userController.loginUser(email: 'juan@example.com', password: 'password123');

      expect(result, testUser);
      verify(mockUserService.loginUser(email: 'juan@example.com', password: 'password123')).called(1);
    });
  });

  group('logout', () {
    test('should call userService.logout', () async {
      when(mockUserService.logout()).thenAnswer((_) async {});

      await userController.logout();

      verify(mockUserService.logout()).called(1);
    });
  });

  group('updateUser', () {
    test('should call userService.updateUser with correct params', () async {
      final updateData = {'nombre': 'NuevoNombre'};

      when(mockUserService.updateUser(userId, updateData)).thenAnswer((_) async {});

      await userController.updateUser(userId, updateData);

      verify(mockUserService.updateUser(userId, updateData)).called(1);
    });
  });

  group('getCurrentUser', () {
    test('should return current user if firebase user exists', () async {
      when(mockUserService.currentFirebaseUser).thenReturn(MockFirebaseUser(userId));
      when(mockUserService.getUserById(userId)).thenAnswer((_) async => testUser);

      final result = await userController.getCurrentUser();

      expect(result, testUser);
      verify(mockUserService.getUserById(userId)).called(1);
    });

    test('should return null if firebase user is null', () async {
      when(mockUserService.currentFirebaseUser).thenReturn(null);

      final result = await userController.getCurrentUser();

      expect(result, null);
    });
  });
}

class MockFirebaseUser extends Mock implements fb_auth.User {
  final String uidMock;

  MockFirebaseUser(this.uidMock);

  @override
  String get uid => uidMock;
}
