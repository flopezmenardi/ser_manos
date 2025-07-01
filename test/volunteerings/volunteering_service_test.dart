import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:ser_manos/features/volunteerings/service/volunteerings_service_impl.dart';
import 'package:ser_manos/infrastructure/analytics_service.dart';
import 'package:ser_manos/models/enums/sort_mode.dart';
import 'package:ser_manos/models/volunteering_model.dart';

import '../mocks/analytics_service_mock.mocks.dart';

@GenerateMocks([AnalyticsService])
void main() {
  late FakeFirebaseFirestore firestore;
  late MockAnalyticsService mockAnalyticsService;
  late VolunteeringsServiceImpl service;

  const uid = 'user-1';
  const volunteeringId = 'v1';

  final volunteering = Volunteering(
    id: volunteeringId,
    title: 'Recolección de alimentos',
    description: 'Ayuda a recolectar alimentos',
    summary: 'Breve resumen',
    creator: 'ONG Esperanza',
    vacants: 3,
    requirements: 'Mayor de edad',
    address: 'Calle Falsa 123',
    location: const GeoPoint(-34.6037, -58.3816),
    imageURL: 'https://imagen.com',
    creationDate: Timestamp.fromDate(DateTime(2024, 6, 1)),
    startDate: Timestamp.fromDate(DateTime(2024, 6, 15)),
    likes: 5,
  );

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    mockAnalyticsService = MockAnalyticsService();
    service = VolunteeringsServiceImpl(db: firestore, analyticsService: mockAnalyticsService);

    await firestore.collection('voluntariados').doc(volunteeringId).set(volunteering.toMap());
    await firestore.collection('usuarios').doc(uid).set({
      'voluntariado': null,
      'voluntariadoAceptado': false,
      'favoritos': [],
    });
  });

  test('getVolunteeringById returns volunteering', () async {
    final result = await service.getVolunteeringById(volunteeringId);
    expect(result, isNotNull);
    expect(result!.title, volunteering.title);
  });

  test('applyToVolunteering sets user fields correctly', () async {
    await service.applyToVolunteering(uid, volunteeringId);
    final updated = await firestore.collection('usuarios').doc(uid).get();
    expect(updated['voluntariado'], volunteeringId);
    expect(updated['voluntariadoAceptado'], false);
  });

  test('withdrawApplication clears user volunteering', () async {
    await service.applyToVolunteering(uid, volunteeringId);
    await service.withdrawApplication(uid);
    final updated = await firestore.collection('usuarios').doc(uid).get();
    expect(updated['voluntariado'], null);
  });

  test('abandonVolunteering updates user and increments vacantes', () async {
    await service.abandonVolunteering(uid, volunteeringId);

    final user = await firestore.collection('usuarios').doc(uid).get();
    final vol = await firestore.collection('voluntariados').doc(volunteeringId).get();

    expect(user['voluntariado'], null);
    expect(vol['vacantes'], volunteering.vacants + 1);
  });

  test('toggleFavorite adds and removes correctly', () async {
    await service.toggleFavorite(userId: uid, volunteeringId: volunteeringId, isFavorite: false);
    var user = await firestore.collection('usuarios').doc(uid).get();
    expect(user['favoritos'], contains(volunteeringId));

    await service.toggleFavorite(userId: uid, volunteeringId: volunteeringId, isFavorite: true);
    user = await firestore.collection('usuarios').doc(uid).get();
    expect(user['favoritos'], isNot(contains(volunteeringId)));
  });

  test('getFavoritesCount returns correct number', () async {
    await firestore.collection('voluntariados').doc(volunteeringId).update({'likes': 8});
    final count = await service.getFavoritesCount(volunteeringId);
    expect(count, 8);
  });

  test('getAllVolunteeringsSorted by date returns correct order', () async {
    final other = volunteering.copyWith(id: 'v2', creationDate: Timestamp.fromDate(DateTime(2024, 7, 1)));
    await firestore.collection('voluntariados').doc('v2').set(other.toMap());

    final result = await service.getAllVolunteeringsSorted(sortMode: SortMode.date);
    expect(result.first.id, 'v2');
  });

  test('getAllVolunteeringsSorted by proximity returns nearest first', () async {
    final other = volunteering.copyWith(id: 'v2', location: const GeoPoint(-34.60, -58.38));
    await firestore.collection('voluntariados').doc('v2').set(other.toMap());

    final result = await service.getAllVolunteeringsSorted(
      sortMode: SortMode.proximity,
      userLocation: const GeoPoint(-34.60, -58.38),
    );
    expect(result.first.id, 'v2');
  });
}
