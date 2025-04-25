import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../atoms/person_icon.dart';
import '../../tokens/typography.dart';

class VacantsIndicator extends StatelessWidget {
  final int vacants;

  const VacantsIndicator({super.key, required this.vacants});

  @override
  Widget build(BuildContext context) {
    final bool hasVacants = vacants > 0;

    final Color backgroundColor = hasVacants
        ? AppColors.secondary25
        : AppColors.neutral25;

    final PersonIconState iconState = hasVacants
        ? PersonIconState.selected
        : PersonIconState.enabled;

    final Color textColor = hasVacants
        ? AppColors.secondary200
        : AppColors.neutral50;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Vacantes:',
            style: AppTypography.body2.copyWith(
              color: AppColors.neutral75,
              fontWeight: FontWeight.w500, // Or just leave default if body2 is 400 normally
            ),
          ),
          const SizedBox(width: 8),
          PersonIcon.get(state: iconState),
          const SizedBox(width: 4),
          Text(
            '$vacants',
            style: AppTypography.body2.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}