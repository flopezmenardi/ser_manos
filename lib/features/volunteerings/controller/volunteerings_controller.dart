import 'package:ser_manos/features/volunteerings/controller/volunteerings_controller_impl.dart';

import '../../../models/volunteering_model.dart';

abstract class VolunteeringsController {
  Future<void> applyToVolunteering(String volunteeringId);
  Future<void> abandonVolunteering(String volunteeringId);
  Future<void> withdrawApplication();
  Future<void> toggleFavorite(String volunteeringId, bool isFavorite);
  Future<List<Volunteering>> searchVolunteerings(VolunteeringQueryState queryState);
  Future<Volunteering> getVolunteeringById(String id);
}
