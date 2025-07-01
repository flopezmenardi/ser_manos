import 'package:flutter/material.dart';
import 'package:ser_manos/constants/app_assets.dart';

class LogoRectangle extends StatelessWidget {
  final double? height;
  final double? width;

  const LogoRectangle({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoRectangle,
      height: height,
      width: width,
    );
  }
}