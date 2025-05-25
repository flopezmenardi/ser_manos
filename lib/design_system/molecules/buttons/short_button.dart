import 'package:flutter/material.dart';
import '../../tokens/typography.dart';
import '../../tokens/colors.dart';

class ShortButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onPressed;
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
  State<ShortButton> createState() => _ShortButtonState();
}

class _ShortButtonState extends State<ShortButton> {
  bool isLoading = false;

  Future<void> _handlePress() async {
    if (widget.onPressed == null) return;
    setState(() => isLoading = true);
    await widget.onPressed!();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isLarge ? 48 : 40,
      child: ElevatedButton(
        onPressed: (widget.isEnabled && !isLoading) ? _handlePress : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isEnabled ? AppColors.primary100 : AppColors.neutral25,
          foregroundColor: widget.isEnabled ? AppColors.neutral0 : AppColors.neutral50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral0),
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.text,
                style: AppTypography.button.copyWith(
                  color: widget.isEnabled ? AppColors.neutral0 : AppColors.neutral50,
                ),
              ),
      ),
    );
  }
}