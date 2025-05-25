import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/features/home/controller/search_provider.dart';
import 'package:ser_manos/models/volunteering_model.dart';
import 'package:ser_manos/providers/auth_provider.dart';
import 'package:ser_manos/providers/firestore_provider.dart';

import '../../../services/firestore_service.dart';

/// Proveedor principal para acceder a la lista completa de voluntariados.
final volunteeringControllerProvider = FutureProvider<List<Volunteering>>((
  ref,
) async {
  final firestore = ref.watch(firestoreServiceProvider);
  return await firestore.getAllVolunteerings();
});

/// Proveedor parametrizado para acceder al detalle de un voluntariado por ID.
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

final volunteeringSearchProvider = FutureProvider<List<Volunteering>>((
  ref,
) async {
  final query = ref.watch(debouncedSearchQueryProvider);
  final firestore = ref.watch(firestoreServiceProvider);

  if (query.isEmpty) {
    return firestore.getAllVolunteerings();
  }

  final all = await firestore.getAllVolunteerings();
  final lowered = query.toLowerCase();

  return all.where((v) {
    return v.titulo.toLowerCase().contains(lowered) ||
        v.descripcion.toLowerCase().contains(lowered) ||
        v.resumen.toLowerCase().contains(lowered);
  }).toList();
});


final applyToVolunteeringProvider = Provider.family<void Function(), String>((ref, volunteeringId) {
  final firestore = ref.read(firestoreServiceProvider);
  final currentUser = ref.read(currentUserProvider)!;

  return () async {
    // Verificación de perfil completo
    if (currentUser.telefono.isEmpty || currentUser.genero.isEmpty || currentUser.fechaNacimiento.isEmpty) {
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