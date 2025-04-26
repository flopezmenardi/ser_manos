import 'package:flutter/material.dart';
import '../../tokens/typography.dart';
import '../../tokens/colors.dart';
import '../../molecules/inputs/inputs.dart';
import '../../organisms/cards/input_card.dart';
import '../../organisms/cards/upload_profile_picture.dart';

class PersonalData extends StatelessWidget {
  // final TextEditingController birthDateController;

  const PersonalData({
    super.key,
    // required this.birthDateController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Title
        Text(
          'Datos de perfil',
          style: AppTypography.headline1.copyWith(
            color: AppColors.neutral100,
          ),
        ),
        const SizedBox(height: 24),

        // 2. Input: Fecha de nacimiento
        AppInput(
          label: 'Fecha de nacimiento',
          placeholder: 'DD/MM/YYYY',
          // controller: birthDateController,
        ),
        const SizedBox(height: 24),

        // 3. InputCard (already implemented)
        InputCard(),
        const SizedBox(height: 24),

        // 4. Upload profile picture
        UploadProfilePicture(onUploadPressed: () {print('Pressed upload profile picture');},),
      ],
    );
  }
}