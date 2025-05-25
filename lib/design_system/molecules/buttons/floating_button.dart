import 'package:flutter/material.dart';
import '../../tokens/colors.dart';

class FloatingButton extends StatefulWidget {
  final IconData icon;
  final Future<void> Function()? onPressed;
  final bool isEnabled;

  const FloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  bool isLoading = false;

  Future<void> _handlePress() async {
    if (widget.onPressed == null) return;
    setState(() => isLoading = true);
    await widget.onPressed!();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.isEnabled ? AppColors.primary100 : AppColors.neutral25;

    return SizedBox(
      width: 48,
      height: 48,
      child: isLoading
          ? Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                  strokeWidth: 2,
                ),
              ),
            )
          : IconButton(
              onPressed: (widget.isEnabled && !isLoading) ? _handlePress : null,
              icon: Icon(
                widget.icon,
                size: 24,
                color: iconColor,
              ),
              splashRadius: 24,
              padding: EdgeInsets.zero,
            ),
    );
  }
}