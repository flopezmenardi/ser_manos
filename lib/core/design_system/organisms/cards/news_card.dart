import 'package:flutter/material.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

import '../../molecules/buttons/text_button.dart';
import '../../tokens/colors.dart';
import '../../tokens/grid.dart';
import '../../tokens/shadow.dart';
import '../../tokens/typography.dart';

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
      width: AppGrid.screenWidth(context) - 2 * AppGrid.horizontalMargin,
      child: GestureDetector(
        onTap: onConfirm,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.neutral0,
            borderRadius: BorderRadius.circular(2),
            boxShadow: AppShadows.shadow2,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // Image section
                SizedBox(
                  width: 118,
                  child: imagePath.startsWith('assets/')
                      ? Image.asset(imagePath, fit: BoxFit.cover)
                      : Image.network(imagePath, fit: BoxFit.cover),
                ),
                // Text section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report,
                          style: AppTypography.overline.copyWith(color: AppColors.neutral75),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: AppTypography.body2.copyWith(color: AppColors.neutral75),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextOnlyButton(
                            text: AppLocalizations.of(context)!.readMore,
                            onPressed: () async {
                              onConfirm();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
