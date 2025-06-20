import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/design_system/atoms/icons.dart';
import 'package:ser_manos/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/design_system/molecules/buttons/text_button.dart';
import 'package:ser_manos/design_system/molecules/components/vacants_indicator.dart';
import 'package:ser_manos/design_system/molecules/status_bar/status_bar_black.dart';
import 'package:ser_manos/design_system/organisms/cards/location_image_card.dart';
import 'package:ser_manos/design_system/organisms/modal.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/grid.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
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
      error: (error, _) => Scaffold(body: Center(child: Text('Error: $error', overflow: TextOverflow.ellipsis))),
      data: (volunteering) {
        final hasVacants = volunteering.vacantes > 0;
        final isSame = user.voluntariado == volunteering.id;
        final hasAny = user.voluntariado != null && user.voluntariado != '';
        final isAccepted = user.voluntariadoAceptado;
        final profileComplete = user.telefono.isNotEmpty && user.genero.isNotEmpty && user.fechaNacimiento.isNotEmpty;

        Widget action;

        // CASE: already accepted
        if (isSame && isAccepted) {
          action = Column(
            children: [
              Text(
                'Estás participando',
                style: AppTypography.headline2.copyWith(color: AppColors.neutral100),
              ),
              const SizedBox(height: 8),
              Text(
                'La organización confirmó que ya estás participando de este voluntariado',
                style: AppTypography.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextOnlyButton(
                text: 'Abandonar voluntariado',
                onPressed: () async {
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => Center(
                              child: ModalSermanos(
                                title: '¿Estás seguro que querés abandonar tu voluntariado?',
                                subtitle: volunteering.titulo,
                                confimationText: 'Confirmar',
                                cancelText: 'Cancelar',
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
              Text(
                'Te has postulado',
                style: AppTypography.headline2.copyWith(color: AppColors.neutral100),
              ),
              const SizedBox(height: 8),
              Text(
                'Pronto la organización se pondrá en contacto contigo y te inscribirá como participante.',
                style: AppTypography.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextOnlyButton(
                text: 'Retirar postulación',
                onPressed: () async {
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => Center(
                              child: ModalSermanos(
                                title: '¿Estás seguro que querés retirar tu postulación?',
                                subtitle: volunteering.titulo,
                                confimationText: 'Confirmar',
                                cancelText: 'Cancelar',
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
                'Ya estás participando en otro voluntariado, debes abandonarlo primero para postularte a este.',
                style: AppTypography.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextOnlyButton(
                text: 'Abandonar voluntariado actual',
                onPressed: () async {
                  final volunteeringToAbandon = await controller.getVolunteeringById(user.voluntariado!);
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => Center(
                              child: ModalSermanos(
                                title: '¿Estás seguro que querés abandonar tu voluntariado?',
                                subtitle: volunteeringToAbandon.titulo,
                                confimationText: 'Confirmar',
                                cancelText: 'Cancelar',
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
              const SizedBox(height: 8),
              CTAButton(text: 'Postularme', isEnabled: false, onPressed: () async {}),
            ],
          );

          // CASE: no vacancies
        } else if (!hasVacants) {
          action = Column(
            children: [
              Text(
                'No hay vacantes disponibles para postularse.',
                style: AppTypography.body1,
              ),
              const SizedBox(height: 16),
              CTAButton(text: 'Postularme', isEnabled: false, onPressed: () async {}),
            ],
          );

          // CASE: can apply
        } else {
          action = CTAButton(
            text: 'Postularme',
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
                              title: 'Para postularte debés primero completar tus datos.',
                              confimationText: 'Completar datos',
                              cancelText: 'Cancelar',
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
                            title: 'Te estás por postular a',
                            subtitle: volunteering.titulo,
                            confimationText: 'Confirmar',
                            cancelText: 'Cancelar',
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
                        child: Image.network(volunteering.imagenURL, fit: BoxFit.fill),
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
                          icon: AppIcons.getBackIcon(state: IconState.defaultState),
                          onPressed: () => context.go('/volunteerings'),
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
                          volunteering.emisor.toUpperCase(),
                          style: AppTypography.overline.copyWith(color: AppColors.neutral75),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          volunteering.titulo,
                          style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fecha de inicio: ${volunteering.fechaInicio.toDate().day}/${volunteering.fechaInicio.toDate().month}/${volunteering.fechaInicio.toDate().year}',
                          style: AppTypography.body2.copyWith(color: AppColors.neutral50),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          volunteering.resumen,
                          style: AppTypography.body1.copyWith(color: AppColors.secondary200),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Sobre la actividad',
                          style: AppTypography.headline2.copyWith(color: AppColors.neutral100),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          volunteering.descripcion,
                          style: AppTypography.body1.copyWith(color: AppColors.neutral100),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context); // capture BEFORE async gap

                            final query = Uri.encodeComponent(volunteering.direccion);
                            final url = 'https://www.google.com/maps/search/?api=1&query=$query';
                            final uri = Uri.parse(url);

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text('No se pudo abrir Google Maps', overflow: TextOverflow.ellipsis),
                                ),
                              );
                            }
                          },
                          child: LocationImageCard(address: volunteering.direccion),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Requisitos',
                          style: AppTypography.headline2.copyWith(color: AppColors.neutral100),
                        ),
                        const SizedBox(height: 8),
                        MarkdownBody(
                          data: volunteering.requisitos,
                          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                        ),
                        const SizedBox(height: 16),
                        VacantsIndicator(vacants: volunteering.vacantes),
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
