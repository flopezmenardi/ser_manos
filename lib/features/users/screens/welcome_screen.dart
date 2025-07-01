import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/constants/app_routes.dart';

import '../../../core/design_system/atoms/logos/logo_square.dart';
import '../../../core/design_system/molecules/buttons/cta_button.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/typography.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 144),
                  LogoSquare(size: 150),
                  const SizedBox(height: 32),
                  Text(
                    '¡Bienvenido!',
                    style: AppTypography.headline1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Nunca subestimes tu habilidad para mejorar la vida de alguien.',
                    style: AppTypography.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  CTAButton(
                    text: 'Comenzar',
                    onPressed: () async {
                      context.go(AppRoutes.volunteerings);
                    },
                  ),
                  const SizedBox(height: 84),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
