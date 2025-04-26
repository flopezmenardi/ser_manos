import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/tokens/typography.dart';

import '../../tokens/colors.dart';
import '../../tokens/grid.dart';

class InputCard extends StatefulWidget {
  const InputCard({super.key});

  @override
  State<InputCard> createState() => _InputCardState();
}

class _InputCardState extends State<InputCard> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 152,
      width: AppGrid.screenWidth - 2 * AppGrid.horizontalMargin,
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
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary100;
          }
          return AppColors.primary100; // unselected color
        }),
      ),
      child: Row(
        children: [
          Radio<String>(
            visualDensity: const VisualDensity(vertical: -2),
            value: value,
            groupValue: selectedGender,
            onChanged: (String? newValue) {
              setState(() {
                selectedGender = newValue;
              });
            },
          ),
          Text(value, style: AppTypography.body1),
        ],
      ),
    );
  }
}
