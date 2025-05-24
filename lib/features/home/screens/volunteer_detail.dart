import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/design_system/atoms/icons.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/grid.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
import 'package:ser_manos/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/design_system/molecules/components/vacants_indicator.dart';
import 'package:ser_manos/design_system/molecules/status_bar/status_bar_black.dart';
import 'package:ser_manos/design_system/organisms/cards/location_image_card.dart';
import 'package:ser_manos/features/home/controller/volunteering_controller.dart';
import 'package:go_router/go_router.dart';

class VolunteeringDetailScreen extends ConsumerWidget {
  final String id;

  const VolunteeringDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volunteeringAsync = ref.watch(volunteeringByIdProvider(id));

    return volunteeringAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (volunteering) {
        return Scaffold(
          backgroundColor: AppColors.neutral0,
          body: SingleChildScrollView(
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
                      top: 8,
                      left: 8,
                      child: IconButton(
                        icon: AppIcons.getBackIcon(state: IconState.defaultState),
                        onPressed: () => context.pop(),
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
                        volunteering.requisitos.map((r) => '- $r').join('\n'),
                        style: AppTypography.body1.copyWith(color: AppColors.neutral100),
                      ),
                      const SizedBox(height: 16),
                      VacantsIndicator(vacants: volunteering.vacantes),
                      const SizedBox(height: 24),
                      Center(
                        child: CTAButton(
                          text: 'Postularme',
                          onPressed: () {
                            // TODO
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}