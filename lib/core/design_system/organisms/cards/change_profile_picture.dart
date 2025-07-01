import 'package:flutter/material.dart';
import 'package:ser_manos/core/design_system/organisms/cards/profile_picture_button.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../molecules/components/profile_picture.dart';

class ChangeProfilePictureCellule extends StatelessWidget {
  final String imagePath;
  final VoidCallback onChangePressed;

  const ChangeProfilePictureCellule({
    super.key,
    required this.imagePath,
    required this.onChangePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondary25,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Left Column (expanded)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // center vertically
              children: [
                Text(
                  'Foto de perfil',
                  style: AppTypography.subtitle1.copyWith(
                    color: AppColors.neutral100,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ProfilePictureButton(
                  text: 'Cambiar foto',
                  onPressed:
                      () async => onChangePressed(), // forward to _pickPhoto()
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), // space between column and picture
          // Right Profile Picture (fixed size)
          ProfilePicture(imagePath: imagePath, size: ProfilePictureSize.small),
        ],
      ),
    );
  }
}
