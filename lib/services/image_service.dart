import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static const String _avatarDir = 'avatars';
  final ImagePicker _picker = ImagePicker();

  Future<String> saveAvatar(XFile pickedImage) async {
    final dir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory('${dir.path}/$_avatarDir');

    if (!await avatarDir.exists()) {
      await avatarDir.create();
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '$timestamp.jpg';
    final savedPath = '${avatarDir.path}/$fileName';

    await pickedImage.saveTo(savedPath);
    return savedPath;
  }

  Future<void> deleteAvatar(String? avatarPath) async {
    if (avatarPath == null || avatarPath.isEmpty) return;

    final file = File(avatarPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<String> updateAvatar(XFile newImage, String? oldPath) async {
    return await saveAvatar(newImage);
  }

  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> pickImageFromCamera() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }
}
