import 'package:cloud_firestore/cloud_firestore.dart'; // for GeoPoint
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/molecules/inputs/search_input.dart';
import '../../../design_system/organisms/cards/current_volunteer_card.dart';
import '../../../design_system/organisms/cards/volunteer_card.dart';
import '../../../design_system/organisms/headers/header.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';
import '../../../services/firestore_service.dart';
import '../controller/search_provider.dart';
import '../controller/volunteering_controller.dart';
import 'package:ser_manos/providers/auth_provider.dart';

class VolunteeringListPage extends ConsumerStatefulWidget {
  const VolunteeringListPage({super.key});

  @override
  ConsumerState<VolunteeringListPage> createState() =>
      _VolunteeringListPageState();
}

class _VolunteeringListPageState extends ConsumerState<VolunteeringListPage> {
  int selectedIndex = 0;

  VolunteeringSortMode sortMode = VolunteeringSortMode.newest;
  GeoPoint? userLocation;

  final Map<String, String>? currentVolunteer = {
    'category': 'Acción Social',
    'name': 'Un Techo para mi País',
  };

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final volunteeringListAsync = ref.watch(
      volunteeringSortedProvider((sortMode, userLocation)),
    );
    final debouncedQueryNotifier = ref.read(
      debouncedSearchQueryProvider.notifier,
    );
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary10,
      body: Column(
        children: [
          AppHeader(selectedIndex: selectedIndex),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  SearchInput(
                    onChanged:
                        (text) => debouncedQueryNotifier.updateQuery(text),
                    onSubmitted:
                        (text) => debouncedQueryNotifier.submitNow(text),
                    mode: SearchInputMode.map,
                  ),
                  const SizedBox(height: 8),

                  // Toggle sort mode button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary100,
                        foregroundColor: Colors.white,
                        elevation: 2,
                      ),
                      icon: Icon(
                        sortMode == VolunteeringSortMode.closest
                            ? Icons.schedule
                            : Icons.my_location,
                      ),
                      label: Text(
                        sortMode == VolunteeringSortMode.closest
                            ? "Ordenar por nuevos"
                            : "Ordenar por cercanía",
                      ),
                      onPressed: () async {
                        if (sortMode == VolunteeringSortMode.closest) {
                          setState(() {
                            sortMode = VolunteeringSortMode.newest;
                            userLocation = null;
                          });
                        } else {
                          try {
                            final permission =
                                await Geolocator.requestPermission();
                            if (permission == LocationPermission.denied ||
                                permission ==
                                    LocationPermission.deniedForever) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Permiso de ubicación denegado',
                                  ),
                                ),
                              );
                              return;
                            }

                            final position =
                                await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high,
                                );

                            setState(() {
                              sortMode = VolunteeringSortMode.closest;
                              userLocation = GeoPoint(
                                position.latitude,
                                position.longitude,
                              );
                            });
                          } catch (e) {
                            debugPrint('Error getting location: $e');
                          }
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
                          user.voluntariado != null && user.voluntariado != '' &&
                          volunteerings.any((v) => v.id == user.voluntariado)) {
                        final current = volunteerings.firstWhere((v) => v.id == user.voluntariado);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tu actividad",
                              style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
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
                        () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Text('Error: $error'),
                    data: (volunteerings) {
                      if (volunteerings.isEmpty) {
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
                            style: AppTypography.subtitle1.copyWith(
                              color: AppColors.neutral100,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children:
                            volunteerings.map((item) {
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
                                      onFavoritePressed: () {},
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
        ],
      ),
    );
  }
}
