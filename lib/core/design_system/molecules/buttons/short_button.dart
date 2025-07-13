import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class ShortButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final Future<void> Function()? onPressed;
  final bool isEnabled;
  final bool isLarge;

  const ShortButton({
    super.key,
    required this.text,
    this.icon,
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
    final height = widget.isLarge ? 12.0 : 8.0;
    final bgColor = widget.isEnabled ? AppColors.primary100 : AppColors.neutral25;
    final fgColor = widget.isEnabled ? AppColors.neutral0 : AppColors.neutral50;

    return SizedBox(
      child: ElevatedButton(
        onPressed: (widget.isEnabled && !isLoading) ? _handlePress : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          padding: EdgeInsets.fromLTRB(12, height, 12, height),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral0),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 24, color: fgColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: AppTypography.button.copyWith(color: fgColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }
}
