import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../design_system/atoms/logos/logo_square.dart'; // <- assuming you have your LogoSquare atom
import '../../../design_system/tokens/typography.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/molecules/buttons/cta_button.dart'; // <- your green call-to-action button
import '../../../design_system/molecules/buttons/text_button.dart'; // <- your text button if customized

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24), // horizontal padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // <- NEW: Space between top and bottom
            children: [
              Column(
                children: [
                  const SizedBox(height: 144), // extra top space if needed
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
                    text: 'Iniciar sesión',
                    onPressed: () {
                      context.go('/login');
                    },
                  ),
                  const SizedBox(height: 16),
                  TextOnlyButton(
                    text: 'Registrarse',
                    onPressed: () {
                      // TODO: Navigate to register
                    },
                  ),
                  const SizedBox(height: 24), // <- distance from bottom
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}