import 'package:flutter/cupertino.dart';

import '../../atoms/icons.dart';
import '../../tokens/colors.dart';
import '../../tokens/shadow.dart';
import '../../tokens/typography.dart';

class CurrentVolunteerCard extends StatelessWidget {
  final String category;
  final String name;
  final VoidCallback? onLocationPressed;

  const CurrentVolunteerCard({
    super.key,
    required this.category,
    required this.name,
    this.onLocationPressed,
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
                Text(category.toUpperCase(), style: AppTypography.overline),
                Text(name, style: AppTypography.subtitle1),
              ],
            ),
          ),
          GestureDetector(
            onTap: onLocationPressed, // <-- NUEVO
            child: AppIcons.getLocationIcon(state: IconState.enabled),
          ),
        ],
      ),
    );
  }
}
