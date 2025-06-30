import 'package:flutter/material.dart';
import 'package:ser_manos/constants/app_assets.dart';

class Logo extends StatelessWidget {
  final double? height;
  final double? width;

  const Logo({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoBase,
      height: height,
      width: width,
    );
  }
}