import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../molecules/buttons/short_button.dart'; 
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
      width: 328,
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
                ),
                const SizedBox(height: 8),
                ShortButton(
                  text: 'Cambiar foto',
                  isLarge: false, // height 40
                  onPressed: () async => onChangePressed(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), // space between column and picture
          // Right Profile Picture (fixed size)
          ProfilePicture(
            imagePath: imagePath,
            size: ProfilePictureSize.small,
          ),
        ],
      ),
    );
  }
}