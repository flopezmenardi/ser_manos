import 'package:flutter/material.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

import '../../tokens/colors.dart';
import '../../tokens/grid.dart';
import '../../tokens/typography.dart';

class LocationImageCard extends StatelessWidget {
  final String address;

  const LocationImageCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppGrid.screenWidth(context),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.neutral10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Header
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondary25,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.location,
              style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Bottom texts (NO vertical padding to avoid overflow)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.address,
                  style: AppTypography.overline.copyWith(color: AppColors.neutral75),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  address,
                  style: AppTypography.body1.copyWith(color: AppColors.neutral100),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
