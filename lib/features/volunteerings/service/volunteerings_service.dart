import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/enums/sort_mode.dart';
import '../../../models/volunteering_model.dart';

abstract class VolunteeringsService {
  Future<List<Volunteering>> getAllVolunteeringsSorted({required SortMode sortMode, GeoPoint? userLocation});
  Future<Volunteering?> getVolunteeringById(String id);
  Future<void> applyToVolunteering(String userId, String volunteeringId);
  Future<void> withdrawApplication(String userId);
  Future<void> abandonVolunteering(String userId, String volunteeringId);
  Future<void> toggleFavorite({required String userId, required String volunteeringId, required bool isFavorite});
  Future<int> getFavoritesCount(String volunteeringId);
}
