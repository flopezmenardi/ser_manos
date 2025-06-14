// design_system/organisms/cards/profile_picture_button.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';          // ← NEW
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ser_manos/design_system/molecules/buttons/short_button.dart';
import 'package:ser_manos/features/profile/controller/profile_controller_impl.dart';
import 'package:ser_manos/infrastructure/user_service_impl.dart'; //   (for authNotifierProvider)

class ProfilePictureButton extends ConsumerWidget {
  final String text;
  final AsyncCallback? onPressed;           //  ← NEW (nullable)

  const ProfilePictureButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShortButton(
      text: text,
      isLarge: false,
      onPressed: onPressed ?? () => _showImageSourceDialog(context, ref), // default
    );
  }
}


Future<void> _takeProfilePhoto(
    BuildContext context, WidgetRef ref) async {
  final permissionStatus = await Permission.camera.request();
  if (!permissionStatus.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permiso de cámara denegado')),
    );
    return;
  }

  final picker = ImagePicker();
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  if (photo != null) await _handlePhoto(ref, photo);
}

Future<void> _showImageSourceDialog(
    BuildContext context, WidgetRef ref) async {
  final picker = ImagePicker();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Elegir de la galería'),
            onTap: () async {
              Navigator.of(context).pop();
              final XFile? photo =
                  await picker.pickImage(source: ImageSource.gallery);
              if (photo != null) await _handlePhoto(ref, photo);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Sacar una foto'),
            onTap: () async {
              Navigator.of(context).pop();
              await _takeProfilePhoto(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Cancelar'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}

Future<void> _handlePhoto(WidgetRef ref, XFile photo) async {
  final uid = ref.read(authNotifierProvider).currentUser!.uuid;
  try {
    await ref.read(profileControllerProvider)
             .uploadProfilePicture(uid, photo);   // already on your interface
    await ref.read(authNotifierProvider.notifier).refreshUser();
  } catch (e) {
    debugPrint('❌ Error subiendo foto: $e');
  }
}