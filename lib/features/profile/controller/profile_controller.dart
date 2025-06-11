import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/user_service.dart';
import '../../../models/user_model.dart';

// Provider for UserRepository already exists in userRepositoryProvider

// ProfileController manages user-related actions in profile screen.
final profileControllerProvider = Provider<ProfileController>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return ProfileController(userRepository);
});

class ProfileController {
  final UserRepository _userRepository;

  ProfileController(this._userRepository);

  // Fetch user by UID
  Future<User> getUserById(String uid) async {
    final user = await _userRepository.getUserById(uid);
    if (user == null) {
      throw Exception('Usuario con ID $uid no encontrado');
    }
    return user;
  }

  // Update user data
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _userRepository.updateUser(uid, data);
  }
}
