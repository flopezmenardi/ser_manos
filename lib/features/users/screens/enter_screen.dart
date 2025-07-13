import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

import '../../../constants/app_routes.dart';
import '../../../core/design_system/atoms/logos/logo_square.dart';
import '../../../core/design_system/molecules/buttons/cta_button.dart';
import '../../../core/design_system/molecules/buttons/text_button.dart';
import '../../../core/design_system/molecules/status_bar/status_bar.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/typography.dart'; // Adjust path if needed

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: Column(
        children: [
          const StatusBar(variant: StatusBarVariant.form),
          Expanded(
            child: SafeArea(
              top: false,
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
                          text: AppLocalizations.of(context)!.login,
                          onPressed: () async {
                            context.push(AppRoutes.login);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextOnlyButton(
                          text: AppLocalizations.of(context)!.register,
                          onPressed: () async {
                            context.push(AppRoutes.register);
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
