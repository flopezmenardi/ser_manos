import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/constants/app_routes.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

import '../../../core/design_system/atoms/logos/logo_square.dart';
import '../../../core/design_system/molecules/buttons/cta_button.dart';
import '../../../core/design_system/molecules/status_bar/status_bar.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/typography.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              child: SingleChildScrollView( 
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 144),
                            LogoSquare(size: 150),
                            const SizedBox(height: 32),
                            Text(
                              AppLocalizations.of(context)!.welcome,
                              style: AppTypography.headline1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 32),
                            Text(
                              AppLocalizations.of(context)!.welcomeSubtitle,
                              style: AppTypography.subtitle1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CTAButton(
                              text: AppLocalizations.of(context)!.start,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
