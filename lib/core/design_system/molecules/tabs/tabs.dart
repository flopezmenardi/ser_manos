import 'package:flutter/material.dart';
import '../../tokens/typography.dart';
import '../../tokens/colors.dart';
import '../../tokens/grid.dart';

class AppTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const AppTab({
    super.key,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isActive
        ? AppColors.secondary200
        : AppColors.secondary100;

    final TextStyle textStyle = AppTypography.button.copyWith(
      color: AppColors.neutral0,
    );

    final double availableWidth = AppGrid.screenWidth(context) - 2 * AppGrid.horizontalMargin;
    final double tabWidth = availableWidth / 3;
    final double tabHeight = isActive ? 49 : 52;

    return SizedBox(
      width: tabWidth,
      height: tabHeight,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.neutral0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // no rounded edges
          ),
          textStyle: textStyle,
        ),
        child: Text(label, overflow: TextOverflow.ellipsis,),
      ),
    );
  }
}
