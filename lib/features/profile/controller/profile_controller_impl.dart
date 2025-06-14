import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ser_manos/features/profile/controller/profile_controller.dart';

import '../../../models/user_model.dart';
import '../../users/services/user_service.dart';
import '../../users/services/user_service_impl.dart';

final profileControllerProvider = Provider<ProfileController>((ref) {
  final userRepository = ref.read(userServiceProvider);
  return ProfileControllerImpl(userRepository);
});

class ProfileControllerImpl implements ProfileController {
  final UserService _userRepository;

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

  Future<void> uploadProfilePicture(String uid, XFile xfile) async {
    final ref = FirebaseStorage.instance.ref('users/$uid/profile_picture.jpg');

    UploadTask task;
    if (kIsWeb) {
      final bytes = await xfile.readAsBytes();
      task = ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    } else {
      task = ref.putFile(File(xfile.path), SettableMetadata(contentType: 'image/jpeg'));
    }

    // debug logs
    debugPrint('Uploading profile picture for user $uid');

    final snapshot = await task.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();

    debugPrint('Profile picture uploaded successfully: $url');
    await _userRepository.updateUser(uid, {'photoUrl': url});
    debugPrint('User $uid updated with new profile picture URL: $url');
  }
}
