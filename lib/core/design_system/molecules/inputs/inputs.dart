import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../atoms/error_icon.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool isEnabled;
  final bool hasError;
  final String? supportingText;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final VoidCallback? onFieldSubmitted;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;

  const AppInput({
    super.key,
    required this.label,
    this.placeholder,
    this.isEnabled = true,
    this.hasError = false,
    this.supportingText,
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text, 
    this.onChanged,                         
    this.inputFormatters,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final fillColor = isEnabled ? Colors.white : AppColors.neutral10;
    final baseBorderColor = hasError
        ? AppColors.error100
        : isEnabled
            ? AppColors.neutral50
            : AppColors.neutral25;

    final effectiveSuffixIcon =
        hasError ? ErrorIcon.get(style: ErrorIconStyle.outlined, state: ErrorIconState.defaultState) : suffixIcon;

    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: isEnabled,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      onChanged: onChanged, 
      keyboardType: keyboardType, 
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted != null ? (_) => onFieldSubmitted!() : null,
      focusNode: focusNode,
      style: AppTypography.body1.copyWith(
        color: isEnabled ? AppColors.neutral100 : AppColors.neutral50,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        errorText: hasError ? supportingText : null,
        errorMaxLines: 2,
        filled: true,
        fillColor: fillColor,
        suffixIcon: effectiveSuffixIcon,
        labelStyle: AppTypography.body2.copyWith(
          color: hasError
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
        errorStyle: AppTypography.caption.copyWith(
          color: AppColors.error100,
          overflow: TextOverflow.visible, 
        ),
      ),
    );
  }
}