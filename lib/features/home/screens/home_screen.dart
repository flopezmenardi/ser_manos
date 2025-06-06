import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/providers/firestore_provider.dart';

import '../../../design_system/molecules/inputs/search_input.dart';
import '../../../design_system/organisms/cards/current_volunteer_card.dart';
import '../../../design_system/organisms/cards/volunteer_card.dart';
import '../../../design_system/organisms/headers/header.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';
import '../../../providers/auth_provider.dart';
import '../controller/volunteering_controller.dart';

class VolunteeringListPage extends ConsumerStatefulWidget {
  const VolunteeringListPage({super.key});

  @override
  ConsumerState<VolunteeringListPage> createState() =>
      _VolunteeringListPageState();
}

class _VolunteeringListPageState extends ConsumerState<VolunteeringListPage> {
  int selectedIndex = 0;
  late Set<String> localFavorites;

  @override
  void initState() {
    super.initState();
    localFavorites = {};
  }

  @override
  Widget build(BuildContext context) {
    final volunteeringListAsync = ref.watch(volunteeringSearchProvider);
    final queryNotifier = ref.read(volunteeringQueryProvider.notifier);
    final queryState = ref.watch(volunteeringQueryProvider);
    final user = ref.watch(currentUserProvider);

    // Sync favoritos en cada build si cambia user
    if (user != null) {
      localFavorites = Set.from(user.favoritos);
    }

    return Scaffold(
      backgroundColor: AppColors.secondary10,
      body: Column(
        children: [
          AppHeader(selectedIndex: selectedIndex),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.refresh(volunteeringSearchProvider.future);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SearchInput(
                      onChanged: (text) => queryNotifier.updateQuery(text),
                      onSubmitted: (text) => queryNotifier.submitNow(text),
                      mode: SearchInputMode.map,
                    ),
                    const SizedBox(height: 8),
                    // PROXIMITY BUTTON FOR NOW
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary100,
                          foregroundColor: Colors.white,
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.my_location),
                        label: Text(
                          queryState.sortMode == VolunteeringSortMode.proximity
                              ? "Ordenar por fecha"
                              : "Ordenar por cercanía",
                        ),
                        onPressed: () async {
                          if (queryState.sortMode ==
                              VolunteeringSortMode.proximity) {
                            queryNotifier.updateSortMode(
                              VolunteeringSortMode.date,
                            );
                          } else {
                            LocationPermission permission =
                                await Geolocator.checkPermission();
                            if (permission == LocationPermission.denied) {
                              permission = await Geolocator.requestPermission();
                              if (permission == LocationPermission.denied) {
                                // Show message: permission denied
                                return;
                              }
                            }

                            if (permission ==
                                LocationPermission.deniedForever) {
                              // Show message: permission permanently denied
                              return;
                            }

                            final position =
                                await Geolocator.getCurrentPosition();
                            queryNotifier.setLocation(
                              GeoPoint(position.latitude, position.longitude),
                            );
                            queryNotifier.updateSortMode(
                              VolunteeringSortMode.proximity,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    volunteeringListAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (volunteerings) {
                        if (user != null &&
                            user.voluntariado != null &&
                            user.voluntariado != '' &&
                            volunteerings.any(
                              (v) => v.id == user.voluntariado,
                            )) {
                          final current = volunteerings.firstWhere(
                            (v) => v.id == user.voluntariado,
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tu actividad",
                                style: AppTypography.headline1.copyWith(
                                  color: AppColors.neutral100,
                                ),
                              ),
                              const SizedBox(height: 16),
                              CurrentVolunteerCard(
                                category: current.emisor,
                                name: current.titulo,
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Text(
                      "Voluntariados",
                      style: AppTypography.headline1.copyWith(
                        color: AppColors.neutral100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    volunteeringListAsync.when(
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Text('Error: $error'),
                      data: (volunteerings) {
                        if (volunteerings.isEmpty) {
                          return _emptyVolunteeringsMessage();
                        }

                        return Column(
                          children:
                              volunteerings.map((item) {
                                final isFavorite = localFavorites.contains(
                                  item.id,
                                );

                                return Column(
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        context.go('/volunteering/${item.id}');
                                      },
                                      child: VolunteeringCard(
                                        imagePath: item.imagenURL,
                                        category: item.emisor,
                                        title: item.titulo,
                                        vacancies: item.vacantes,
                                        isFavorite: isFavorite,
                                        onFavoritePressed: () async {
                                          if (user == null) return;

                                          final firestore = ref.read(
                                            firestoreServiceProvider,
                                          );
                                          final refreshUser = ref.read(
                                            refreshUserProvider,
                                          );

                                          await firestore.toggleFavorite(
                                            uid: user.uuid,
                                            volunteeringId: item.id,
                                            isFavorite: isFavorite,
                                          );

                                          // Local update for UI response
                                          setState(() {
                                            if (isFavorite) {
                                              localFavorites.remove(item.id);
                                            } else {
                                              localFavorites.add(item.id);
                                            }
                                          });

                                          // Refresh for full user update
                                          await refreshUser();
                                        },
                                        onLocationPressed: () {},
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyVolunteeringsMessage() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Actualmente no hay voluntariados vigentes.\nPronto se irán incorporando nuevos.",
        textAlign: TextAlign.center,
        style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
      ),
    );
  }
}
