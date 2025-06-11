import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/profile/service/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileServiceImpl();
});

class ProfileServiceImpl implements ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('usuarios').doc(uid).update(data);
  }
}
