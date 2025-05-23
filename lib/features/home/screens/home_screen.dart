import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/molecules/inputs/search_input.dart';
import 'package:ser_manos/design_system/organisms/cards/volunteer_card.dart';
import 'package:ser_manos/design_system/organisms/headers/header.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
import 'package:ser_manos/design_system/organisms/cards/current_volunteer_card.dart';
import 'package:ser_manos/features/home/controller/volunteering_controller.dart';
class VolunteeringListPage extends ConsumerStatefulWidget {
  const VolunteeringListPage({super.key});

  @override
  ConsumerState<VolunteeringListPage> createState() => _VolunteeringListPageState();
}

class _VolunteeringListPageState extends ConsumerState<VolunteeringListPage> {
  int selectedIndex = 0;

  // Simulación de actividad actual
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
    final volunteeringListAsync = ref.watch(volunteeringControllerProvider);

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
                    mode: SearchInputMode.list,
                    controller: TextEditingController(),
                  ),
                  const SizedBox(height: 24),
                  if (currentVolunteer != null) ...[
                    Text(
                      "Tu actividad",
                      style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
                    ),
                    const SizedBox(height: 16),
                    CurrentVolunteerCard(
                      category: currentVolunteer!['category']!,
                      name: currentVolunteer!['name']!,
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    "Voluntariados",
                    style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
                  ),
                  const SizedBox(height: 16),
                  volunteeringListAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
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
                            style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
                          ),
                        );
                      }

                      return Column(
                        children: volunteerings.map((item) {
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