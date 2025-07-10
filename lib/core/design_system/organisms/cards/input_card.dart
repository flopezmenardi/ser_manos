import 'package:flutter/material.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

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
                AppLocalizations.of(context)!.profileInformation,
                style: AppTypography.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              color: AppColors.neutral10,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildRadioOption(context, 'male', AppLocalizations.of(context)!.male),
                  _buildRadioOption(context, 'female', AppLocalizations.of(context)!.female),
                  _buildRadioOption(context, 'nonBinary', AppLocalizations.of(context)!.nonBinary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(BuildContext context, String key, String displayValue) {
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
              value: key,
              groupValue: selectedGender,
              onChanged: onGenderChanged,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                displayValue,
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
