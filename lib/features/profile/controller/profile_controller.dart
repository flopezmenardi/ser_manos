import '../../../models/user_model.dart';

abstract class ProfileController {
  Future<User> getUserById(String uid);
  Future<void> updateUser(String uid, Map<String, dynamic> data);
}
