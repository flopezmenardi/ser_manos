import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/core/infrastructure/analytics_service_impl.dart';
import 'package:ser_manos/core/infrastructure/volunteering_view_tracker.dart';
import 'package:ser_manos/core/models/volunteering_model.dart';
import 'package:ser_manos/features/volunteerings/controller/volunteerings_controller.dart';

import '../../../core/infrastructure/analytics_service.dart';
import '../../../core/models/enums/sort_mode.dart';
import '../../../core/models/user_model.dart';
import '../../users/controllers/user_controller_impl.dart';
import '../service/volunteerings_service.dart';
import '../service/volunteerings_service_impl.dart';

final volunteeringsControllerProvider = Provider<VolunteeringsController>((ref) {
  final volunteeringsService = ref.read(volunteeringsServiceProvider);
  final analyticsService = ref.read(analyticsServiceProvider);
  final currentUser = ref.watch(authNotifierProvider).currentUser!;
  final viewTracker = ref.read(volunteeringViewTrackerProvider);
  return VolunteeringsControllerImpl(
    volunteeringsService: volunteeringsService,
    analyticsService: analyticsService,
    currentUser: currentUser,
    viewTracker: viewTracker,
  );
});

final volunteeringStreamProvider = StreamProvider.family<Volunteering, String>((ref, id) {
  final controller = ref.read(volunteeringsControllerProvider);
  return controller.watchVolunteering(id);
});

final volunteeringSearchStreamProvider = StreamProvider<List<Volunteering>>((ref) {
  final isAuth = ref.watch(
    authNotifierProvider.select((auth) => !auth.isInitializing && auth.currentUser != null),
  );

  if (!isAuth) {
    return Stream.value([]);
  }

  final controller = ref.read(volunteeringsControllerProvider);
  final queryState = ref.watch(volunteeringQueryProvider);
  return controller.watchVolunteerings(queryState);
});

class VolunteeringsControllerImpl implements VolunteeringsController {
  final VolunteeringsService volunteeringsService;
  final AnalyticsService analyticsService;
  final User currentUser;
  final ViewTracker viewTracker;

  VolunteeringsControllerImpl({
    required this.volunteeringsService,
    required this.analyticsService,
    required this.currentUser,
    required this.viewTracker,
  });

  @override
  Future<void> applyToVolunteering(String volunteeringId) async {
    if (currentUser.phoneNumber.isEmpty || 
        currentUser.gender.isEmpty || 
        currentUser.birthDate == null || 
        currentUser.photoUrl == null) {
      throw Exception('Tu perfil no está completo');
    }

    if (currentUser.volunteering != null && currentUser.volunteering != '') {
      throw Exception('Ya estás postulado a un voluntariado');
    }

    final volunteering = await volunteeringsService.getVolunteeringById(volunteeringId);
    if (volunteering == null || volunteering.vacants <= 0) {
      throw Exception('No hay vacantes disponibles');
    }

    await volunteeringsService.applyToVolunteering(currentUser.id, volunteeringId);
  }

  @override
  Future<void> abandonVolunteering(String volunteeringId) async {
    await volunteeringsService.abandonVolunteering(currentUser.id, volunteeringId);
  }

  @override
  Future<void> withdrawApplication() async {
    await volunteeringsService.withdrawApplication(currentUser.id);
  }

  @override
  Future<void> toggleFavorite(String volunteeringId, bool isFavorite) async {
    await volunteeringsService.toggleFavorite(
      userId: currentUser.id,
      volunteeringId: volunteeringId,
      isFavorite: isFavorite,
    );
  }

  @override
  Future<int> getFavoritesCount(String volunteeringId) {
    return volunteeringsService.getFavoritesCount(volunteeringId);
  }

  @override
  Future<List<Volunteering>> searchVolunteerings(VolunteeringQueryState queryState) async {
    List<Volunteering> all;

    if (queryState.sortMode == SortMode.proximity && queryState.userLocation != null) {
      all = await volunteeringsService.getAllVolunteeringsSorted(
        sortMode: SortMode.proximity,
        userLocation: queryState.userLocation,
      );
    } else {
      all = await volunteeringsService.getAllVolunteeringsSorted(sortMode: SortMode.date);
    }

    if (queryState.query.isEmpty) return all;

    final lowered = queryState.query.toLowerCase();
    return all.where((v) {
      return v.title.toLowerCase().contains(lowered) ||
          v.description.toLowerCase().contains(lowered) ||
          v.summary.toLowerCase().contains(lowered);
    }).toList();
  }

