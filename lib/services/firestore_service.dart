import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ser_manos/models/news_model.dart';
import 'package:ser_manos/models/volunteering_model.dart';

import '../features/home/controller/volunteering_controller.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(
    String uid,
    String nombre,
    String apellido,
    String email,
  ) async {
    await _db.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'fechaRegistro': FieldValue.serverTimestamp(),
      'telefono': '',
      'genero': '',
      'fechaNacimiento': '',
      'voluntariado': null,
      'voluntariadoAceptado': false,
    });
  }

  Stream<List<News>> getNews() {
    return _db.collection('novedades').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => News.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  Stream<List<News>> getNewsOrderedByDate() {
    return _db
        .collection('novedades')
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => News.fromDocumentSnapshot(doc))
              .toList();
        });
  }

  Future<News?> getNewsById(String id) async {
    final doc = await _db.collection('novedades').doc(id).get();
    if (doc.exists) {
      return News.fromDocumentSnapshot(doc);
    }
    return null; //Pedrolopez1
  }

  Future<List<Volunteering>> getAllVolunteerings() async {
    final snapshot = await _db.collection('voluntariados').get();
    return snapshot.docs
        .map((doc) => Volunteering.fromDocumentSnapshot(doc))
        .toList();
  }

  Future<Volunteering?> getVolunteeringById(String id) async {
    final doc = await _db.collection('voluntariados').doc(id).get();
    if (!doc.exists) return null;
    return Volunteering.fromDocumentSnapshot(doc);
  }

  Future<User?> getUserById(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    if (!doc.exists) return null;
    return User.fromDocumentSnapshot(doc);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('usuarios').doc(uid).update(data);
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

    // Aumentar vacantes en el voluntariado
    await _db.collection('voluntariados').doc(volunteeringId).update({
      'vacantes': FieldValue.increment(1),
    });
  }

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

  double _distanceBetween(GeoPoint a, GeoPoint b) {
    const R = 6371e3; // Earth radius in meters
    final lat1 = a.latitude * (pi / 180);
    final lat2 = b.latitude * (pi / 180);
    final deltaLat = (b.latitude - a.latitude) * (pi / 180);
    final deltaLng = (b.longitude - a.longitude) * (pi / 180);

    final aVal =
        sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final c = 2 * atan2(sqrt(aVal), sqrt(1 - aVal));

    return R * c; // in meters
  }
}
