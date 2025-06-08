import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/molecules/buttons/short_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePictureButton extends StatelessWidget {
  final String text;

  const ProfilePictureButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ShortButton(
      text: text,
      isLarge: false,
      onPressed: () => showImageSourceDialog(context),
    );
  }
}

Future<void> takeProfilePhoto(BuildContext context) async {
  final permissionStatus = await Permission.camera.request();

  if (!permissionStatus.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permiso de cámara denegado')),
    );
    return;
  }

  final picker = ImagePicker();
  final photo = await picker.pickImage(source: ImageSource.camera);

  if (photo != null) {
    // Por ahora no hacemos nada con la imagen
    print('Foto tomada: ${photo.path}');
  }
}

Future<void> showImageSourceDialog(BuildContext context) async {
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
              Navigator.of(context).pop(); // cerrar el modal
              final photo = await picker.pickImage(source: ImageSource.gallery);
              if (photo != null) {
                print('🖼️ Imagen de galería: ${photo.path}');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Sacar una foto'),
            onTap: () async {
              Navigator.of(context).pop(); // cerrar el modal
              await takeProfilePhoto(context); // usa tu función existente
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