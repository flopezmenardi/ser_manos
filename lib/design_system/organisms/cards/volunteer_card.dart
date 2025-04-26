import 'package:flutter/material.dart';

import '../../molecules/components/vacants_indicator.dart';
import '../../tokens/colors.dart';
import '../../tokens/grid.dart';
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
      width: AppGrid.screenWidth - 2 * AppGrid.horizontalMargin,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 138,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.toUpperCase(),
                            style: AppTypography.overline.copyWith(
                              color: AppColors.neutral50,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: AppTypography.subtitle1.copyWith(
                              color: AppColors.neutral100,
                              height: 1.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          VacantsIndicator(vacants: vacancies),
                        ],
                      ),
                    ),
                    // Right side
                    Expanded(
                      child: SizedBox(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: onFavoritePressed,
                                child: Icon(
                                  Icons.favorite_border,
                                  color: AppColors.primary100,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ), // manually control spacing between icons
                              GestureDetector(
                                onTap: onLocationPressed,
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.primary100,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
