import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/volunteering_model.dart';
import 'package:ser_manos/providers/auth_provider.dart';
import 'package:ser_manos/providers/firestore_provider.dart';


/// Proveedor principal para acceder a la lista completa de voluntariados.
final volunteeringControllerProvider = FutureProvider<List<Volunteering>>((ref) async {
  final firestore = ref.watch(firestoreServiceProvider);
  return await firestore.getAllVolunteerings();
});

/// Proveedor parametrizado para acceder al detalle de un voluntariado por ID.
final volunteeringByIdProvider = FutureProvider.family<Volunteering, String>((ref, id) async {
  final firestore = ref.watch(firestoreServiceProvider);
  final volunteering = await firestore.getVolunteeringById(id);
  if (volunteering == null) {
    throw Exception('Volunteering with id $id not found');
  }
  return volunteering;
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