import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../molecules/buttons/short_button.dart'; 

class UploadProfilePicture extends StatelessWidget {
  final VoidCallback onUploadPressed;

  const UploadProfilePicture({
    super.key,
    required this.onUploadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.secondary25,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Foto de perfil',
            style: AppTypography.subtitle1.copyWith(
              color: AppColors.neutral100,
            ),
          ),
          ShortButton(
            text: 'Subir foto',
            isLarge: false, // height 40px
            onPressed: onUploadPressed,
          ),
        ],
      ),
    );
  }
}