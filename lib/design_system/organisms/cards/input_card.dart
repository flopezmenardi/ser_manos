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
              ),
            ),
            Container(
              color: Colors.white,
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
    return RadioTheme(
      data: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          return AppColors.primary100;
        }),
      ),
      child: Row(
        children: [
          Radio<String>(
            visualDensity: const VisualDensity(vertical: -2),
            value: value,
            groupValue: selectedGender,
            onChanged: onGenderChanged,
          ),
          Text(value, style: AppTypography.body1),
        ],
      ),
    );
  }
}
