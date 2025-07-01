import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/constants/app_assets.dart';
import 'package:ser_manos/constants/app_routes.dart';

import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class AppHeader extends StatelessWidget {
  final int selectedIndex;

  const AppHeader({super.key, required this.selectedIndex});

  void _onTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.volunteerings);
        break;
      case 1:
        context.go(AppRoutes.profile);
        break;
      case 2:
        context.go(AppRoutes.news);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondary90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 41),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [Image.asset(AppAssets.logoRectangular, height: 25)]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTab(context, "Postularse", 0),
              _buildTab(context, "Mi perfil", 1),
              _buildTab(context, "Novedades", 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, int index) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabSelected(context, index),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary200 : AppColors.secondary100,
            border: isSelected ? const Border(bottom: BorderSide(color: AppColors.neutral25, width: 3)) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.button.copyWith(color: AppColors.neutral25),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
