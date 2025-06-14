import 'package:image_picker/image_picker.dart';
import '../../../models/user_model.dart';

abstract class ProfileController {
  Future<User> getUserById(String uid);
  Future<void> updateUser(String uid, Map<String, dynamic> data);
  Future<void> uploadProfilePicture(String uid, XFile xfile);
}
