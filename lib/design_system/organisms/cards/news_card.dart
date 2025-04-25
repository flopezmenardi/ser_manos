import 'package:flutter/material.dart';

import '../../molecules/buttons/text_button.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class AppGrid {
  static const double screenWidth = 360;
  static const double screenHeight = 640;
  static const double horizontalMargin = 16;
}

class NewsCard extends StatelessWidget {
  final String imagePath;
  final String report;
  final String title;
  final String description;
  final VoidCallback onConfirm;

  const NewsCard({
    super.key,
    required this.imagePath,
    required this.report,
    required this.title,
    required this.description,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppGrid.screenWidth - 2 * AppGrid.horizontalMargin,
      height: 156,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Image section
            SizedBox(
              width: 118,
              height: 156,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),

            // Text section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report,
                      style: AppTypography.headline2.copyWith(
                        color: AppColors.neutral75,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.neutral75,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextOnlySermanosButton(
                        text: 'Leer más',
                        onPressed: onConfirm,
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
