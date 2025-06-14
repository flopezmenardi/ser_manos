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

  const String uid = 'test-uid';
  const String email = 'test@example.com';
  const String password = 'password123';

  final testUser = User(
    uuid: uid,
    nombre: 'Juan',
    apellido: 'Pérez',
    email: email,
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
    fakeFirestore = FakeFirebaseFirestore();
    mockFirebaseAuth = MockFirebaseAuth();

    userService = UserServiceImpl(auth: mockFirebaseAuth, db: fakeFirestore);
  });

  group('createUser & getUserById', () {
    test('should create and retrieve user correctly', () async {
      await userService.createUser(uid, testUser.nombre, testUser.apellido, testUser.email);

      final result = await userService.getUserById(uid);

      expect(result, isNotNull);
      expect(result!.nombre, testUser.nombre);
      expect(result.apellido, testUser.apellido);
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
      when(mockFirebaseUser.uid).thenReturn(uid);

      await userService.registerUser(
        nombre: testUser.nombre,
        apellido: testUser.apellido,
        email: email,
        password: password,
      );

      final storedUser = await fakeFirestore.collection('usuarios').doc(uid).get();
      expect(storedUser.exists, isTrue);
      expect(storedUser.data()!['nombre'], testUser.nombre);
    });
  });

  group('loginUser', () {
    test('should login and return user', () async {
      await userService.createUser(uid, testUser.nombre, testUser.apellido, testUser.email);

      final mockUserCredential = MockUserCredential();
      final mockFirebaseUser = MockUser();

      when(
        mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockFirebaseUser);
      when(mockFirebaseUser.uid).thenReturn(uid);

      final user = await userService.loginUser(email: email, password: password);

      expect(user, isNotNull);
      expect(user!.uuid, uid);
      expect(user.nombre, testUser.nombre);
    });
  });

  group('updateUser', () {
    test('should update user fields', () async {
      await userService.createUser(uid, testUser.nombre, testUser.apellido, testUser.email);

      await userService.updateUser(uid, {'telefono': '999999999'});

      final updatedUser = await userService.getUserById(uid);
      expect(updatedUser!.telefono, '999999999');
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
