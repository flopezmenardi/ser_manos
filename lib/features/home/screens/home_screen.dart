import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/molecules/inputs/search_input.dart';

import '../../../design_system/organisms/cards/volunteer_card.dart';
import '../../../design_system/organisms/headers/header.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';

class VolunteeringListPage extends StatefulWidget {
  const VolunteeringListPage({super.key});

  @override
  State<VolunteeringListPage> createState() => _VolunteeringListPageState();
}

class _VolunteeringListPageState extends State<VolunteeringListPage> {
  int selectedIndex = 0;

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
          HeaderSermanos(
            selectedIndex: selectedIndex,
            onTabSelected: onTabSelected,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Search bar placeholder
                SearchInput(
                  mode: SearchInputMode.map,
                  controller: TextEditingController(),
                ),
                const SizedBox(height: 24),

                // Title "Voluntariados"
                Text(
                  "Voluntariados",
                  style: AppTypography.headline1.copyWith(
                    color: AppColors.neutral100,
                  ),
                ),
                const SizedBox(height: 16),

                // Static list of VolunteeringCards
                VolunteeringCard(
                  imagePath: 'assets/images/home1.jpg',
                  category: 'Acción Social',
                  title: 'Un Techo para mi País',
                  vacancies: 10,
                  onFavoritePressed: () {},
                  onLocationPressed: () {},
                ),
                const SizedBox(height: 16),
                VolunteeringCard(
                  imagePath: 'assets/images/home2.jpg',
                  category: 'Acción Social',
                  title: 'Manos caritativas',
                  vacancies: 10,
                  onFavoritePressed: () {},
                  onLocationPressed: () {},
                ),
                const SizedBox(height: 16),
                VolunteeringCard(
                  imagePath: 'assets/images/volunteering.jpg',
                  category: 'Acción Social',
                  title: 'Apoyo Escolar',
                  vacancies: 10,
                  onFavoritePressed: () {},
                  onLocationPressed: () {},
                ),
                const SizedBox(height: 16),
                VolunteeringCard(
                  imagePath: 'assets/images/volunteering.jpg',
                  category: 'Acción Social',
                  title: 'Recolección de ropa',
                  vacancies: 10,
                  onFavoritePressed: () {},
                  onLocationPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
