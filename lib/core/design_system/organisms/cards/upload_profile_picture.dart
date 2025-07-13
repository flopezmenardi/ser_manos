import 'package:flutter/material.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';
import 'package:ser_manos/core/design_system/organisms/cards/profile_picture_button.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

class UploadProfilePicture extends StatelessWidget {
  final VoidCallback onUploadPressed;

  const UploadProfilePicture({super.key, required this.onUploadPressed});

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
            AppLocalizations.of(context)!.profilePicture,
            style: AppTypography.subtitle1.copyWith(
              color: AppColors.neutral100,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          ProfilePictureButton(
            text: AppLocalizations.of(context)!.uploadPhoto,
            onPressed: () async => onUploadPressed(), // forward to _pickPhoto()
          ),
        ],
      ),
    );
  }
}
