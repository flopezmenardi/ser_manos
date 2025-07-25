import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/app_routes.dart';
import '../../../core/design_system/molecules/inputs/search_input.dart';
import '../../../core/design_system/organisms/cards/current_volunteer_card.dart';
import '../../../core/design_system/organisms/cards/volunteer_card.dart';
import '../../../core/design_system/organisms/headers/header.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/typography.dart';
import '../../../core/infrastructure/remote_config_provider.dart';
import '../../../core/models/enums/sort_mode.dart';
import '../../users/controllers/user_controller_impl.dart';
import '../controller/volunteerings_controller_impl.dart';

class VolunteeringListPage extends ConsumerStatefulWidget {
  const VolunteeringListPage({super.key});

  @override
  ConsumerState<VolunteeringListPage> createState() => _VolunteeringListPageState();
}

class _VolunteeringListPageState extends ConsumerState<VolunteeringListPage> {
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    final remoteConfig = FirebaseRemoteConfig.instance;

    if (!remoteConfig.getBool('show_proximity_button')) {
      _determineSortMode();
    } else {
      // Si el botón está visible, dejamos que el usuario lo elija manualmente
      _initializing = false;
    }
  }

  Future<void> _determineSortMode() async {
    final notifier = ref.read(volunteeringQueryProvider.notifier);
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      try {
        final position = await Geolocator.getCurrentPosition();
        notifier.setLocation(GeoPoint(position.latitude, position.longitude));
        notifier.updateSortMode(SortMode.proximity);
      } catch (_) {
        notifier.updateSortMode(SortMode.date);
      }
    } else {
      notifier.updateSortMode(SortMode.date);
    }

    setState(() {
      _initializing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final controller = ref.read(volunteeringsControllerProvider);
    final volunteeringListAsync = ref.watch(volunteeringSearchStreamProvider);
    final volunteeringSearchNotifier = ref.read(volunteeringSearchProvider.notifier);
    final queryNotifier = ref.read(volunteeringQueryProvider.notifier);
    final queryState = ref.watch(volunteeringQueryProvider);
    final user = ref.watch(authNotifierProvider).currentUser;

    final remoteConfig = ref.watch(remoteConfigProvider);
    final showProximityButton = remoteConfig.getBool('show_proximity_button');
    final showLikeCounter = remoteConfig.getBool('show_like_counter');

    return Scaffold(
      backgroundColor: AppColors.secondary10,
      body: Column(
        children: [
          AppHeader(selectedIndex: 0),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await volunteeringSearchNotifier.refreshSearch();
              },
              color: AppColors.secondary100,
              backgroundColor: AppColors.secondary25,
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SearchInput(
                    onChanged: (text) => queryNotifier.updateQuery(text),
                    onSubmitted: (text) => queryNotifier.submitNow(text),
                    mode: SearchInputMode.map,
                  ),
                  const SizedBox(height: 24),

                  if (showProximityButton)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary100,
                          foregroundColor: AppColors.neutral0,
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.my_location),
                        label: Text(
                          queryState.sortMode == SortMode.proximity
                              ? AppLocalizations.of(context)!.sortByDate
                              : AppLocalizations.of(context)!.sortByProximity,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () async {
                          if (queryState.sortMode == SortMode.proximity) {
                            queryNotifier.updateSortMode(SortMode.date);
                          } else {
                            LocationPermission permission = await Geolocator.checkPermission();
                            if (permission == LocationPermission.denied) {
                              permission = await Geolocator.requestPermission();
                              if (permission == LocationPermission.denied) {
                                return;
                              }
                            }
                            if (permission == LocationPermission.deniedForever) {
                              return;
                            }

                            final position = await Geolocator.getCurrentPosition();
                            queryNotifier.setLocation(GeoPoint(position.latitude, position.longitude));
                            queryNotifier.updateSortMode(SortMode.proximity);
                          }
                        },
                      ),
                    ),

                  volunteeringListAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Text('Error: $error', overflow: TextOverflow.ellipsis),
                    data: (volunteerings) {
                      final hasCurrent =
                          user != null &&
                          user.volunteering != null &&
                          user.volunteering != '' &&
                          volunteerings.any((v) => v.id == user.volunteering);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasCurrent) ..._buildCurrentVolunteering(volunteerings, user, controller),
                          Text(
                            AppLocalizations.of(context)!.volunteerings,
                            style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          if (volunteerings.isEmpty)
                            _emptyVolunteeringsMessage(queryState.query.isEmpty)
                          else
                            ...volunteerings.map(
                              (item) => _buildVolunteeringCard(item, user, controller, showLikeCounter),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCurrentVolunteering(List volunteerings, user, controller) {
    final current = volunteerings.firstWhere((v) => v.id == user.volunteering);
    return [
      Text(
        AppLocalizations.of(context)!.yourActivity,
        style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 16),
      GestureDetector(
        onTap: () {
          controller.logViewedVolunteering(current.id);
          context.push(AppRoutes.volunteeringDetail(current.id));
        },
        child: CurrentVolunteerCard(
          category: current.creator,
          name: current.title,
          onLocationPressed: () {
            final lat = current.location.latitude;
            final lng = current.location.longitude;
            final uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
            launchUrl(uri);
          },
        ),
      ),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildVolunteeringCard(item, user, controller, showLikeCounter) {
    final isFavorite = user?.favorites.contains(item.id) ?? false;

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            controller.logViewedVolunteering(item.id);
            context.push(AppRoutes.volunteeringDetail(item.id));
          },
          child: FutureBuilder<int>(
            future: showLikeCounter ? controller.getFavoritesCount(item.id) : Future.value(0),
            builder: (context, snapshot) {
              return VolunteeringCard(
                imagePath: item.imageURL,
                category: item.creator,
                title: item.title,
                vacancies: item.vacants,
                isFavorite: isFavorite,
                onFavoritePressed: () async {
                  if (user == null) return;
                  await controller.toggleFavorite(item.id, isFavorite);
                  ref.read(authNotifierProvider.notifier).refreshUser();
                  if (!isFavorite) {
                    controller.logLikedVolunteering(item.id);
                  }
                },
                likeCount: showLikeCounter ? item.likes : 0,
                onLocationPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final lat = item.location.latitude;
                  final lng = item.location.longitude;
                  final uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('No se pudo abrir Google Maps', overflow: TextOverflow.ellipsis)),
                    );
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _emptyVolunteeringsMessage(bool isGeneralEmpty) {
    final message =
        isGeneralEmpty
            ? AppLocalizations.of(context)!.noVolunteeringsAvailable
            : AppLocalizations.of(context)!.noVolunteeringsFound;
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.neutral0, borderRadius: BorderRadius.circular(8)),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
      ),
    );
  }
}
