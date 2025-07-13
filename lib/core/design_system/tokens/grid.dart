import 'package:flutter/material.dart';

class AppGrid {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static const double horizontalMargin = 16;
}
