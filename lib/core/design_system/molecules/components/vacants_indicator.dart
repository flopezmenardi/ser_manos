import 'package:flutter/material.dart';

import '../../atoms/person_icon.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class VacantsIndicator extends StatelessWidget {
  final int vacants;

  const VacantsIndicator({super.key, required this.vacants});

  @override
  Widget build(BuildContext context) {
    final bool hasVacants = vacants > 0;

    final Color backgroundColor = hasVacants ? AppColors.secondary25 : AppColors.neutral25;

    final PersonIconState iconState = hasVacants ? PersonIconState.defaultState : PersonIconState.selected;

    final Color textColor = hasVacants ? AppColors.secondary200 : AppColors.secondary80;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Vacantes:',
            style: AppTypography.body2.copyWith(color: AppColors.neutral100),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 8),
          PersonIcon.get(state: iconState),
          Text('$vacants', style: AppTypography.subtitle1.copyWith(color: textColor), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
