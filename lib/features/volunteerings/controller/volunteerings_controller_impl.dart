import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/volunteerings/controller/volunteerings_controller.dart';
import 'package:ser_manos/infrastructure/analytics_service.dart';
import 'package:ser_manos/infrastructure/volunteering_view_tracker.dart';
import 'package:ser_manos/models/volunteering_model.dart';

import '../../../infrastructure/user_service_impl.dart';
import '../../../models/user_model.dart';
import '../service/volunteerings_service.dart';
import '../service/volunteerings_service_impl.dart';

final volunteeringsControllerProvider = Provider<VolunteeringsController>((ref) {
  final volunteeringsService = ref.read(volunteeringsServiceProvider);
  final currentUser = ref.watch(authNotifierProvider).currentUser!;
  return VolunteeringsControllerImpl(volunteeringsService: volunteeringsService, currentUser: currentUser);
});

class VolunteeringsControllerImpl implements VolunteeringsController {
  final VolunteeringsService volunteeringsService;
  final User currentUser;

  VolunteeringsControllerImpl({required this.volunteeringsService, required this.currentUser});

  Future<void> applyToVolunteering(String volunteeringId) async {
    print(currentUser.genero);
    print(currentUser.telefono);
    print(currentUser.fechaNacimiento);
    if (currentUser.telefono.isEmpty || currentUser.genero.isEmpty || currentUser.fechaNacimiento.isEmpty) {
      throw Exception('Tu perfil no está completo');
    }

    print(currentUser.voluntariado);
    if (currentUser.voluntariado != null && currentUser.voluntariado != '') {
      throw Exception('Ya estás postulado a un voluntariado');
    }

    final volunteering = await volunteeringsService.getVolunteeringById(volunteeringId);
    if (volunteering == null || volunteering.vacantes <= 0) {
      throw Exception('No hay vacantes disponibles');
    }

    await volunteeringsService.applyToVolunteering(currentUser.uuid, volunteeringId);
  }

  Future<void> abandonVolunteering(String volunteeringId) async {
    await volunteeringsService.abandonVolunteering(currentUser.uuid, volunteeringId);
  }

  Future<void> withdrawApplication() async {
    await volunteeringsService.withdrawApplication(currentUser.uuid);
  }

  Future<void> toggleFavorite(String volunteeringId, bool isFavorite) async {
    await volunteeringsService.toggleFavorite(
      uid: currentUser.uuid,
      volunteeringId: volunteeringId,
      isFavorite: isFavorite,
    );
  }

  Future<int> getFavoritesCount(String volunteeringId) {
    return volunteeringsService.getFavoritesCount(volunteeringId);
  }

  Future<List<Volunteering>> searchVolunteerings(VolunteeringQueryState queryState) async {
    List<Volunteering> all;

    if (queryState.sortMode == VolunteeringSortMode.proximity && queryState.userLocation != null) {
      all = await volunteeringsService.getAllVolunteeringsSorted(
        sortMode: VolunteeringSortMode.proximity,
        userLocation: queryState.userLocation,
      );
    } else {
      all = await volunteeringsService.getAllVolunteeringsSorted(sortMode: VolunteeringSortMode.date);
    }

    if (queryState.query.isEmpty) return all;

    final lowered = queryState.query.toLowerCase();
    return all.where((v) {
      return v.titulo.toLowerCase().contains(lowered) ||
          v.descripcion.toLowerCase().contains(lowered) ||
          v.resumen.toLowerCase().contains(lowered);
    }).toList();
  }

  // Transition this into state notifier!
  Future<Volunteering> getVolunteeringById(String id) async {
    final volunteering = await volunteeringsService.getVolunteeringById(id);
    if (volunteering == null) {
      throw Exception('Volunteering with id $id not found');
    }
    return volunteering;
  }

  Future<void> logLikedVolunteering(String volunteeringId, bool isLiked) async {
    await AnalyticsService.logLikedVolunteering(volunteeringId: volunteeringId, isLiked: isLiked);
  }

  Future<void> logViewedVolunteering(String volunteeringId) async {
    VolunteeringViewTracker.registerView(volunteeringId);
    await AnalyticsService.logViewedVolunteering(volunteeringId);
  }
}

// =============== DETAIL STATE NOTIFIER
final volunteeringDetailProvider =
    StateNotifierProvider.family<VolunteeringDetailNotifier, AsyncValue<Volunteering>, String>((ref, id) {
      final controller = ref.read(volunteeringsControllerProvider);
      return VolunteeringDetailNotifier(controller, id);
    });

class VolunteeringDetailNotifier extends StateNotifier<AsyncValue<Volunteering>> {
  VolunteeringDetailNotifier(this._controller, this.volunteeringId) : super(const AsyncValue.loading()) {
    fetchVolunteeringDetail();
  }

  final VolunteeringsController _controller;
  final String volunteeringId;

  Future<void> fetchVolunteeringDetail() async {
    try {
      final volunteering = await _controller.getVolunteeringById(volunteeringId);
      state = AsyncValue.data(volunteering);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ================ SEARCH
// UI
// └──> watches VolunteeringSearchProvider
//    └──> watches VolunteeringQueryProvider (holds query state) and reads the VolunteeringsControllerProvider
// UI
// └──> changes the VolunteeringQueryState through the VolunteeringQueryNotifier (i.e. by searching something)
// └──> the change is delayed due to the debouncing, after the delay the state is changed
// └──> the VolunteeringSearchProvider which was watching the Query State is activated and the controller.searchVolunteerings is finally used

// I think this should be part of the interface
enum VolunteeringSortMode { date, proximity }

final volunteeringSearchProvider = FutureProvider<List<Volunteering>>((ref) async {
  final queryState = ref.watch(volunteeringQueryProvider);
  final controller = ref.read(volunteeringsControllerProvider);
  return await controller.searchVolunteerings(queryState);
});

final volunteeringQueryProvider = StateNotifierProvider<VolunteeringQueryNotifier, VolunteeringQueryState>(
  (ref) => VolunteeringQueryNotifier(),
);

class VolunteeringQueryNotifier extends StateNotifier<VolunteeringQueryState> {
  VolunteeringQueryNotifier()
    : super(VolunteeringQueryState(query: '', sortMode: VolunteeringSortMode.date, userLocation: null));

  Timer? _debounce;

  void updateQuery(String newQuery) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      state = state.copyWith(query: newQuery.trim());
    });
  }

  void updateSortMode(VolunteeringSortMode newMode) {
    state = state.copyWith(sortMode: newMode);
  }

  void setLocation(GeoPoint location) {
    state = state.copyWith(userLocation: location);
  }

  void submitNow(String query) {
    _debounce?.cancel();
    state = state.copyWith(query: query.trim());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class VolunteeringQueryState {
  final String query;
  final VolunteeringSortMode sortMode;
  final GeoPoint? userLocation;

  VolunteeringQueryState({required this.query, required this.sortMode, this.userLocation});

  VolunteeringQueryState copyWith({String? query, VolunteeringSortMode? sortMode, GeoPoint? userLocation}) {
    return VolunteeringQueryState(
      query: query ?? this.query,
      sortMode: sortMode ?? this.sortMode,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}