  @override
  Future<Volunteering> getVolunteeringById(String volunteeringId) async {
    final volunteering = await volunteeringsService.getVolunteeringById(volunteeringId);
    if (volunteering == null) {
      throw Exception('Volunteering with id $volunteeringId not found');
    }
    return volunteering;
  }

  @override
  Stream<Volunteering> watchVolunteering(String id) {
    return volunteeringsService.watchVolunteeringById(id);
  }

  @override
  Future<void> logLikedVolunteering(String volunteeringId) async {
    await analyticsService.logLikedVolunteering(volunteeringId: volunteeringId);
  }

  @override
  Future<void> logViewedVolunteering(String volunteeringId) async {
    viewTracker.registerView(volunteeringId);
    await analyticsService.logViewedVolunteering(volunteeringId);
  }

  @override
  Future<void> logVolunteeringApplication(String volunteeringId) async {
    await analyticsService.logVolunteeringApplication(
      volunteeringId: volunteeringId,
      viewsBeforeApplying: viewTracker.viewsCount,
    );
    viewTracker.reset();
  }

  @override
  Stream<List<Volunteering>> watchVolunteerings(VolunteeringQueryState queryState) {
    return volunteeringsService
        .watchAllVolunteeringsSorted(sortMode: queryState.sortMode, userLocation: queryState.userLocation)
        .map((volunteerings) {
          if (queryState.query.isEmpty) return volunteerings;

          final lowered = queryState.query.toLowerCase();
          return volunteerings.where((v) {
            return v.title.toLowerCase().contains(lowered) ||
                v.description.toLowerCase().contains(lowered) ||
                v.summary.toLowerCase().contains(lowered);
          }).toList();
        });
  }
}

// =============== DETAIL STATE NOTIFIER
final volunteeringDetailProvider =
    StateNotifierProvider.family<VolunteeringDetailNotifier, AsyncValue<Volunteering>, String>((ref, id) {
      final controller = ref.read(volunteeringsControllerProvider);
      return VolunteeringDetailNotifier(controller, id);
    });

class VolunteeringDetailNotifier extends StateNotifier<AsyncValue<Volunteering>> {
  VolunteeringDetailNotifier(this._controller, this.volunteeringId) : super(const AsyncValue.loading()) {
    fetchVolunteeringDetail();
  }

  final VolunteeringsController _controller;
  final String volunteeringId;

  Future<void> fetchVolunteeringDetail() async {
    try {
      final volunteering = await _controller.getVolunteeringById(volunteeringId);
      state = AsyncValue.data(volunteering);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ================ SEARCH
// UI
// └──> watches VolunteeringSearchProvider
//    └──> watches VolunteeringQueryProvider (holds query state) and reads the VolunteeringsControllerProvider
// UI
// └──> changes the VolunteeringQueryState through the VolunteeringQueryNotifier (i.e. by searching something)
// └──> the change is delayed due to the debouncing, after the delay the state is changed
// └──> the VolunteeringSearchProvider which was watching the Query State is activated and the controller.searchVolunteerings is finally used

final volunteeringSearchProvider = AsyncNotifierProvider<VolunteeringSearchNotifier, List<Volunteering>>(() {
  return VolunteeringSearchNotifier();
});

class VolunteeringSearchNotifier extends AsyncNotifier<List<Volunteering>> {
  @override
  Future<List<Volunteering>> build() async {
    final queryState = ref.watch(volunteeringQueryProvider);
    final controller = ref.read(volunteeringsControllerProvider);
    return await controller.searchVolunteerings(queryState);
  }

  Future<void> refreshSearch() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final volunteeringQueryProvider = StateNotifierProvider<VolunteeringQueryNotifier, VolunteeringQueryState>((ref) {
  return VolunteeringQueryNotifier();
});

class VolunteeringQueryNotifier extends StateNotifier<VolunteeringQueryState> {
  VolunteeringQueryNotifier() : super(VolunteeringQueryState(query: '', sortMode: SortMode.date, userLocation: null));

  Timer? _debounce;

  void updateQuery(String newQuery) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      state = state.copyWith(query: newQuery.trim());
    });
  }

  void updateSortMode(SortMode newMode) {
    if (state.sortMode == newMode) {
      return;
    }
    state = state.copyWith(sortMode: newMode);
  }

  void setLocation(GeoPoint location) {
    final current = state.userLocation;
    if (current != null && current.latitude == location.latitude && current.longitude == location.longitude) {
      return;
    }
    state = state.copyWith(userLocation: location);
  }

  void submitNow(String query) {
    _debounce?.cancel();
    state = state.copyWith(query: query.trim());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
