import 'package:flutter/material.dart';

import '../../tokens/colors.dart';

class TextOnlyButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final bool isEnabled;
  final Color? color;

  const TextOnlyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.color,
  });

  @override
  State<TextOnlyButton> createState() => _TextOnlyButtonState();
}

class _TextOnlyButtonState extends State<TextOnlyButton> {
  bool isLoading = false;

  Future<void> _handlePress() async {
    if (widget.onPressed == null) return;
    setState(() => isLoading = true);
    await widget.onPressed!();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppColors.primary100;
    return TextButton(
      onPressed: (widget.isEnabled && !isLoading) ? _handlePress : null,
      style: TextButton.styleFrom(
        foregroundColor: widget.isEnabled ? buttonColor : AppColors.neutral50,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(widget.isEnabled ? AppColors.primary100 : AppColors.neutral50),
                strokeWidth: 2,
              ),
            )
          : Text(widget.text, overflow: TextOverflow.ellipsis),
    );
  }
}
