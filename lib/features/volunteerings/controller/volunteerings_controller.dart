import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/enums/sort_mode.dart';
import '../../../models/volunteering_model.dart';

abstract class VolunteeringsController {
  Future<void> applyToVolunteering(String volunteeringId);
  Future<void> abandonVolunteering(String volunteeringId);
  Future<void> withdrawApplication();
  Future<void> toggleFavorite(String volunteeringId, bool isFavorite);
  Future<int> getFavoritesCount(String volunteeringId);
  Future<List<Volunteering>> searchVolunteerings(VolunteeringQueryState queryState);
  Future<Volunteering> getVolunteeringById(String id);
  Future<void> logLikedVolunteering(String volunteeringId, bool isLiked);
  Future<void> logViewedVolunteering(String volunteeringId);
}

// This could be transitioned into an implementation detail and simplify the contract into taking
// String, SortMode and GeoPoint instead of the full VolunteeringQueryState class
class VolunteeringQueryState {
  final String query;
  final SortMode sortMode;
  final GeoPoint? userLocation;

  VolunteeringQueryState({required this.query, required this.sortMode, this.userLocation});

  VolunteeringQueryState copyWith({String? query, SortMode? sortMode, GeoPoint? userLocation}) {
    return VolunteeringQueryState(
      query: query ?? this.query,
      sortMode: sortMode ?? this.sortMode,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}
