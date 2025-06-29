import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos/features/volunteerings/controller/volunteerings_controller.dart';
import 'package:ser_manos/features/volunteerings/controller/volunteerings_controller_impl.dart';
import 'package:ser_manos/models/enums/sort_mode.dart';
import 'package:ser_manos/models/user_model.dart';
import 'package:ser_manos/models/volunteering_model.dart';

import '../mocks/analytics_service_mock.mocks.dart';
import '../mocks/volunteering_service_mock.mocks.dart';
import '../mocks/volunteering_view_tracker_mock.mocks.dart';

void main() {
  group('VolunteeringsControllerImpl with mocked services', () {
    late MockVolunteeringsService mockService;
    late MockAnalyticsService mockAnalyticsService;
    late MockViewTracker mockViewTracker;
    late VolunteeringsControllerImpl controller;
    late Volunteering volunteering;
    late User user;

    setUp(() {
      mockService = MockVolunteeringsService();
      mockAnalyticsService = MockAnalyticsService();
      mockViewTracker = MockViewTracker();

      volunteering = Volunteering(
        id: 'v1',
        titulo: 'Título',
        descripcion: 'Descripción',
        resumen: 'Resumen',
        emisor: 'Emisor',
        vacantes: 5,
        requisitos: 'Mayor de 18',
        imagenURL: 'https://img.com',
        direccion: 'Calle 123',
        ubicacion: const GeoPoint(0, 0),
        likes: 0,
        fechaCreacion: Timestamp.fromDate(DateTime(2024, 1, 1)),
        fechaInicio: Timestamp.fromDate(DateTime(2025, 1, 1)),
      );

      user = User(
        uuid: 'u1',
        nombre: 'Juan',
        apellido: 'Pérez',
        email: 'juan@mail.com',
        telefono: '123456789',
        genero: 'Masculino',
        fechaNacimiento: '01/01/2000',
        favoritos: [],
        voluntariado: '',
        fechaRegistro: Timestamp.fromDate(DateTime(2023, 1, 1)),
        voluntariadoAceptado: false,
      );

      controller = VolunteeringsControllerImpl(
        volunteeringsService: mockService,
        analyticsService: mockAnalyticsService,
        currentUser: user,
        viewTracker: mockViewTracker,
      );
    });

    test('applyToVolunteering - success', () async {
      when(mockService.getVolunteeringById(volunteering.id)).thenAnswer((_) async => volunteering);
      when(mockService.applyToVolunteering(user.uuid, volunteering.id)).thenAnswer((_) async {});

      await controller.applyToVolunteering(volunteering.id);

      verify(mockService.getVolunteeringById(volunteering.id)).called(1);
      verify(mockService.applyToVolunteering(user.uuid, volunteering.id)).called(1);
    });

    test('applyToVolunteering - throws if profile incomplete', () async {
      final incompleteUser = user.copyWith(telefono: '');
      final c = VolunteeringsControllerImpl(
        volunteeringsService: mockService,
        analyticsService: mockAnalyticsService,
        currentUser: incompleteUser,
        viewTracker: mockViewTracker,
      );

      expect(() => c.applyToVolunteering(volunteering.id), throwsException);
    });

    test('applyToVolunteering - throws if already applied', () async {
      final appliedUser = user.copyWith(voluntariado: 'some_id');
      final c = VolunteeringsControllerImpl(
        volunteeringsService: mockService,
        analyticsService: mockAnalyticsService,
        currentUser: appliedUser,
        viewTracker: mockViewTracker,
      );

      expect(() => c.applyToVolunteering(volunteering.id), throwsException);
    });

    test('applyToVolunteering - throws if no vacancies', () async {
      final noVacancies = volunteering.copyWith(vacantes: 0);
      when(mockService.getVolunteeringById(volunteering.id)).thenAnswer((_) async => noVacancies);

      expect(() => controller.applyToVolunteering(volunteering.id), throwsException);
    });

    test('abandonVolunteering calls service', () async {
      when(mockService.abandonVolunteering(user.uuid, 'v1')).thenAnswer((_) async {});
      await controller.abandonVolunteering('v1');
      verify(mockService.abandonVolunteering(user.uuid, 'v1')).called(1);
    });

    test('withdrawApplication calls service', () async {
      when(mockService.withdrawApplication(user.uuid)).thenAnswer((_) async {});
      await controller.withdrawApplication();
      verify(mockService.withdrawApplication(user.uuid)).called(1);
    });

    test('toggleFavorite calls service correctly', () async {
      when(
        mockService.toggleFavorite(userId: user.uuid, volunteeringId: 'v1', isFavorite: false),
      ).thenAnswer((_) async {});
      await controller.toggleFavorite('v1', false);
      verify(mockService.toggleFavorite(userId: user.uuid, volunteeringId: 'v1', isFavorite: false)).called(1);
    });

    test('getFavoritesCount returns correct count', () async {
      when(mockService.getFavoritesCount('v1')).thenAnswer((_) async => 2);
      final count = await controller.getFavoritesCount('v1');
      expect(count, 2);
    });

    test('searchVolunteerings filters correctly by query', () async {
      when(mockService.getAllVolunteeringsSorted(sortMode: SortMode.date)).thenAnswer((_) async => [volunteering]);
      final result = await controller.searchVolunteerings(
        VolunteeringQueryState(query: 'Título', sortMode: SortMode.date, userLocation: null),
      );
      expect(result.length, 1);
    });

    test('getVolunteeringById returns volunteering', () async {
      when(mockService.getVolunteeringById('v1')).thenAnswer((_) async => volunteering);
      final v = await controller.getVolunteeringById('v1');
      expect(v.id, 'v1');
    });

    test('getVolunteeringById throws if null', () async {
      when(mockService.getVolunteeringById('not_found')).thenAnswer((_) async => null);
      expect(() => controller.getVolunteeringById('not_found'), throwsException);
    });

    test('logViewedVolunteering calls tracker and analytics', () async {
      when(mockAnalyticsService.logViewedVolunteering(volunteering.id)).thenAnswer((_) async {});

      await controller.logViewedVolunteering(volunteering.id);

      verify(mockViewTracker.registerView(volunteering.id)).called(1);
      verify(mockAnalyticsService.logViewedVolunteering(volunteering.id)).called(1);
    });

    test('logVolunteeringApplication calls analytics with views count and resets tracker', () async {
      when(
        mockAnalyticsService.logVolunteeringApplication(
          volunteeringId: volunteering.id,
          viewsBeforeApplying: anyNamed('viewsBeforeApplying'),
        ),
      ).thenAnswer((_) async {});

      when(mockViewTracker.viewsCount).thenReturn(3);

      await controller.logVolunteeringApplication(volunteering.id);

      verify(
        mockAnalyticsService.logVolunteeringApplication(volunteeringId: volunteering.id, viewsBeforeApplying: 3),
      ).called(1);

      verify(mockViewTracker.reset()).called(1);
    });
  });
}
