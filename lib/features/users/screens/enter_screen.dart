import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/constants/app_routes.dart';

import '../../../design_system/atoms/logos/logo_square.dart'; // <- assuming you have your LogoSquare atom
import '../../../design_system/molecules/buttons/cta_button.dart'; // <- your green call-to-action button
import '../../../design_system/molecules/buttons/text_button.dart'; // <- your text button if customized
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

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
                    '“El esfuerzo desinteresado para llevar alegría a los demás será el comienzo de una vida más feliz para nosotros”',
                    style: AppTypography.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  CTAButton(
                    text: 'Iniciar Sesión',
                    onPressed: () async {
                      context.go(AppRoutes.login);
                      return;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextOnlyButton(
                    text: 'Registrarse',
                    onPressed: () async {
                      context.go(AppRoutes.register);
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
