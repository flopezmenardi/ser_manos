import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/volunteering_model.dart';
import 'package:ser_manos/providers/auth_provider.dart';

import '../service/volunteerings_service.dart';

/// VolunteeringSortMode & VolunteeringQueryState (NO cambian)
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

/// Notifier del estado de búsqueda (NO cambia)
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

/// Provider de búsqueda
final volunteeringQueryProvider =
    StateNotifierProvider<VolunteeringQueryNotifier, VolunteeringQueryState>(
      (ref) => VolunteeringQueryNotifier(),
    );

final volunteeringSearchProvider = FutureProvider<List<Volunteering>>((
  ref,
) async {
  final queryState = ref.watch(volunteeringQueryProvider);
  final volunteeringsService = ref.watch(volunteeringsServiceProvider);

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
});

/// Provider obtener volunteering por ID
final volunteeringByIdProvider = FutureProvider.family<Volunteering, String>((
  ref,
  id,
) async {
  final volunteeringsService = ref.watch(volunteeringsServiceProvider);
  final volunteering = await volunteeringsService.getVolunteeringById(id);
  if (volunteering == null) {
    throw Exception('Volunteering with id $id not found');
  }
  return volunteering;
});

/// Provider para aplicar a un volunteering
final applyToVolunteeringProvider =
    Provider.family<Future<void> Function(), String>((ref, volunteeringId) {
      final volunteeringsService = ref.read(volunteeringsServiceProvider);
      final currentUser = ref.read(currentUserProvider)!;

      return () async {
        if (currentUser.telefono.isEmpty ||
            currentUser.genero.isEmpty ||
            currentUser.fechaNacimiento.isEmpty) {
          throw Exception('Tu perfil no está completo');
        }

        if (currentUser.voluntariado != null &&
            currentUser.voluntariado != '') {
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
      };
    });

/// Provider para abandonar voluntariado (cuando ya estás aceptado)
final abandonVolunteeringProvider =
    Provider.family<Future<void> Function(), String>((ref, volunteeringId) {
      final volunteeringsService = ref.read(volunteeringsServiceProvider);
      final currentUser = ref.read(currentUserProvider)!;

      return () async {
        await volunteeringsService.abandonVolunteering(
          currentUser.uuid,
          volunteeringId,
        );
        ref.invalidate(currentUserProvider);
      };
    });

/// Provider para retirar postulación (cuando estás postulado pero no aceptado)
final withdrawApplicationProvider = Provider<Future<void> Function()>((ref) {
  final volunteeringsService = ref.read(volunteeringsServiceProvider);
  final currentUser = ref.read(currentUserProvider)!;

  return () async {
    await volunteeringsService.withdrawApplication(currentUser.uuid);
    ref.invalidate(currentUserProvider);
  };
});

/// Provider para toggle de favoritos
final toggleFavoriteProvider = Provider.family<
  Future<void> Function(String volunteeringId, bool isFavorite),
  String
>((ref, uid) {
  final volunteeringsService = ref.watch(volunteeringsServiceProvider);
  return (String volunteeringId, bool isFavorite) async {
    await volunteeringsService.toggleFavorite(
      uid: uid,
      volunteeringId: volunteeringId,
      isFavorite: isFavorite,
    );
    ref.invalidate(currentUserProvider);
  };
});
