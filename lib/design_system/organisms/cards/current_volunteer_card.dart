import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/atoms/icons.dart';
import 'package:ser_manos/design_system/tokens/shadow.dart';
import 'package:ser_manos/design_system/tokens/typography.dart'; // Assuming `getMapIcon` lives here

class CurrentVolunteerCardSermanos extends StatelessWidget {
  final String category;
  final String name;

  const CurrentVolunteerCardSermanos({
    super.key,
    required this.category,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary5,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary100, width: 2),
        boxShadow: AppShadows.shadow2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.toUpperCase(),
                  style: AppTypography.overline
                ),
                Text(
                  name,
                  style: AppTypography.subtitle1
                ),
              ],
            ),
          ),
          AppIcons.getLocationIcon(state: IconState.enabled), // Your custom map icon
        ],
      ),
    );
  }
}
