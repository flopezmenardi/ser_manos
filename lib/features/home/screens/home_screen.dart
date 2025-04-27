import 'package:flutter/material.dart';

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
      backgroundColor:
          AppColors.secondary25, // matches the light blue background
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
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                  imagePath: 'assets/images/novedades.jpg',
                  category: 'Acción Social',
                  title: 'Un Techo para mi País',
                  vacancies: 10,
                  onFavoritePressed: () {},
                  onLocationPressed: () {},
                ),
                const SizedBox(height: 16),
                VolunteeringCard(
                  imagePath: 'assets/images/novedades.jpg',
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
