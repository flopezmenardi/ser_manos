import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/atoms/icons.dart';
import 'package:ser_manos/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/design_system/molecules/buttons/text_button.dart';
import 'package:ser_manos/design_system/organisms/headers/header.dart';
import 'package:ser_manos/design_system/organisms/cards/information_card.dart';
import 'package:ser_manos/design_system/molecules/components/profile_picture.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/grid.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';

class ProfileScreen extends StatelessWidget {
  final String name;

  const ProfileScreen({
    super.key,
    this.name = 'Juan Perez',
  });

  Map<String, String> get _staticProfileData => const {
        'name': 'Juan Test',
        'email': 'juan@test.com',
        'birthDate': '10/10/1990',
        'phone': '+54911454454545',
        'gender': 'Hombre'
      };

  // Map<String, String> get _staticProfileData => const {
  //       'name': '',
  //       'email': '',
  //       'birthDate': '',
  //       'phone': '',
  //       'gender': ''
  //     };

  bool get _hasFullProfile {
    final d = _staticProfileData;
    return (d['name']?.isNotEmpty ?? false) &&
        (d['email']?.isNotEmpty ?? false) &&
        (d['birthDate']?.isNotEmpty ?? false) &&
        (d['gender']?.isNotEmpty ?? false) &&
        (d['phone']?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: Column(
        children: [
          AppHeader(selectedIndex: 1),
          Expanded(
            child: _hasFullProfile
                ? _buildFilledProfile(context)
                : _buildEmptyProfile(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledProfile(BuildContext context) {
    final d = _staticProfileData;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppGrid.horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const ProfilePicture(
            imagePath: 'assets/images/profile_picture.jpg',
            size: ProfilePictureSize.large,
          ),
          const SizedBox(height: 8),
          Text('VOLUNTARIO',
              style:
                  AppTypography.overline.copyWith(color: AppColors.neutral75)),
          const SizedBox(height: 4),
          Text(d['name']!,
              style:
                  AppTypography.overline.copyWith(color: AppColors.neutral100)),
          const SizedBox(height: 2),
          Text(d['email']!,
              style:
                  AppTypography.body1.copyWith(color: AppColors.secondary100)),
          const SizedBox(height: 24),
          InformationCard(
            title: 'Información personal',
            firstLabel: 'FECHA DE NACIMIENTO',
            firstContent: d['birthDate']!,
            secondLabel: 'GÉNERO',
            secondContent: d['gender']!,
          ),
          const SizedBox(height: 16),
          InformationCard(
            title: 'Datos de contacto',
            firstLabel: 'TELÉFONO',
            firstContent: d['phone']!,
            secondLabel: 'E-MAIL',
            secondContent: d['email']!,
          ),
          const SizedBox(height: 24),
          CTAButton(
            text: 'Editar perfil',
            onPressed: () => context.push('/profile/edit'),
          ),
          TextOnlyButton(
            text: 'Cerrar sesión',
            onPressed: () {
              context.go('/login');
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyProfile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppGrid.horizontalMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcons.getAccountIcon(color: AppColors.secondary90, size: 100),
          const SizedBox(height: 8),
          Text('VOLUNTARIO',
              style:
                  AppTypography.overline.copyWith(color: AppColors.neutral75)),
          const SizedBox(height: 16),
          Text(name, style: AppTypography.subtitle1),
          const SizedBox(height: 16),
          Text(
            '¡Completá tu perfil para tener acceso a mejores oportunidades!',
            textAlign: TextAlign.center,
            style: AppTypography.body1.copyWith(color: AppColors.neutral75),
          ),
          const SizedBox(height: 24),
          CTAButton(
            text: '+ Completar',
            onPressed: () => context.push('/profile/edit'),
          ),
          const SizedBox(height: 16),
          TextOnlyButton(
            text: 'Cerrar sesión',
            onPressed: () {
              // TODO: logout
            },
          ),
        ],
      ),
    );
  }
}
