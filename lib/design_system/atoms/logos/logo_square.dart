import 'package:flutter/material.dart';

class LogoSquare extends StatelessWidget {
  final double? height;
  final double? width;

  const LogoSquare({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logos/logo_square.png',
      height: height,
      width: width,
    );
  }
}