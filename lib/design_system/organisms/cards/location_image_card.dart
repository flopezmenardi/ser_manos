import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/tokens/grid.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class LocationImageCard extends StatelessWidget {
  final String address;
  final String imagePath;

  const LocationImageCard({
    super.key,
    required this.address,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppGrid.screenWidth(context),
      height: 247, // Stay with 247px fixed height
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
              'Información de perfil',
              style: AppTypography.subtitle1.copyWith(
                color: AppColors.neutral100,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Image
          SizedBox(
            width: double.infinity,
            height: 155,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          // Bottom texts (NO vertical padding to avoid overflow)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // ← reduced vertical padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DIRECCIÓN',
                  style: AppTypography.overline.copyWith(
                    color: AppColors.neutral75,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2), // ← smaller space between texts
                Text(
                  address,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.neutral100,
                  ),
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