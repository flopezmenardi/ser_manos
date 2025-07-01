// design_system/molecules/components/profile_picture.dart
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:ser_manos/constants/app_assets.dart';

enum ProfilePictureSize { small, large }

class ProfilePicture extends StatelessWidget {
  final String imagePath;                     // asset, http url or local file
  final ProfilePictureSize size;
  final String? fallbackAsset;

  const ProfilePicture({
    super.key,
    required this.imagePath,
    required this.size,
    this.fallbackAsset,
  });

  double get _diameter => switch (size) {
        ProfilePictureSize.small => 84,
        ProfilePictureSize.large => 110,
      };

  @override
  Widget build(BuildContext context) {
    Widget img;
    if (imagePath.startsWith('http') || kIsWeb) {
      // http OR blob: on web both work with Image.network
      img = Image.network(imagePath,
          width: _diameter, height: _diameter, fit: BoxFit.cover);
    } else if (File(imagePath).existsSync()) {
      img = Image.file(File(imagePath),
          width: _diameter, height: _diameter, fit: BoxFit.cover);
    } else {
      img = Image.asset(
        fallbackAsset ?? AppAssets.profilePlaceholder,
        width: _diameter,
        height: _diameter,
        fit: BoxFit.cover,
      );
    }

    return ClipOval(child: img);
  }
}
