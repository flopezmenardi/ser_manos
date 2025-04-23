import 'package:flutter/material.dart';
import '../tokens/colors.dart';

enum PersonIconState {
  defaultState,
  enabled,
  selected,
}

class PersonIcon {
  static Icon get({required PersonIconState state}) {
    return Icon(Icons.person, color: _getColor(state));
  }

  static Color _getColor(PersonIconState state) {
    switch (state) {
      case PersonIconState.enabled:
        return AppColors.neutral75;
      case PersonIconState.selected:
        return AppColors.secondary80;
      case PersonIconState.defaultState:
        return AppColors.secondary200;
    }
  }
}
