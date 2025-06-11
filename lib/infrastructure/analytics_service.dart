import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Llama cuando un usuario ve un detalle de voluntariado
  static Future<void> logViewedVolunteering(String volunteeringId) async {
    await _analytics.logEvent(
      name: 'view_volunteering',
      parameters: {
        'volunteering_id': volunteeringId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Llama cuando un usuario se postula
  static Future<void> logVolunteeringApplication({
    required String volunteeringId,
    required int viewsBeforeApplying,
  }) async {
    await _analytics.logEvent(
      name: 'apply_volunteering',
      parameters: {
        'volunteering_id': volunteeringId,
        'views_before': viewsBeforeApplying,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}