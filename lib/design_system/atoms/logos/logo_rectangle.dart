import 'package:flutter/material.dart';

class LogoRectangle extends StatelessWidget {
  final double? height;
  final double? width;

  const LogoRectangle({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logos/logo_rectangle.png',
      height: height,
      width: width,
    );
  }
}