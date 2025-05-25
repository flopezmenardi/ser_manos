import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../design_system/atoms/logos/logo_square.dart'; 
import '../../../design_system/tokens/typography.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/molecules/buttons/cta_button.dart'; 

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24), // horizontal padding
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
                  ),
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
                      //navigate to login screen
                      context.go('/initial');
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