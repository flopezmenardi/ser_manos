import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Color(0x26000000), // #000000 15 %
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Color(0x4C000000), // #000000 30 %
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Color(0x26000000), // #000000 15 %
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: Color(0x4C000000), // #000000 30 %
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Color(0x4C000000), // #000000 30 %
      offset: Offset(0, 4),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x26000000), // #000000 15 %
      offset: Offset(0, 8),
      blurRadius: 12,
      spreadRadius: 6,
    ),
  ];
}