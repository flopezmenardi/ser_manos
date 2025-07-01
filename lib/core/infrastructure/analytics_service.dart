abstract class AnalyticsService {
  Future<void> logViewedVolunteering(String volunteeringId);
  Future<void> logVolunteeringApplication({required String volunteeringId, required int viewsBeforeApplying});
  Future<void> logLikedVolunteering({required String volunteeringId});
  Future<void> logWithdrawVolunteering({required String volunteeringId, required int daysBeforeStart});
}
