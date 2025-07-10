import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../molecules/buttons/floating_button.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class LocationCard extends StatelessWidget {
  final String address;
  final VoidCallback? onIconPressed;

  const LocationCard({super.key, required this.address, this.onIconPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 92,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.neutral10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
              AppLocalizations.of(context)!.profileInformation,
              style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Bottom (texts + icon)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColors.neutral10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Texts
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // IconButton
                  FloatingButton(icon: Icons.location_on, onPressed: () async {}, isEnabled: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
