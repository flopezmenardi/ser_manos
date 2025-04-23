import 'package:flutter/material.dart';
import '../../tokens/colors.dart';

class SermanosFloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const SermanosFloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isEnabled ? AppColors.primary10 : AppColors.neutral10;
    final iconColor = isEnabled ? AppColors.primary100 : AppColors.neutral25;

    return SizedBox(
      width: 48,
      height: 48,
      child: RawMaterialButton(
        onPressed: isEnabled ? onPressed : null,
        fillColor: bgColor,
        shape: const CircleBorder(),
        elevation: 0,
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }
}