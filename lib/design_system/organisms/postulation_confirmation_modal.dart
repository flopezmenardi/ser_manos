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
                'Te estas por postular a',
                style: AppTypography.subtitle1.copyWith(
                  color: AppColors.neutral100,
                ),
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
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextOnlyButton(
                  text: 'Cancelar',
                  onPressed: () async => onCancel(),
                ),
                TextOnlyButton(
                  text: 'Confirmar',
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
