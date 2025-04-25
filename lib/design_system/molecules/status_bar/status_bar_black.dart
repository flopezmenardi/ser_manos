import 'package:flutter/material.dart';

import '../../tokens/grid.dart';

enum StatusBarVariant {
  main,
  form,
  detail,
}

class StatusBar extends StatelessWidget {
  final StatusBarVariant variant;

  const StatusBar({
    super.key,
    required this.variant,
  });

  Color get _backgroundColor {
    switch (variant) {
      case StatusBarVariant.main:
        return Colors.lightBlue;
      case StatusBarVariant.form:
        return Colors.white;
      case StatusBarVariant.detail:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppGrid.screenWidth,
      height: 52,
      color: _backgroundColor,
    );
  }
}
