class VolunteeringViewTracker {
  static final Set<String> _viewedVolunteeringIds = {};

  static void registerView(String volunteeringId) {
    _viewedVolunteeringIds.add(volunteeringId);
  }

  static int get viewsCount => _viewedVolunteeringIds.length;

  static void reset() {
    _viewedVolunteeringIds.clear();
  }
}