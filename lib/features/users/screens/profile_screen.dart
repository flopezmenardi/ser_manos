import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_routes.dart';
import '../../../core/design_system/molecules/buttons/cta_button.dart';
import '../../../core/design_system/molecules/buttons/short_button.dart';
import '../../../core/design_system/molecules/buttons/text_button.dart';
import '../../../core/design_system/molecules/components/profile_picture.dart';
import '../../../core/design_system/organisms/cards/information_card.dart';
import '../../../core/design_system/organisms/headers/header.dart';
import '../../../core/design_system/organisms/modal.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/grid.dart';
import '../../../core/design_system/tokens/typography.dart';
import '../../../core/models/user_model.dart';
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
        user.name.isNotEmpty &&
        user.email.isNotEmpty &&
        user.gender.isNotEmpty &&
        user.phoneNumber.isNotEmpty;

    return hasFullProfile
        ? _buildFilledProfile(context, ref, user)
        : _buildEmptyProfile(context, ref, user.name);
  }

  Widget _buildFilledProfile(BuildContext context, WidgetRef ref, User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppGrid.horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          ProfilePicture(
            imagePath:
                user.photoUrl != null ? user.photoUrl! : AppAssets.fotoPerfil,
            size: ProfilePictureSize.large,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.volunteer,
            style: AppTypography.overline.copyWith(color: AppColors.neutral75),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            user.name,
            style: AppTypography.subtitle1.copyWith(
              color: AppColors.neutral100,
            ),
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
            title: AppLocalizations.of(context)!.personalInformation,
            firstLabel: AppLocalizations.of(context)!.birthDateLabel,
            firstContent: user.birthDateString,
            secondLabel: AppLocalizations.of(context)!.genderLabel,
            secondContent: user.gender,
          ),
          const SizedBox(height: 16),
          InformationCard(
            title: AppLocalizations.of(context)!.contactDataLabel,
            firstLabel: AppLocalizations.of(context)!.telephoneLabel,
            firstContent: user.phoneNumber,
            secondLabel: AppLocalizations.of(context)!.emailLabel,
            secondContent: user.email,
          ),
          const SizedBox(height: 24),
          CTAButton(
            text: AppLocalizations.of(context)!.editProfile,
            onPressed: () async => context.push(AppRoutes.profileEdit),
          ),

          TextOnlyButton(
            text: AppLocalizations.of(context)!.logout,
            color: AppColors.error100,
            onPressed: () async {
              // Capture Navigator and GoRouter before showing dialog
              final navigator = Navigator.of(context);
              final goRouter = GoRouter.of(context);

              showDialog(
                context: context,
                builder:
                    (dialogContext) => Center(
                      child: ModalSermanos(
                        title: AppLocalizations.of(context)!.logoutConfirmation,
                        confimationText: AppLocalizations.of(context)!.logoutConfirmationSimple,
                        cancelText: AppLocalizations.of(context)!.cancel,
                        onCancel: () => Navigator.of(dialogContext).pop(),
                        onConfirm: () async {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .logout();
                          // Use captured navigator and goRouter instead of context
                          navigator.pop();
                          goRouter.go(AppRoutes.initial);
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
                Image.asset(
                  AppAssets.fotoPerfil,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.volunteer,
                  style: AppTypography.overline.copyWith(
                    color: AppColors.neutral75,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: AppTypography.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.completeProfile,
                  textAlign: TextAlign.center,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.neutral75,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ShortButton(
            text: AppLocalizations.of(context)!.complete,
            icon: Icons.add,
            onPressed: () => context.push(AppRoutes.profileEdit),
          ),
          const SizedBox(height: 16),
          TextOnlyButton(
            text: AppLocalizations.of(context)!.logout,
            color: AppColors.error100,
            onPressed: () async {
              // Capture Navigator and GoRouter before showing dialog
              final navigator = Navigator.of(context);
              final goRouter = GoRouter.of(context);

              showDialog(
                context: context,
                builder:
                    (dialogContext) => Center(
                      child: ModalSermanos(
                        title: AppLocalizations.of(context)!.logoutConfirmationSimple,
                        subtitle: AppLocalizations.of(context)!.logoutConfirmationQuestion,
                        confimationText: AppLocalizations.of(context)!.logoutConfirmationSimple,
                        cancelText: AppLocalizations.of(context)!.cancel,
                        onCancel: () => Navigator.of(dialogContext).pop(),
                        onConfirm: () async {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .logout();
                          // Use captured navigator and goRouter instead of context
                          navigator.pop();
                          goRouter.go(AppRoutes.initial);
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
