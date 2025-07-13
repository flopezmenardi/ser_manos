import 'package:flutter/material.dart';
import 'package:ser_manos/constants/app_assets.dart';

class LogoSquare extends StatelessWidget {
  final double size;

  const LogoSquare({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoSquare,
      height: size,
      width: size,
    );
  }
}
