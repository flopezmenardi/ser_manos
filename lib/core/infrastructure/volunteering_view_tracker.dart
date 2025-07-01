import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ViewTracker {
  void registerView(String volunteeringId);
  int get viewsCount;
  void reset();
}

class VolunteeringViewTrackerImpl implements ViewTracker {
  final Set<String> _viewedVolunteeringIds = {};

  @override
  void registerView(String volunteeringId) {
    _viewedVolunteeringIds.add(volunteeringId);
  }

  @override
  int get viewsCount => _viewedVolunteeringIds.length;

  @override
  void reset() {
    _viewedVolunteeringIds.clear();
  }
}

final volunteeringViewTrackerProvider = Provider<ViewTracker>((ref) {
  return VolunteeringViewTrackerImpl();
});
