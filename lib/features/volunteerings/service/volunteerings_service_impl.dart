import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/volunteerings/service/volunteerings_service.dart';
import 'package:ser_manos/models/volunteering_model.dart';

import '../../../infrastructure/analytics_service.dart';
import '../../../infrastructure/analytics_service_impl.dart';
import '../../../models/enums/sort_mode.dart';

final volunteeringsServiceProvider = Provider<VolunteeringsService>((ref) {
  final analyticsService = ref.watch(analyticsServiceProvider);
  return VolunteeringsServiceImpl(analyticsService: analyticsService);
});

class VolunteeringsServiceImpl implements VolunteeringsService {
  final FirebaseFirestore _db;
  final AnalyticsService _analyticsService;

  VolunteeringsServiceImpl({FirebaseFirestore? db, required AnalyticsService analyticsService})
    : _db = db ?? FirebaseFirestore.instance,
      _analyticsService = analyticsService;

  @override
  Future<List<Volunteering>> getAllVolunteeringsSorted({required SortMode sortMode, GeoPoint? userLocation}) async {
    final snapshot = await _db.collection('voluntariados').get();
    final volunteerings = snapshot.docs.map((doc) => Volunteering.fromDocumentSnapshot(doc)).toList();

    switch (sortMode) {
      case SortMode.date:
        volunteerings.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
        break;
      case SortMode.proximity:
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

  @override
  Future<Volunteering?> getVolunteeringById(String id) async {
    final doc = await _db.collection('voluntariados').doc(id).get();
    if (!doc.exists) return null;
    return Volunteering.fromDocumentSnapshot(doc);
  }

  @override
  Future<void> applyToVolunteering(String uid, String volunteeringId) async {
    await _db.collection('usuarios').doc(uid).update({'voluntariado': volunteeringId, 'voluntariadoAceptado': false});
  }

  @override
  Future<void> withdrawApplication(String uid) async {
    await _db.collection('usuarios').doc(uid).update({'voluntariado': null, 'voluntariadoAceptado': false});
  }

  @override
  Future<void> abandonVolunteering(String uid, String volunteeringId) async {
    final volunteeringDoc = await _db.collection('voluntariados').doc(volunteeringId).get();
    final data = volunteeringDoc.data();

    if (data != null && data.containsKey('fechaInicio')) {
      final fechaInicio = (data['fechaInicio'] as Timestamp).toDate();
      final now = DateTime.now();
      final daysBefore = fechaInicio.difference(now).inDays;

      try {
        await _analyticsService.logWithdrawVolunteering(volunteeringId: volunteeringId, daysBeforeStart: daysBefore);
      } catch (e, stackTrace) {
        await FirebaseCrashlytics.instance.recordError(e, stackTrace);
      }
    }

    await _db.collection('usuarios').doc(uid).update({'voluntariado': null, 'voluntariadoAceptado': false});

    await _db.collection('voluntariados').doc(volunteeringId).update({'vacantes': FieldValue.increment(1)});
  }

  @override
  Future<void> toggleFavorite({required String uid, required String volunteeringId, required bool isFavorite}) async {
    final userRef = _db.collection('usuarios').doc(uid);
    final volunteeringRef = _db.collection('voluntariados').doc(volunteeringId);

    await _db.runTransaction((transaction) async {
      //Read from volunteering document
      final snapshot = await transaction.get(volunteeringRef);
      final currentLikes = snapshot.get('likes') as int? ?? 0;

      //Compute new like count
      final newLikes = isFavorite ? currentLikes - 1 : currentLikes + 1;

      //Write to user and volunteering
      transaction.update(userRef, {
        'favoritos': isFavorite ? FieldValue.arrayRemove([volunteeringId]) : FieldValue.arrayUnion([volunteeringId]),
      });

      transaction.update(volunteeringRef, {'likes': newLikes.clamp(0, double.infinity)});
    });
  }

  @override
  Future<int> getFavoritesCount(String volunteeringId) async {
    final doc = await _db.collection('voluntariados').doc(volunteeringId).get();
    final likes = doc.data()?['likes'];
    return likes is int ? likes : 0;
  }

  double _distanceBetween(GeoPoint a, GeoPoint b) {
    const R = 6371e3;
    final lat1 = a.latitude * (pi / 180);
    final lat2 = b.latitude * (pi / 180);
    final deltaLat = (b.latitude - a.latitude) * (pi / 180);
    final deltaLng = (b.longitude - a.longitude) * (pi / 180);

    final aVal = sin(deltaLat / 2) * sin(deltaLat / 2) + cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final c = 2 * atan2(sqrt(aVal), sqrt(1 - aVal));

    return R * c;
  }
}
