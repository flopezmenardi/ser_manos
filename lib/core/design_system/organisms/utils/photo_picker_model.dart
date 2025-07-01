import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPickerUtil {
  static Future<XFile?> selectFromCameraOrGallery(BuildContext context) async {
    final picker = ImagePicker();

    return showModalBottomSheet<XFile?>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder:
          (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Elegir de la galería', overflow: TextOverflow.ellipsis),
                  onTap: () async {
                    Navigator.of(context).pop(await picker.pickImage(source: ImageSource.gallery));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Sacar una foto', overflow: TextOverflow.ellipsis),
                  onTap: () async {
                    final navigator = Navigator.of(context);

                    final ok = await Permission.camera.request();
                    if (!ok.isGranted) {
                      navigator.pop();
                      return;
                    }
                    navigator.pop(await picker.pickImage(source: ImageSource.camera));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Cancelar', overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.of(context).pop(null),
                ),
              ],
            ),
          ),
    );
  }
}
