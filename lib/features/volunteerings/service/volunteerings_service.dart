import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/volunteering_model.dart';
import '../controller/volunteerings_controller_impl.dart';

abstract class VolunteeringsService {
  Future<List<Volunteering>> getAllVolunteeringsSorted({
    required VolunteeringSortMode sortMode,
    GeoPoint? userLocation,
  });
  Future<Volunteering?> getVolunteeringById(String id);
  Future<void> applyToVolunteering(String uid, String volunteeringId);
  Future<void> withdrawApplication(String uid);
  Future<void> abandonVolunteering(String uid, String volunteeringId);
  Future<void> toggleFavorite({required String uid, required String volunteeringId, required bool isFavorite});
  Future<int> getFavoritesCount(String volunteeringId);
}
