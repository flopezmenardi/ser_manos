import 'package:flutter/material.dart';
import '../tokens/colors.dart';

enum IconState { defaultState, enabled, disabled, white }

class AppIcons {
  static Icon getCalendarIcon({required IconState state}) {
    return Icon(Icons.calendar_today, color: _getColor(state));
  }

  static Icon getHeartIcon({required IconState state}) {
    return Icon(Icons.favorite, color: _getColor(state));
  }

  static Icon getSearchIcon({required IconState state}) {
    return Icon(Icons.search, color: _getColor(state));
  }

  static Icon getPlusIcon({required IconState state}) {
    return Icon(Icons.add, color: _getColor(state));
  }

  static Icon getBackIcon({required IconState state}) {
    return Icon(Icons.arrow_back, color: _getColor(state));
  }

  static Icon getRadioButtonIcon({required IconState state}) {
    return Icon(Icons.radio_button_checked, color: _getColor(state));
  }

  static Icon getCloseIcon({required IconState state}) {
    return Icon(Icons.close, color: _getColor(state));
  }

  static Icon getListIcon({required IconState state}) {
    return Icon(Icons.list, color: _getColor(state));
  }

  static Icon getMapIcon({required IconState state}) {
    return Icon(Icons.map, color: _getColor(state));
  }

  static Icon getNavigationIcon({required IconState state}) {
    return Icon(Icons.navigation, color: _getColor(state));
  }

  static Icon getLocationIcon({required IconState state}) {
    return Icon(Icons.location_on, color: _getColor(state));
  }


  // EXCEPTIONS

  static Icon getPersonIcon(Color color) {
    return Icon(Icons.person, color: color);
  }

  static Icon getErrorIcon(Color color) {
    return Icon(Icons.error_outline, color: color);
  }

  static Icon getAccountIcon({required Color color, double? size}) {
    return Icon(Icons.account_circle, color: color, size: size);
  }


  // PRIVATE

  static Color _getColor(IconState state) {
    switch (state) {
      case IconState.enabled:
        return AppColors.primary100;
      case IconState.disabled:
        return AppColors.neutral25;
      case IconState.defaultState:
        return AppColors.neutral50;
      case IconState.white:
        return AppColors.neutral0;
    }
  }
}