import 'package:flutter/material.dart';

class LogoSquare extends StatelessWidget {
  final double size;

  const LogoSquare({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logos/logo_square.png',
      height: size,
      width: size,
    );
  }
}