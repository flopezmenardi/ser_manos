import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/molecules/buttons/text_button.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/tokens/shadow.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';

class ModalSermanos extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confimationText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ModalSermanos({
    super.key,
    required this.title,
    required this.subtitle,
    required this.confimationText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppShadows.shadow3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.headline2.copyWith(color: AppColors.neutral100),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextOnlyButton(text: cancelText, onPressed: () async => onCancel()),
              const SizedBox(width: 8),
              TextOnlyButton(text: confimationText, onPressed: () async => onConfirm()),
            ],
          ),
        ],
      ),
    );
  }
}
