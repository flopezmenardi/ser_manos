import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double? height;
  final double? width;

  const Logo({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logos/logo_base.png',
      height: height,
      width: width,
    );
  }
}