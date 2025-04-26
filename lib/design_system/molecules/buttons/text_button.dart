import 'package:flutter/material.dart';

import '../../tokens/colors.dart';

class TextOnlySermanosButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const TextOnlySermanosButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: isEnabled ? AppColors.primary100 : AppColors.neutral50,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(text),
    );
  }
}
