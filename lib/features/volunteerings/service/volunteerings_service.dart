import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/volunteering_model.dart';

import '../controller/volunteerings_controller.dart';

final volunteeringsServiceProvider = Provider<VolunteeringsService>((ref) {
  return VolunteeringsService();
});

class VolunteeringsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Volunteering>> getAllVolunteeringsSorted({
    required VolunteeringSortMode sortMode,
    GeoPoint? userLocation,
  }) async {
    final snapshot = await _db.collection('voluntariados').get();
    final volunteerings =
        snapshot.docs
            .map((doc) => Volunteering.fromDocumentSnapshot(doc))
            .toList();

    switch (sortMode) {
      case VolunteeringSortMode.date:
        volunteerings.sort(
          (a, b) => b.fechaCreacion.compareTo(a.fechaCreacion),
        );
        break;
      case VolunteeringSortMode.proximity:
        if (userLocation == null) {
          throw Exception('User location is required for proximity sorting.');
        }
        volunteerings.sort((a, b) {
          final distA = _distanceBetween(userLocation, a.ubicacion);
          final distB = _distanceBetween(userLocation, b.ubicacion);
          return distA.compareTo(distB);
        });
        break;
    }

    return volunteerings;
  }

  Future<Volunteering?> getVolunteeringById(String id) async {
    final doc = await _db.collection('voluntariados').doc(id).get();
    if (!doc.exists) return null;
    return Volunteering.fromDocumentSnapshot(doc);
  }

  Future<void> applyToVolunteering(String uid, String volunteeringId) async {
    await _db.collection('usuarios').doc(uid).update({
      'voluntariado': volunteeringId,
      'voluntariadoAceptado': false,
    });
  }

  Future<void> withdrawApplication(String uid) async {
    await _db.collection('usuarios').doc(uid).update({
      'voluntariado': null,
      'voluntariadoAceptado': false,
    });
  }

  Future<void> abandonVolunteering(String uid, String volunteeringId) async {
    await _db.collection('usuarios').doc(uid).update({
      'voluntariado': null,
      'voluntariadoAceptado': false,
    });

    await _db.collection('voluntariados').doc(volunteeringId).update({
      'vacantes': FieldValue.increment(1),
    });
  }

  Future<void> toggleFavorite({
    required String uid,
    required String volunteeringId,
    required bool isFavorite,
  }) async {
    final userRef = _db.collection('usuarios').doc(uid);
    await userRef.update({
      'favoritos':
          isFavorite
              ? FieldValue.arrayRemove([volunteeringId])
              : FieldValue.arrayUnion([volunteeringId]),
    });
  }

  double _distanceBetween(GeoPoint a, GeoPoint b) {
    const R = 6371e3;
    final lat1 = a.latitude * (pi / 180);
    final lat2 = b.latitude * (pi / 180);
    final deltaLat = (b.latitude - a.latitude) * (pi / 180);
    final deltaLng = (b.longitude - a.longitude) * (pi / 180);

    final aVal =
        sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final c = 2 * atan2(sqrt(aVal), sqrt(1 - aVal));

    return R * c;
  }
}
