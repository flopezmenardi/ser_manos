import 'package:flutter/material.dart';
import '../../tokens/typography.dart';
import '../../tokens/colors.dart';

class ShortButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLarge; // true = 48px alto, false = 40px

  const ShortButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.isLarge = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isLarge ? 48 : 40,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColors.primary100 : AppColors.neutral25,
          foregroundColor: isEnabled ? AppColors.neutral0 : AppColors.neutral50,
          padding: const EdgeInsets.symmetric(horizontal: 16), // <- important
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          minimumSize: const Size(0, 0), // allow button to shrink
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // prevent extra padding
        ),
        child: Text(
          text,
          style: AppTypography.button.copyWith(
            color: isEnabled ? AppColors.neutral0 : AppColors.neutral50,
          ),
        ),
      ),
    );
  }
}