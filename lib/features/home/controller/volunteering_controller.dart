import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/volunteering_model.dart';
import 'package:ser_manos/providers/auth_provider.dart';
import 'package:ser_manos/providers/firestore_provider.dart';

// Proveedor principal para acceder a la lista completa de voluntariados.
final volunteeringControllerProvider = FutureProvider<List<Volunteering>>((
  ref,
) async {
  final firestore = ref.watch(firestoreServiceProvider);
  return await firestore.getAllVolunteerings();
});

// Proveedor parametrizado para acceder al detalle de un voluntariado por ID.
final volunteeringByIdProvider = FutureProvider.family<Volunteering, String>((
  ref,
  id,
) async {
  final firestore = ref.watch(firestoreServiceProvider);
  final volunteering = await firestore.getVolunteeringById(id);
  if (volunteering == null) {
    throw Exception('Volunteering with id $id not found');
  }
  return volunteering;
});

final volunteeringSortedProvider = FutureProvider.family<
  List<Volunteering>,
  (VolunteeringSortMode, GeoPoint?)
>((ref, tuple) async {
  print("ordering");
  final (sortMode, location) = tuple;
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getAllVolunteeringsSorted(
    sortMode: sortMode,
    userLocation: location,
  );
});

final applyToVolunteeringProvider = Provider.family<void Function(), String>((
  ref,
  volunteeringId,
) {
  final firestore = ref.read(firestoreServiceProvider);
  final currentUser = ref.read(currentUserProvider)!;

  return () async {
    // Verificación de perfil completo
    if (currentUser.telefono.isEmpty ||
        currentUser.genero.isEmpty ||
        currentUser.fechaNacimiento.isEmpty) {
      throw Exception('Tu perfil no está completo');
    }

    if (currentUser.voluntariado != null || currentUser.voluntariado != '') {
      throw Exception('Ya estás postulado a un voluntariado');
    }

    final volunteering = await firestore.getVolunteeringById(volunteeringId);
    if (volunteering == null || volunteering.vacantes <= 0) {
      throw Exception('No hay vacantes disponibles');
    }

    await firestore.applyToVolunteering(currentUser.uuid, volunteeringId);
  };
});

// Holds search query, sort mode (date/proximity), and optionally the user’s location
final volunteeringQueryProvider =
    StateNotifierProvider<VolunteeringQueryNotifier, VolunteeringQueryState>((
      ref,
    ) {
      return VolunteeringQueryNotifier();
    });

// Order Criteria and Search Input data structures
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

// Manages the state which has both the sorting criteria and the text input
// Also manages the debouncing for the text input
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

// Manages both the sorting criteria and the results of the search query
final volunteeringSearchProvider = FutureProvider<List<Volunteering>>((
  ref,
) async {
  final queryState = ref.watch(volunteeringQueryProvider);
  final firestore = ref.watch(firestoreServiceProvider);

  List<Volunteering> all;

  if (queryState.sortMode == VolunteeringSortMode.proximity &&
      queryState.userLocation != null) {
    all = await firestore.getAllVolunteeringsSorted(
      sortMode: VolunteeringSortMode.proximity,
      userLocation: queryState.userLocation,
    );
  } else {
    all = await firestore.getAllVolunteeringsSorted(
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
