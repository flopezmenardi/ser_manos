import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/infrastructure/analytics_service.dart';

final firebaseAnalyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final firebaseAnalytics = ref.watch(firebaseAnalyticsProvider);
  return AnalyticsServiceImpl(firebaseAnalytics);
});

class AnalyticsServiceImpl implements AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsServiceImpl(this._analytics);

  @override
  Future<void> logViewedVolunteering(String volunteeringId) async {
    await _analytics.logEvent(
      name: 'view_volunteering',
      parameters: {'volunteering_id': volunteeringId, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  @override
  Future<void> logVolunteeringApplication({required String volunteeringId, required int viewsBeforeApplying}) async {
    await _analytics.logEvent(
      name: 'apply_volunteering',
      parameters: {
        'volunteering_id': volunteeringId,
        'views_before': viewsBeforeApplying,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<void> logLikedVolunteering({required String volunteeringId}) async {
    await _analytics.logEvent(
      name: 'like_volunteering',
      parameters: {'volunteering_id': volunteeringId, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  @override
  Future<void> logWithdrawVolunteering({required String volunteeringId, required int daysBeforeStart}) async {
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
