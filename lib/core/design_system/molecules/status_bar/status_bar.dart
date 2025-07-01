import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemUiOverlayStyle

import '../../tokens/colors.dart';
import '../../tokens/grid.dart';

enum StatusBarVariant { main, form, detail }

class StatusBar extends StatelessWidget {
  final StatusBarVariant variant;

  const StatusBar({super.key, required this.variant});

  Color get _backgroundColor {
    switch (variant) {
      case StatusBarVariant.main:
        return AppColors.secondary90;
      case StatusBarVariant.form:
        return AppColors.neutral0;
      case StatusBarVariant.detail:
        return AppColors.neutral100;
    }
  }

  SystemUiOverlayStyle get _overlayStyle {
    switch (variant) {
      case StatusBarVariant.main:
      case StatusBarVariant.detail:
        return SystemUiOverlayStyle.light.copyWith(statusBarColor: _backgroundColor);
      case StatusBarVariant.form:
        return SystemUiOverlayStyle.dark.copyWith(statusBarColor: _backgroundColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Container(width: AppGrid.screenWidth(context), height: 52, color: _backgroundColor),
    );
  }
}
