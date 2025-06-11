import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/profile/controller/profile_controller.dart';

import '../../../infrastructure/user_service.dart';
import '../../../models/user_model.dart';

final profileControllerProvider = Provider<ProfileController>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return ProfileControllerImpl(userRepository);
});

class ProfileControllerImpl implements ProfileController {
  final UserRepository _userRepository;

  ProfileControllerImpl(this._userRepository);

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
