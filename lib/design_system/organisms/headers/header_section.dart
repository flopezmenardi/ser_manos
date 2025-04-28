import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/atoms/icons.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const HeaderSection({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      color: AppColors.secondary90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16,
            child: GestureDetector(
              onTap: onBack,
              child: AppIcons.getBackIcon(state: IconState.disabled),
            ),
          ),
          Center(
            child: Text(
              title,
              style: AppTypography.subtitle1.copyWith(
                color: AppColors.neutral0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
