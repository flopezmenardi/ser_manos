import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/user_model.dart';

import '../../../infrastructure/firestore_service.dart';

/// Obtener usuario por ID
final userByIdProvider = FutureProvider.family<User, String>((ref, uid) async {
  final firestore = ref.watch(firestoreServiceProvider);
  final user = await firestore.getUserById(uid);
  if (user == null) throw Exception('Usuario con ID $uid no encontrado');
  return user;
});

/// Llamar a este provider para actualizar datos del usuario
final updateUserProvider = Provider<UserUpdater>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return (String uid, Map<String, dynamic> data) async {
    await firestore.updateUser(uid, data);
  };
});

/// Tipo del updater (una función)
typedef UserUpdater =
    Future<void> Function(String uid, Map<String, dynamic> data);
