import 'package:flutter/material.dart';
import '../../tokens/colors.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const FloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isEnabled ? AppColors.primary100 : AppColors.neutral25;

    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        onPressed: isEnabled ? onPressed : null,
        icon: Icon(
          icon,
          size: 24,
          color: iconColor,
        ),
        splashRadius: 24, // smaller, neater splash effect
        padding: EdgeInsets.zero, // remove default extra padding
      ),
    );
  }
}