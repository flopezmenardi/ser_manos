import 'package:flutter/material.dart';

enum ProfilePictureSize { small, large }

class ProfilePicture extends StatelessWidget {
  final String imagePath;
  final ProfilePictureSize size;

  const ProfilePicture({
    super.key,
    required this.imagePath,
    required this.size,
  });

  double get diameter {
    switch (size) {
      case ProfilePictureSize.small:
        return 84;
      case ProfilePictureSize.large:
        return 110;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        imagePath,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
      ),
    );
  }
}
