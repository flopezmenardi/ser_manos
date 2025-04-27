import 'package:flutter/material.dart';

import '../../atoms/error_icon.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool isEnabled;
  final bool hasError;
  final String? supportingText;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final bool obscureText;

  const AppInput({
    super.key,
    required this.label,
    this.placeholder,
    this.isEnabled = true,
    this.hasError = false,
    this.supportingText,
    required this.controller,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.obscureText = false,
  });

  get style => null;

  @override
  Widget build(BuildContext context) {
    final Color fillColor = isEnabled ? Colors.white : AppColors.neutral10;
    final Color baseBorderColor =
        hasError
            ? AppColors.error100
            : isEnabled
            ? AppColors.neutral50
            : AppColors.neutral25;

    // Automatically include error icon if hasError is true
    final Widget? effectiveSuffixIcon =
        hasError ? ErrorIcon.get(style: style, state: style) : suffixIcon;

    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      style: AppTypography.body1.copyWith(
        color: isEnabled ? AppColors.neutral100 : AppColors.neutral50,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        helperText: hasError ? supportingText : null,
        filled: true,
        fillColor: fillColor,
        suffixIcon: effectiveSuffixIcon,
        labelStyle: AppTypography.body2.copyWith(
          color:
              hasError
                  ? AppColors.error100
                  : isEnabled
                  ? AppColors.neutral75
                  : AppColors.neutral50,
        ),
        hintStyle: AppTypography.body1.copyWith(color: AppColors.neutral50),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: baseBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: hasError ? AppColors.error100 : AppColors.secondary200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: baseBorderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: AppColors.neutral25),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: AppColors.error100),
        ),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.error100),
      ),
    );
  }
}
