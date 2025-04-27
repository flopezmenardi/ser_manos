import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/design_system/molecules/buttons/text_button.dart';
import 'package:ser_manos/design_system/organisms/cards/information_card.dart';
import 'package:ser_manos/design_system/organisms/headers/header.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/grid.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';

import '../../design_system/molecules/components/profile_picture.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: Column(
        children: [
          HeaderSermanos(
            selectedIndex: 1, // "Mi Perfil" selected
            onTabSelected: (index) {
              // Handle tab changes if needed
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppGrid.horizontalMargin,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    const ProfilePicture(
                      imagePath: 'assets/images/profile_picture.jpg',
                      size: ProfilePictureSize.large,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'VOLUNTARIO',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.neutral75,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Juan Cruz Gonzalez',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.neutral100,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'mimail@mail.com',
                      style: AppTypography.body1.copyWith(
                        color: AppColors.secondary100,
                      ),
                    ),
                    const SizedBox(height: 24),
                    InformationCard(
                      title: 'Información personal',
                      firstLabel: 'FECHA DE NACIMIENTO',
                      firstContent: '10/10/1990',
                      secondLabel: 'GÉNERO',
                      secondContent: 'Hombre',
                    ),
                    const SizedBox(height: 16),
                    InformationCard(
                      title: 'Datos de contacto',
                      firstLabel: 'TELÉFONO',
                      firstContent: '+5491165863216',
                      secondLabel: 'E-MAIL',
                      secondContent: 'mimail@gmail.com',
                    ),
                    const SizedBox(height: 24),
                    CTAButton(
                      text: 'Editar perfil',
                      onPressed: () {
                        // Handle Edit Profile action
                      },
                    ),
                    TextOnlyButton(
                      text: 'Cerrar sesión',
                      onPressed: () {
                        // Handle Logout action
                      },
                    ),
                    const SizedBox(height: 24),
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
