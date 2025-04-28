import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/atoms/icons.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/grid.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';

import '../../../design_system/molecules/buttons/cta_button.dart';
import '../../../design_system/molecules/components/vacants_indicator.dart';
import '../../../design_system/molecules/status_bar/status_bar_black.dart';
import '../../../design_system/organisms/cards/location_image_card.dart';

class VolunteeringDetailScreen extends StatelessWidget {
  const VolunteeringDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status bar
            const StatusBar(variant: StatusBarVariant.detail),

            // Image with back button overlay
            Stack(
              children: [
                SizedBox(
                  width: AppGrid.screenWidth,
                  height: 200,
                  child: Image.asset(
                    'assets/images/home1.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: AppIcons.getBackIcon(state: IconState.defaultState),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                // Optional: Add gradient shadow on top
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

            // Texts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACCIÓN SOCIAL',
                    style: AppTypography.overline.copyWith(
                      color: AppColors.neutral75,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Un Techo para mi País',
                    style: AppTypography.headline1.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'El propósito principal de "Un techo para mi país" es reducir el déficit habitacional y mejorar las condiciones de vida de las personas que no tienen acceso a una vivienda adecuada.',
                    style: AppTypography.body1.copyWith(
                      color: AppColors.secondary200,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sobre la actividad',
                    style: AppTypography.headline2.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Te necesitamos para construir las viviendas de las personas que necesitan un techo. Estas están prefabricadas en madera y deberás ayudar en carpintería, montaje, pintura y demás actividades de la construcción.',
                    style: AppTypography.body1.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // LocationImageCard
                  const LocationImageCard(
                    address: 'Echeverría 3560, Capital Federal.',
                    imagePath: 'assets/images/location.png',
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Participar del voluntariado',
                    style: AppTypography.headline2.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Requisitos:\n- Mayor de edad.\n- Poder levantar cosas pesadas.\n\nDisponibilidad:\n- Mayor de edad.\n- Poder levantar cosas pesadas.',
                    style: AppTypography.body1.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Vacants indicator
                  const VacantsIndicator(vacants: 10),

                  const SizedBox(height: 24),

                  // CTA Button
                  Center(
                    child: CTAButton(
                      text: 'Postularme',
                      onPressed: () {
                        // TODO: Handle CTA
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
  }
}
