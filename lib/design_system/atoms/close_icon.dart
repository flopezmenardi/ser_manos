import 'package:flutter/material.dart';
import '../tokens/colors.dart';

enum CloseIconState {
  defaultState,
  enabled,
  selected,
}

class CloseIcon {
  static Icon get({required CloseIconState state}) {
    return Icon(Icons.close, color: _getColor(state));
  }

  static Color _getColor(CloseIconState state) {
    switch (state) {
      case CloseIconState.enabled:
        return AppColors.primary100;
      case CloseIconState.selected:
        return AppColors.neutral25;
      case CloseIconState.defaultState:
        return AppColors.neutral75;
    }
  }
}
