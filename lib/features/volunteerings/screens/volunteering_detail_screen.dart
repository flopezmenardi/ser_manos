import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/constants/app_routes.dart';
import 'package:ser_manos/core/design_system/atoms/icons.dart';
import 'package:ser_manos/core/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/core/design_system/molecules/buttons/text_button.dart';
import 'package:ser_manos/core/design_system/molecules/components/vacants_indicator.dart';
import 'package:ser_manos/core/design_system/molecules/status_bar/status_bar.dart';
import 'package:ser_manos/core/design_system/organisms/cards/location_image_card.dart';
import 'package:ser_manos/core/design_system/organisms/modal.dart';
import 'package:ser_manos/core/design_system/tokens/colors.dart';
import 'package:ser_manos/core/design_system/tokens/grid.dart';
import 'package:ser_manos/core/design_system/tokens/typography.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';
import 'package:ser_manos/core/utils/date_utils.dart' as CustomDateUtils;
import 'package:url_launcher/url_launcher.dart';

import '../../users/controllers/user_controller_impl.dart';
import '../controller/volunteerings_controller_impl.dart';

class VolunteeringDetailScreen extends ConsumerWidget {
  final String id;

  const VolunteeringDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volunteeringAsync = ref.watch(volunteeringDetailProvider(id));
    final user = ref.watch(authNotifierProvider).currentUser;
    final controller = ref.read(volunteeringsControllerProvider);
    ref.read(volunteeringDetailProvider(id).notifier).fetchVolunteeringDetail();
    ref.read(authNotifierProvider.notifier).refreshUser();

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return volunteeringAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text('${AppLocalizations.of(context)!.errorGeneric} $error', overflow: TextOverflow.ellipsis))),
      data: (volunteering) {
        final hasVacants = volunteering.vacants > 0;
        final isSame = user.volunteering == volunteering.id;
        final hasAny = user.volunteering != null && user.volunteering != '';
        final isAccepted = user.acceptedVolunteering;
        final profileComplete = user.phoneNumber.isNotEmpty && user.gender.isNotEmpty && user.birthDate != null && user.photoUrl != null;

        Widget action;

        // CASE: already accepted
        if (isSame && isAccepted) {
          action = Column(
            children: [
              Text(AppLocalizations.of(context)!.participating, style: AppTypography.headline2.copyWith(color: AppColors.neutral100)),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.participatingDescription,
                style: AppTypography.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextOnlyButton(
                text: AppLocalizations.of(context)!.abandonVolunteering,
                onPressed: () async {
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => Center(
                              child: ModalSermanos(
                                title: AppLocalizations.of(context)!.abandonVolunteeringConfirm,
                                subtitle: volunteering.title,
                                confimationText: AppLocalizations.of(context)!.confirm,
                                cancelText: AppLocalizations.of(context)!.cancel,
                                onCancel: () => Navigator.of(context).pop(false),
                                onConfirm: () => Navigator.of(context).pop(true),
                              ),
                            ),
                      ) ??
                      false;

                  if (!confirmed) return;
                  await controller.abandonVolunteering(id);
                  await ref.read(volunteeringDetailProvider(id).notifier).fetchVolunteeringDetail();
                  await ref.read(authNotifierProvider.notifier).refreshUser();
                },
              ),
            ],
          );

          // CASE: applied but not accepted
        } else if (isSame && !isAccepted) {
          action = Column(
            children: [
              Text(AppLocalizations.of(context)!.youHaveApplied, style: AppTypography.headline2.copyWith(color: AppColors.neutral100)),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.applicationPending,
                style: AppTypography.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextOnlyButton(
                text: AppLocalizations.of(context)!.withdrawApplication,
                onPressed: () async {
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => Center(
                              child: ModalSermanos(
                                title: AppLocalizations.of(context)!.withdrawApplicationConfirm,
                                subtitle: volunteering.title,
                                confimationText: AppLocalizations.of(context)!.confirm,
                                cancelText: AppLocalizations.of(context)!.cancel,
                                onCancel: () => Navigator.of(context).pop(false),
                                onConfirm: () => Navigator.of(context).pop(true),
                              ),
                            ),
                      ) ??
                      false;

                  if (!confirmed) return;
                  await controller.withdrawApplication();
                  await ref.read(volunteeringDetailProvider(id).notifier).fetchVolunteeringDetail();
                  await ref.read(authNotifierProvider.notifier).refreshUser();
                },
              ),
            ],
          );

          // CASE: user in another volunteering
        } else if (hasAny && !isSame) {
          action = Column(
            children: [
              Text(
                AppLocalizations.of(context)!.alreadyInOtherVolunteering,
                style: AppTypography.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              TextOnlyButton(
                text: AppLocalizations.of(context)!.abandonCurrentVolunteering,
                onPressed: () async {
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder:
                            (dialogContext) => Center(
                              child: ModalSermanos(
                                title: AppLocalizations.of(context)!.abandonVolunteeringConfirm,
                                subtitle: AppLocalizations.of(context)!.actionCannotBeUndone,
                                confimationText: AppLocalizations.of(context)!.confirm,
                                cancelText: AppLocalizations.of(context)!.cancel,
                                onCancel: () => Navigator.of(dialogContext).pop(false),
                                onConfirm: () => Navigator.of(dialogContext).pop(true),
                              ),
                            ),
                      ) ??
                      false;

                  if (!confirmed) return;

                  // Now perform all async operations without needing context
                  await controller.withdrawApplication();
                  await ref.read(volunteeringDetailProvider(id).notifier).fetchVolunteeringDetail();
                  await ref.read(authNotifierProvider.notifier).refreshUser();
                },
              ),
              const SizedBox(height: 8),
              CTAButton(text: AppLocalizations.of(context)!.applyToVolunteering, isEnabled: false, onPressed: () async {}),
            ],
          );

          // CASE: no vacancies
        } else if (!hasVacants) {
          action = Column(
            children: [
              Text(AppLocalizations.of(context)!.noVacanciesAvailable, style: AppTypography.body1),
              const SizedBox(height: 16),
              CTAButton(text: AppLocalizations.of(context)!.applyToVolunteering, isEnabled: false, onPressed: () async {}),
            ],
          );

          // CASE: can apply
        } else {
          action = CTAButton(
            text: AppLocalizations.of(context)!.applyToVolunteering,
            onPressed: () async {
              final navigator = Navigator.of(context);
              final router = GoRouter.of(context);

              if (!profileComplete) {
                final goToProfile =
                    await showDialog<bool>(
                      context: navigator.context, // use captured context from navigator
                      builder:
                          (_) => Center(
                            child: ModalSermanos(
                              title: AppLocalizations.of(context)!.completeDataToApply,
                              confimationText: AppLocalizations.of(context)!.completeData,
                              cancelText: AppLocalizations.of(context)!.cancel,
                              onCancel: () => navigator.pop(false),
                              onConfirm: () => navigator.pop(true),
                            ),
                          ),
                    ) ??
                    false;

                if (goToProfile) router.go('/profile/edit?fromVolunteering=$id');
                return;
              }

              final confirmed =
                  await showDialog<bool>(
                    context: context,
                    builder:
                        (_) => Center(
                          child: ModalSermanos(
                            title: AppLocalizations.of(context)!.aboutToApply,
                            subtitle: volunteering.title,
                            confimationText: AppLocalizations.of(context)!.confirm,
                            cancelText: AppLocalizations.of(context)!.cancel,
                            onCancel: () => Navigator.of(context).pop(false),
                            onConfirm: () => Navigator.of(context).pop(true),
                          ),
                        ),
                  ) ??
                  false;

              if (!confirmed) return;

              await controller.logVolunteeringApplication(id);
              await controller.applyToVolunteering(volunteering.id);
              await ref.read(volunteeringDetailProvider(volunteering.id).notifier).fetchVolunteeringDetail();
              await ref.read(authNotifierProvider.notifier).refreshUser();
            },
          );
        }

        return Scaffold(
          backgroundColor: AppColors.neutral0,
          body: RefreshIndicator(
            onRefresh: () async {
              await ref.read(volunteeringDetailProvider(id).notifier).fetchVolunteeringDetail();
              await ref.read(authNotifierProvider.notifier).refreshUser();
            },
            color: AppColors.secondary100,
            backgroundColor: AppColors.secondary25,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusBar(variant: StatusBarVariant.detail),
                  Stack(
                    children: [
                      SizedBox(
                        width: AppGrid.screenWidth(context),
                        height: 200,
                        child: Image.network(volunteering.imageURL, fit: BoxFit.fill),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.neutral100, Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: IconButton(
                          icon: AppIcons.getBackIcon(state: IconState.white),
                          onPressed: () => context.go(AppRoutes.volunteerings),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          volunteering.creator.toUpperCase(),
                          style: AppTypography.overline.copyWith(color: AppColors.neutral75),
                        ),
                        const SizedBox(height: 4),
                        Text(volunteering.title, style: AppTypography.headline1.copyWith(color: AppColors.neutral100)),
                        const SizedBox(height: 4),
                        Text(
                          volunteering.startDate != null
                              ? '${AppLocalizations.of(context)!.startDate} ${volunteering.startDate!.toDate().day}/${volunteering.startDate!.toDate().month}/${volunteering.startDate!.toDate().year}'
                              : AppLocalizations.of(context)!.startDateNotAvailable,
                          style: AppTypography.body2.copyWith(color: AppColors.neutral50),
                        ),
                        const SizedBox(height: 8),
                        Text(volunteering.summary, style: AppTypography.body1.copyWith(color: AppColors.secondary200)),
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.aboutActivity,
                          style: AppTypography.headline2.copyWith(color: AppColors.neutral100),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          volunteering.description,
                          style: AppTypography.body1.copyWith(color: AppColors.neutral100),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);

                            final lat = volunteering.location.latitude;
                            final lng = volunteering.location.longitude;
                            final uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)!.cannotOpenGoogleMaps, overflow: TextOverflow.ellipsis),
                                ),
                              );
                            }
                          },
                          child: LocationImageCard(address: volunteering.address),
                        ),
                        const SizedBox(height: 24),
                        Text(AppLocalizations.of(context)!.requirements, style: AppTypography.headline2.copyWith(color: AppColors.neutral100)),
                        const SizedBox(height: 8),
                        MarkdownBody(
                          data: volunteering.requirements,
                          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                        ),
                        const SizedBox(height: 16),
                        VacantsIndicator(vacants: volunteering.vacants),
                        const SizedBox(height: 16),
                        
                        // Cost information
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.cost,
                              style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
                            ),
                            Text(
                              volunteering.cost != null && volunteering.cost! > 0
                                  ? CustomDateUtils.DateUtils.formatLocalizedCurrency(volunteering.cost, Localizations.localeOf(context))
                                  : AppLocalizations.of(context)!.free,
                              style: AppTypography.subtitle1.copyWith(color: AppColors.secondary200),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Creation date information
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.creationDate,
                              style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
                            ),
                            Text(
                              CustomDateUtils.DateUtils.formatLocalizedDate(volunteering.creationDate, Localizations.localeOf(context)),
                              style: AppTypography.subtitle1.copyWith(color: AppColors.secondary200),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Center(child: action),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
