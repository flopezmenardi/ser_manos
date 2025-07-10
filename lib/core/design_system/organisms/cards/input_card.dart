import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class InputCard extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const InputCard({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.secondary25,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Información de perfil",
                style: AppTypography.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              color: AppColors.neutral10,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildRadioOption('Hombre'),
                  _buildRadioOption('Mujer'),
                  _buildRadioOption('No binario'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    return SizedBox(
      height: 32,
      child: RadioTheme(
        data: RadioThemeData(
          fillColor: WidgetStateProperty.all(AppColors.primary100),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio<String>(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              value: value,
              groupValue: selectedGender,
              onChanged: onGenderChanged,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: AppTypography.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
