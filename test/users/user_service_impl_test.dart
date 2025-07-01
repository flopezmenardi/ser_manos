import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos/features/users/services/user_service_impl.dart';
import 'package:ser_manos/models/user_model.dart';

import '../mocks/firebase_auth_mocks.mocks.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseAuth mockFirebaseAuth;
  late UserServiceImpl userService;

  const String userId = 'test-uid';
  const String email = 'test@example.com';
  const String password = 'password123';

  final testUser = User(
    id: userId,
    name: 'Juan',
    surname: 'Pérez',
    email: email,
    birthDate: '2000-01-01',
    registerDate: Timestamp.fromDate(DateTime.now()),
    gender: 'Masculino',
    phoneNumber: '123456789',
    volunteering: null,
    photoUrl: null,
    acceptedVolunteering: false,
    favorites: [],
  );

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockFirebaseAuth = MockFirebaseAuth();

    userService = UserServiceImpl(auth: mockFirebaseAuth, db: fakeFirestore);
  });

  group('createUser & getUserById', () {
    test('should create and retrieve user correctly', () async {
      await userService.createUser(userId, testUser.name, testUser.surname, testUser.email);

      final result = await userService.getUserById(userId);

      expect(result, isNotNull);
      expect(result!.name, testUser.name);
      expect(result.surname, testUser.surname);
      expect(result.email, testUser.email);
    });
  });

  group('registerUser', () {
    test('should register new user', () async {
      final mockUserCredential = MockUserCredential();
      final mockFirebaseUser = MockUser();

      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockFirebaseUser);
      when(mockFirebaseUser.uid).thenReturn(userId);

      await userService.registerUser(
        nombre: testUser.name,
        apellido: testUser.surname,
        email: email,
        password: password,
      );

      final storedUser = await fakeFirestore.collection('usuarios').doc(userId).get();
      expect(storedUser.exists, isTrue);
      expect(storedUser.data()!['nombre'], testUser.name);
    });
  });

  group('loginUser', () {
    test('should login and return user', () async {
      await userService.createUser(userId, testUser.name, testUser.surname, testUser.email);

      final mockUserCredential = MockUserCredential();
      final mockFirebaseUser = MockUser();

      when(
        mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockFirebaseUser);
      when(mockFirebaseUser.uid).thenReturn(userId);

      final user = await userService.loginUser(email: email, password: password);

      expect(user, isNotNull);
      expect(user!.id, userId);
      expect(user.name, testUser.name);
    });
  });

  group('updateUser', () {
    test('should update user fields', () async {
      await userService.createUser(userId, testUser.name, testUser.surname, testUser.email);

      await userService.updateUser(userId, {'telefono': '999999999'});

      final updatedUser = await userService.getUserById(userId);
      expect(updatedUser!.phoneNumber, '999999999');
    });
  });

  group('logout', () {
    test('should call signOut', () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await userService.logout();

      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}
