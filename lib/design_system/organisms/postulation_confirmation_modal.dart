import 'package:flutter/material.dart';

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
        width: 328,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.neutral0,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppShadows.shadow3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Te estas por postular a',
              style: AppTypography.subtitle1.copyWith(
                color: AppColors.neutral100,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              projectName,
              style: AppTypography.headline2.copyWith(
                color: AppColors.neutral100,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextOnlySermanosButton(text: 'Cancelar', onPressed: onCancel),
                TextOnlySermanosButton(text: 'Confirmar', onPressed: onConfirm),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
