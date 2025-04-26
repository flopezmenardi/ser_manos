import 'package:flutter/material.dart';
import '../../molecules/components/vacants_indicator.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class VolunteeringCard extends StatelessWidget {
  final String imagePath;
  final String category;
  final String title;
  final int vacancies;
  final VoidCallback onFavoritePressed;
  final VoidCallback onLocationPressed;

  const VolunteeringCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.title,
    required this.vacancies,
    required this.onFavoritePressed,
    required this.onLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 328,
      height: 234,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Top: Image
            SizedBox(
              width: double.infinity,
              height: 138,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            // Bottom: Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // top:8px, left/right/bottom:16px
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column constrained
                    SizedBox(
                      width: 232,
                      height: 72,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.toUpperCase(),
                            style: AppTypography.overline.copyWith(
                              color: AppColors.neutral50,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: AppTypography.subtitle1.copyWith(
                              color: AppColors.neutral100,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          // Finally your indicator
                          VacantsIndicator(vacants: vacancies),
                        ],
                      ),
                    ),
                    // Right Column (icon buttons)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              color: AppColors.primary100,
                              iconSize: 24,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: onFavoritePressed,
                            ),
                            IconButton(
                              icon: const Icon(Icons.location_on_outlined),
                              color: AppColors.primary100,
                              iconSize: 24,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: onLocationPressed,
                            ),
                          ],
                        ),
                      ],
                    ),
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