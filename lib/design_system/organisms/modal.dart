import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/molecules/buttons/text_button.dart';

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
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextOnlyButton(
                text: cancelText,
                onPressed: () async => onCancel(),
              ),
              TextOnlyButton(
                text: confimationText,
                onPressed: () async => onConfirm(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
