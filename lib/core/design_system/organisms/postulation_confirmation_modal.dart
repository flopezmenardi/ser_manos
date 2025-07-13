import 'package:flutter/material.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

import '../molecules/buttons/text_button.dart';
import '../tokens/colors.dart';
import '../tokens/shadow.dart';
import '../tokens/typography.dart';

class PostulationConfirmationModal extends StatelessWidget {
  final String projectName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const PostulationConfirmationModal({
    super.key,
    required this.projectName,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.neutral0,
          borderRadius: BorderRadius.circular(4),
          boxShadow: AppShadows.shadow3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                AppLocalizations.of(context)!.aboutToApplyTo,
                style: AppTypography.subtitle1.copyWith(
                  color: AppColors.neutral100,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                projectName,
                style: AppTypography.headline2.copyWith(
                  color: AppColors.neutral100,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextOnlyButton(
                  text: AppLocalizations.of(context)!.cancel,
                  onPressed: () async => onCancel(),
                ),
                TextOnlyButton(
                  text: AppLocalizations.of(context)!.confirm,
                  onPressed: () async => onConfirm(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
