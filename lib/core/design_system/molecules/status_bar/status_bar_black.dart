import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(width: AppGrid.screenWidth(context), height: 52, color: _backgroundColor);
  }
}
