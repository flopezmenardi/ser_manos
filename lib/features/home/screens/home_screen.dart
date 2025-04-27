import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/molecules/inputs/search_input.dart';
import 'package:ser_manos/design_system/organisms/cards/volunteer_card.dart';
import 'package:ser_manos/design_system/organisms/headers/header.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
import 'package:ser_manos/design_system/organisms/cards/current_volunteer_card.dart'; // assuming you have it here

class VolunteeringListPage extends StatefulWidget {
  const VolunteeringListPage({super.key});

  @override
  State<VolunteeringListPage> createState() => _VolunteeringListPageState();
}

class _VolunteeringListPageState extends State<VolunteeringListPage> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> volunteeringList = [
    {
      'imagePath': 'assets/images/home1.jpg',
      'category': 'Acción Social',
      'title': 'Un Techo para mi País',
      'vacancies': 10,
    },
    {
      'imagePath': 'assets/images/home2.jpg',
      'category': 'Acción Social',
      'title': 'Manos caritativas',
      'vacancies': 10,
    },
    {
      'imagePath': 'assets/images/volunteering.jpg',
      'category': 'Acción Social',
      'title': 'Apoyo Escolar',
      'vacancies': 10,
    },
    {
      'imagePath': 'assets/images/volunteering.jpg',
      'category': 'Acción Social',
      'title': 'Recolección de ropa',
      'vacancies': 10,
    },
  ];

  // simulate current user volunteer activity
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
    return Scaffold(
      backgroundColor: AppColors.secondary10,
      body: Column(
        children: [
          AppHeader(selectedIndex: selectedIndex),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Search bar
                SearchInput(
                  mode: SearchInputMode.list,
                  controller: TextEditingController(),
                ),
                const SizedBox(height: 24),

                // "Tu actividad"
                if (currentVolunteer != null) ...[
                  Text(
                    "Tu actividad",
                    style: AppTypography.headline1.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CurrentVolunteerCardSermanos(
                    category: currentVolunteer!['category']!,
                    name: currentVolunteer!['name']!,
                  ),
                  const SizedBox(height: 24),
                ],

                // "Voluntariados"
                Text(
                  "Voluntariados",
                  style: AppTypography.headline1.copyWith(
                    color: AppColors.neutral100,
                  ),
                ),
                const SizedBox(height: 16),

                // List of Volunteering Cards or Empty State
                if (volunteeringList.isEmpty)
                  Container(
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
                  )
                else
                  ...volunteeringList.map((item) {
                    return Column(
                      children: [
                        VolunteeringCard(
                          imagePath: item['imagePath'],
                          category: item['category'],
                          title: item['title'],
                          vacancies: item['vacancies'],
                          onFavoritePressed: () {},
                          onLocationPressed: () {},
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
