import 'package:flutter/cupertino.dart';

import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class InformationCard extends StatelessWidget {
  final String title;
  final String firstLabel;
  final String firstContent;
  final String secondLabel;
  final String secondContent;

  const InformationCard({
    super.key,
    required this.title,
    required this.firstLabel,
    required this.firstContent,
    required this.secondLabel,
    required this.secondContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      height: 136,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.neutral10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Header
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondary25,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: AppTypography.subtitle1.copyWith(
                color: AppColors.neutral100,
              ),
            ),
          ),
          // Body (Gray part)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstLabel,
                  style: AppTypography.overline.copyWith(
                    color: AppColors.neutral75,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  firstContent,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.neutral100,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  secondLabel,
                  style: AppTypography.overline.copyWith(
                    color: AppColors.neutral75,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  secondContent,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.neutral100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
