import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class CTAButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final bool isEnabled;

  const CTAButton({super.key, required this.text, required this.onPressed, this.isEnabled = true});

  @override
  State<CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<CTAButton> {
  bool isLoading = false;

  Future<void> _handlePress() async {
    if (widget.onPressed == null || !mounted) return;

    setState(() => isLoading = true);

    try {
      await widget.onPressed!();
    } finally {
      // Check if widget is still mounted before calling setState
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: (widget.isEnabled && !isLoading) ? _handlePress : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isEnabled ? AppColors.primary100 : AppColors.neutral25,
          foregroundColor: widget.isEnabled ? AppColors.neutral0 : AppColors.neutral50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral50),
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  widget.text,
                  style: AppTypography.button.copyWith(
                    color: widget.isEnabled ? AppColors.neutral0 : AppColors.neutral50,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
      ),
    );
  }
}
