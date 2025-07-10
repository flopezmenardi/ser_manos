import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/enums/sort_mode.dart';
import '../../../core/models/volunteering_model.dart';

abstract class VolunteeringsController {
  Future<void> applyToVolunteering(String volunteeringId);
  Future<void> abandonVolunteering(String volunteeringId);
  Future<void> withdrawApplication();
  Future<void> toggleFavorite(String volunteeringId, bool isFavorite);
  Future<int> getFavoritesCount(String volunteeringId);
  Future<List<Volunteering>> searchVolunteerings(VolunteeringQueryState queryState);
  Future<Volunteering> getVolunteeringById(String volunteeringId);
  Future<void> logLikedVolunteering(String volunteeringId);
  Future<void> logViewedVolunteering(String volunteeringId);
  Future<void> logVolunteeringApplication(String volunteeringId);
  Stream<Volunteering> watchVolunteering(String id);
  Stream<List<Volunteering>> watchVolunteerings(VolunteeringQueryState queryState);
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
