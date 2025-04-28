import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/molecules/buttons/cta_button.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';
import 'package:ser_manos/design_system/organisms/headers/header_section.dart'; // Your HeaderSectionSermanos

class NewsDetailsScreen extends StatelessWidget {
  // Later these will come from API
  final String reportNumber = "2820";
  final String newsTitle = "Ser donante voluntario";
  final String imageUrl = "assets/images/novedades.jpg"; // TEMPORARY, use NetworkImage later if needed
  final String subtitle =
      "Desde el Hospital Centenario recalcan la importancia de la donación voluntaria de Sangre";
  final String body =
      "En un esfuerzo por concienciar sobre la necesidad constante de sangre y sus componentes, el Hospital Centenario destaca la importancia de convertirse en un donante voluntario. La donación de sangre es un acto solidario y altruista que puede salvar vidas y mejorar la salud de aquellos que enfrentan enfermedades graves o accidentes.\n\n"
      "La donación voluntaria de sangre desempeña un papel vital en el sistema de salud. A diferencia de la donación de sangre por reposición, donde se solicita a familiares y amigos donar para un paciente específico, la donación voluntaria se realiza sin ninguna conexión directa con un receptor particular. Esto garantiza un suministro constante y seguro de sangre y productos sanguíneos para todos aquellos que lo necesiten.\n\n"
      "Los beneficios de ser donante voluntario son numerosos. Además de la satisfacción de ayudar a quienes más lo necesitan, la donación de sangre tiene beneficios para la salud del propio donante. Al donar sangre, se realiza un chequeo médico que incluye pruebas para detectar enfermedades transmisibles, lo que puede proporcionar una evaluación temprana y ayuda en el diagnóstico de posibles problemas de salud.";

  const NewsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary10,
      body: SafeArea(
        child: Column(
          children: [
            HeaderSection(
              title: 'Novedades', // Always "Novedades" in the header
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Reporte Text
                    Text(
                      "Reporte $reportNumber",
                      style: AppTypography.overline.copyWith(
                        color: AppColors.neutral75,
                      ),
                    ),
                    // Title Text
                    Text(
                      newsTitle,
                      style: AppTypography.headline2.copyWith(
                        color: AppColors.neutral100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // News Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        imageUrl,
                        width: 328,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtitle Text
                    SizedBox(
                      width: 328,
                      height: 72,
                      child: Text(
                        subtitle,
                        style: AppTypography.subtitle1.copyWith(
                          color: AppColors.neutral100,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Body Text
                    Text(
                      body,
                      style: AppTypography.body1.copyWith(
                        color: AppColors.neutral100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // "Comparte esta nota" Title
                    Text(
                      "Comparte esta nota",
                      style: AppTypography.headline2.copyWith(
                        color: AppColors.neutral100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Share Button
                    SizedBox(
                      width: double.infinity,
                      child: CTAButton(
                        text: "Compartir",
                        onPressed: () {
                          // You can implement share functionality later
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}