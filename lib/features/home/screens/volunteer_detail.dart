import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/design_system/atoms/icons.dart';
import 'package:ser_manos/design_system/molecules/buttons/text_button.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/grid.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
import 'package:ser_manos/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/design_system/molecules/components/vacants_indicator.dart';
import 'package:ser_manos/design_system/molecules/status_bar/status_bar_black.dart';
import 'package:ser_manos/design_system/organisms/cards/location_image_card.dart';
import 'package:ser_manos/features/home/controller/volunteering_controller.dart';
import 'package:ser_manos/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos/providers/firestore_provider.dart';

class VolunteeringDetailScreen extends ConsumerWidget {
  final String id;

  const VolunteeringDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volunteeringAsync = ref.watch(volunteeringByIdProvider(id));
    final user = ref.watch(currentUserProvider);

    return volunteeringAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (volunteering) {
        bool hasVacants = volunteering.vacantes > 0;
        bool isSameVolunteering = user?.voluntariado == volunteering.id;
        bool hasAnyVolunteering = user?.voluntariado != null && user?.voluntariado != '';
        bool isAccepted = user!.voluntariadoAceptado;
        bool isProfileComplete = user.telefono.isNotEmpty &&
            user.genero.isNotEmpty &&
            user.fechaNacimiento.isNotEmpty;

        Widget volunteeringAction;

        if (isSameVolunteering && isAccepted) {
          volunteeringAction = Column(
            children: [
              Text('Estás participando', style: AppTypography.headline2.copyWith(color: AppColors.neutral100)),
              const SizedBox(height: 8),
              Text('La organización confirmó que ya estás participando de este voluntariado', style: AppTypography.body1),
              const SizedBox(height: 8),
              TextOnlyButton(
                text: 'Abandonar voluntariado',
                onPressed: () async {
                  await ref.read(firestoreServiceProvider).abandonVolunteering(user!.uuid, volunteering.id);
                  await ref.read(refreshUserProvider)();
                  ref.invalidate(volunteeringByIdProvider(id));
                },
              ),
            ],
          );
        } else if (isSameVolunteering && !isAccepted) {
          volunteeringAction = Column(
            children: [
              Text('Te has postulado', style: AppTypography.headline2.copyWith(color: AppColors.neutral100)),
              const SizedBox(height: 8),
              Text('Pronto la organización se pondrá en contacto contigo.', style: AppTypography.body1),
              const SizedBox(height: 8),
              TextOnlyButton(
                text: 'Retirar postulación',
                onPressed: () async {
                  await ref.read(firestoreServiceProvider).withdrawApplication(user!.uuid);
                  await ref.read(refreshUserProvider)();
                  ref.invalidate(volunteeringByIdProvider(id));
                },
              ),
            ],
          );
        } else if (hasAnyVolunteering && !isSameVolunteering) {
          volunteeringAction = Column(
            children: [
              Text('Ya estás participando en otro voluntariado.', style: AppTypography.body1),
              const SizedBox(height: 8),
              TextOnlyButton(
                text: 'Abandonar voluntariado actual',
                onPressed: () async {
                  await ref.read(firestoreServiceProvider).withdrawApplication(user!.uuid);
                  await ref.read(refreshUserProvider)();
                  ref.invalidate(volunteeringByIdProvider(id));
                },
              ),
              const SizedBox(height: 8),
              CTAButton(text: 'Postularme', isEnabled: false, onPressed: () async {}),
            ],
          );
        } else if (!hasVacants) {
          // Case 4
          volunteeringAction = Column(
            children: [
              Text('No hay vacantes disponibles para postularse.', style: AppTypography.body1),
              const SizedBox(height: 8),
              CTAButton(text: 'Postularme', isEnabled: false, onPressed: () async{}),
            ],
          );
        } else {
          // Case 1
          volunteeringAction = CTAButton(
            text: 'Postularme',
            onPressed: () async {
              if (!isProfileComplete) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completa tu perfil antes de postularte.')),
                );
                return;
              }
              await ref.read(firestoreServiceProvider).applyToVolunteering(user!.uuid, volunteering.id);
              await ref.read(refreshUserProvider)();
              ref.invalidate(volunteeringByIdProvider(id));
            },
          );
        }

        return Scaffold(
          backgroundColor: AppColors.neutral0,
          body: RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(volunteeringByIdProvider(id).future);
            },
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
                        child: Image.network(
                          volunteering.imagenURL,
                          fit: BoxFit.fill,
                        ),
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
                          // onPressed: () => context.pop(),
                          onPressed: () => context.go('/home'),
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
                        LocationImageCard(
                          address: volunteering.direccion,
                          imagePath: 'assets/images/location.png',
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Requisitos',
                          style: AppTypography.headline2.copyWith(color: AppColors.neutral100),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          volunteering.requisitos,
                          style: AppTypography.body1.copyWith(color: AppColors.neutral100),
                        ),
                        const SizedBox(height: 16),
                        VacantsIndicator(vacants: volunteering.vacantes),
                        const SizedBox(height: 24),
                        Center(child: volunteeringAction),
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