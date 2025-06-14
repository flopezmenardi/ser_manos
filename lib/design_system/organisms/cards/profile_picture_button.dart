import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/design_system/molecules/buttons/short_button.dart';


class ProfilePictureButton extends ConsumerWidget {
  final String text;
  final AsyncCallback onPressed;

  const ProfilePictureButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShortButton(
      text: text,
      isLarge: false,
      onPressed: onPressed, // default
    );
  }
}