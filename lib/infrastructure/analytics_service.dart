import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Llamado cuando un usuario ve un detalle de voluntariado
  static Future<void> logViewedVolunteering(String volunteeringId) async {
    await _analytics.logEvent(
      name: 'view_volunteering',
      parameters: {
        'volunteering_id': volunteeringId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Llamado cuando un usuario se postula
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

  // Llamado cuando un usuario le da like a un voluntariado
  static Future<void> logLikedVolunteering({
    required String volunteeringId,
    required bool isLiked,
  }) async {
    await _analytics.logEvent(
      name: 'like_volunteering',
      parameters: {
        'volunteering_id': volunteeringId,
        'liked': isLiked,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  static Future<void> logWithdrawVolunteering({
    required String volunteeringId,
    required int daysBeforeStart,
  }) async {
    await _analytics.logEvent(
      name: 'withdraw_volunteering',
      parameters: {
        'volunteering_id': volunteeringId,
        'days_before_start': daysBeforeStart,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}