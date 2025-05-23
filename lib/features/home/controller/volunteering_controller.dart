import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/models/volunteering_model.dart';
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