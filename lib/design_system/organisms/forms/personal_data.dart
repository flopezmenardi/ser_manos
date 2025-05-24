import 'package:flutter/cupertino.dart';

import '../../molecules/inputs/inputs.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../cards/input_card.dart';
import '../cards/upload_profile_picture.dart';

class PersonalData extends StatelessWidget {
  final TextEditingController birthDateController;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const PersonalData({
    super.key,
    required this.birthDateController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datos de perfil',
          style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
        ),
        const SizedBox(height: 24),

        AppInput(
          label: 'Fecha de nacimiento',
          placeholder: 'DD/MM/YYYY',
          controller: birthDateController,
        ),
        const SizedBox(height: 24),

        InputCard(
          selectedGender: selectedGender,
          onGenderChanged: onGenderChanged,
        ),
        const SizedBox(height: 24),

        UploadProfilePicture(
          onUploadPressed: () {
            print('Pressed upload profile picture');
          },
        ),
      ],
    );
  }
}
