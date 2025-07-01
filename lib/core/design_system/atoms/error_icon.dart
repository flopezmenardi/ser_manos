import 'package:flutter/material.dart';
import '../tokens/colors.dart';

enum ErrorIconStyle {
  filled,
  outlined,
  thin,
}

enum ErrorIconState {
  defaultState,
  disabled,
  error,
}

class ErrorIcon {
  static Icon get({
    required ErrorIconStyle style,
    required ErrorIconState state,
  }) {
    final color = _getColor(state);
    final icon = _getIcon(style);
    return Icon(icon, color: color);
  }

  static Color _getColor(ErrorIconState state) {
    switch (state) {
      case ErrorIconState.disabled:
        return AppColors.neutral75;
      case ErrorIconState.error:
        return AppColors.neutral25;
      case ErrorIconState.defaultState:
        return AppColors.error100;
    }
  }

  static IconData _getIcon(ErrorIconStyle style) {
    switch (style) {
      case ErrorIconStyle.filled:
        return Icons.error;
      case ErrorIconStyle.outlined:
        return Icons.error_outline;
      case ErrorIconStyle.thin:
        return Icons.report_gmailerrorred;
    }
  }
}
