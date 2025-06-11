import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/volunteering_model.dart';

import '../../../infrastructure/user_service.dart';
import '../../../models/user_model.dart';
import '../service/volunteerings_service_impl.dart';

final volunteeringQueryProvider =
    StateNotifierProvider<VolunteeringQueryNotifier, VolunteeringQueryState>(
      (ref) => VolunteeringQueryNotifier(),
    );

final volunteeringsControllerProvider = Provider<VolunteeringsControllerImpl>((
  ref,
) {
  final volunteeringsService = ref.read(volunteeringsServiceProvider);
  final currentUser = ref.read(authNotifierProvider).currentUser!;
  return VolunteeringsControllerImpl(
    volunteeringsService: volunteeringsService,
    currentUser: currentUser,
  );
});

class VolunteeringsControllerImpl {
  final VolunteeringsServiceImpl volunteeringsService;
  final User currentUser;

  VolunteeringsControllerImpl({
    required this.volunteeringsService,
    required this.currentUser,
  });

  Future<void> applyToVolunteering(String volunteeringId) async {
    if (currentUser.telefono.isEmpty ||
        currentUser.genero.isEmpty ||
        currentUser.fechaNacimiento.isEmpty) {
      throw Exception('Tu perfil no está completo');
    }

    if (currentUser.voluntariado != null && currentUser.voluntariado != '') {
      throw Exception('Ya estás postulado a un voluntariado');
    }

    final volunteering = await volunteeringsService.getVolunteeringById(
      volunteeringId,
    );
    if (volunteering == null || volunteering.vacantes <= 0) {
      throw Exception('No hay vacantes disponibles');
    }

    await volunteeringsService.applyToVolunteering(
      currentUser.uuid,
      volunteeringId,
    );
  }

  Future<void> abandonVolunteering(String volunteeringId) async {
    await volunteeringsService.abandonVolunteering(
      currentUser.uuid,
      volunteeringId,
    );
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

  Future<List<Volunteering>> searchVolunteerings(
    VolunteeringQueryState queryState,
  ) async {
    List<Volunteering> all;

    if (queryState.sortMode == VolunteeringSortMode.proximity &&
        queryState.userLocation != null) {
      all = await volunteeringsService.getAllVolunteeringsSorted(
        sortMode: VolunteeringSortMode.proximity,
        userLocation: queryState.userLocation,
      );
    } else {
      all = await volunteeringsService.getAllVolunteeringsSorted(
        sortMode: VolunteeringSortMode.date,
      );
    }

    if (queryState.query.isEmpty) return all;

    final lowered = queryState.query.toLowerCase();
    return all.where((v) {
      return v.titulo.toLowerCase().contains(lowered) ||
          v.descripcion.toLowerCase().contains(lowered) ||
          v.resumen.toLowerCase().contains(lowered);
    }).toList();
  }

  Future<Volunteering> getVolunteeringById(String id) async {
    final volunteering = await volunteeringsService.getVolunteeringById(id);
    if (volunteering == null) {
      throw Exception('Volunteering with id $id not found');
    }
    return volunteering;
  }
}

// ================ SEARCH
// UI
// └──> watches volunteeringSearchProvider
// └──> watches volunteeringQueryProvider (holds query state)
// └──> calls controller.searchVolunteerings(queryState)
// └──> calls service.getAllVolunteeringsSorted(sortMode, userLocation)

enum VolunteeringSortMode { date, proximity }

class VolunteeringQueryState {
  final String query;
  final VolunteeringSortMode sortMode;
  final GeoPoint? userLocation;

  VolunteeringQueryState({
    required this.query,
    required this.sortMode,
    this.userLocation,
  });

  VolunteeringQueryState copyWith({
    String? query,
    VolunteeringSortMode? sortMode,
    GeoPoint? userLocation,
  }) {
    return VolunteeringQueryState(
      query: query ?? this.query,
      sortMode: sortMode ?? this.sortMode,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}

final volunteeringSearchProvider = FutureProvider<List<Volunteering>>((
  ref,
) async {
  final queryState = ref.watch(volunteeringQueryProvider);
  final controller = ref.watch(volunteeringsControllerProvider);
  return await controller.searchVolunteerings(queryState);
});

// Get volunteering by ID provider
final volunteeringByIdProvider = FutureProvider.family<Volunteering, String>((
  ref,
  id,
) async {
  final controller = ref.watch(volunteeringsControllerProvider);
  return await controller.getVolunteeringById(id);
});

class VolunteeringQueryNotifier extends StateNotifier<VolunteeringQueryState> {
  VolunteeringQueryNotifier()
    : super(
        VolunteeringQueryState(
          query: '',
          sortMode: VolunteeringSortMode.date,
          userLocation: null,
        ),
      );

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
