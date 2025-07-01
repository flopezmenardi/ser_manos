import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/constants/app_assets.dart';
import 'package:ser_manos/constants/app_routes.dart';
import 'package:ser_manos/design_system/molecules/buttons/short_button.dart';
import 'package:ser_manos/design_system/organisms/modal.dart';
import 'package:ser_manos/models/user_model.dart';

import '../../../design_system/molecules/buttons/cta_button.dart';
import '../../../design_system/molecules/buttons/text_button.dart';
import '../../../design_system/molecules/components/profile_picture.dart';
import '../../../design_system/organisms/cards/information_card.dart';
import '../../../design_system/organisms/headers/header.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/grid.dart';
import '../../../design_system/tokens/typography.dart';
import '../controllers/user_controller_impl.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).currentUser;

    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: Column(
        children: [
          AppHeader(selectedIndex: 1),
          Expanded(
            child:
                user == null
                    ? const Center(child: CircularProgressIndicator())
                    : _buildProfileContent(context, ref, user),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, WidgetRef ref, User user) {
    final hasFullProfile =
        user.name.isNotEmpty && user.email.isNotEmpty && user.gender.isNotEmpty && user.phoneNumber.isNotEmpty;

    return hasFullProfile ? _buildFilledProfile(context, ref, user) : _buildEmptyProfile(context, ref, user.name);
  }

  Widget _buildFilledProfile(BuildContext context, WidgetRef ref, User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppGrid.horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          ProfilePicture(
            imagePath: user.photoUrl != null ? user.photoUrl! : AppAssets.fotoPerfil,
            size: ProfilePictureSize.large,
          ),
          const SizedBox(height: 8),
          Text(
            'VOLUNTARIO',
            style: AppTypography.overline.copyWith(color: AppColors.neutral75),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            user.name,
            style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            user.email,
            style: AppTypography.body1.copyWith(color: AppColors.secondary200),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          InformationCard(
            title: 'Información personal',
            firstLabel: 'FECHA DE NACIMIENTO',
            firstContent: user.birthDate,
            secondLabel: 'GÉNERO',
            secondContent: user.gender,
          ),
          const SizedBox(height: 16),
          InformationCard(
            title: 'Datos de contacto',
            firstLabel: 'TELÉFONO',
            firstContent: user.phoneNumber,
            secondLabel: 'E-MAIL',
            secondContent: user.email,
          ),
          const SizedBox(height: 24),
          CTAButton(text: 'Editar perfil', onPressed: () async => context.push(AppRoutes.profileEdit)),

          TextOnlyButton(
            text: 'Cerrar sesión',
            color: AppColors.error100,
            onPressed: () async {
              showDialog(
                context: context,
                builder:
                    (_) => Center(
                      child: ModalSermanos(
                        title: '¿Estás seguro que quieres cerrar sesión?',
                        confimationText: 'Cerrar sesión',
                        cancelText: 'Cancelar',
                        onCancel: () => Navigator.of(context).pop(),
                        onConfirm: () async {
                          await ref.read(authNotifierProvider.notifier).logout();
                          Navigator.of(context).pop();
                          context.go(AppRoutes.initial);
                        },
                      ),
                    ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyProfile(BuildContext context, WidgetRef ref, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppGrid.horizontalMargin),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.fotoPerfil, width: 100, height: 100, fit: BoxFit.cover),
                const SizedBox(height: 24),
                Text(
                  'VOLUNTARIO',
                  style: AppTypography.overline.copyWith(color: AppColors.neutral75),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Text(name, style: AppTypography.subtitle1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                Text(
                  '¡Completá tu perfil para tener\nacceso a mejores oportunidades!',
                  textAlign: TextAlign.center,
                  style: AppTypography.body1.copyWith(color: AppColors.neutral75),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ShortButton(text: 'Completar', icon: Icons.add, onPressed: () => context.push(AppRoutes.profileEdit)),
          const SizedBox(height: 16),
          TextOnlyButton(
            text: 'Cerrar sesión',
            color: AppColors.error100,
            onPressed: () async {
              showDialog(
                context: context,
                builder:
                    (_) => Center(
                      child: ModalSermanos(
                        title: 'Cerrar sesión',
                        subtitle: '¿Estás seguro que querés cerrar sesión?',
                        confimationText: 'Cerrar sesión',
                        cancelText: 'Cancelar',
                        onCancel: () => Navigator.of(context).pop(),
                        onConfirm: () async {
                          await ref.read(authNotifierProvider.notifier).logout();
                          Navigator.of(context).pop();
                          context.go(AppRoutes.initial);
                        },
                      ),
                    ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
