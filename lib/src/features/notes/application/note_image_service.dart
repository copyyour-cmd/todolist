import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// 笔记图片管理服务
class NoteImageService {
  final ImagePicker _picker = ImagePicker();

  /// 从图库选择图片
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _saveImageToLocal(image);
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  /// 从相机拍照
  Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _saveImageToLocal(image);
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  /// 保存图片到本地应用目录
  Future<String> _saveImageToLocal(XFile image) async {
    // 获取应用文档目录
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String notesImagesDir = path.join(appDir.path, 'notes_images');

    // 确保目录存在
    final Directory directory = Directory(notesImagesDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // 生成唯一文件名
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String extension = path.extension(image.path);
    final String fileName = 'note_img_$timestamp$extension';
    final String savePath = path.join(notesImagesDir, fileName);

    // 复制文件到应用目录
    final File sourceFile = File(image.path);
    await sourceFile.copy(savePath);

    return savePath;
  }

  /// 删除本地图片文件
  Future<bool> deleteImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// 删除多个图片
  Future<void> deleteImages(List<String> imagePaths) async {
    for (final imagePath in imagePaths) {
      await deleteImage(imagePath);
    }
  }

  /// 清理未使用的图片(传入所有笔记中使用的图片路径)
  Future<int> cleanupUnusedImages(List<String> usedImagePaths) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String notesImagesDir = path.join(appDir.path, 'notes_images');
      final Directory directory = Directory(notesImagesDir);

      if (!await directory.exists()) {
        return 0;
      }

      int deletedCount = 0;
      final List<FileSystemEntity> files = directory.listSync();

      for (final file in files) {
        if (file is File) {
          final String filePath = file.path;
          // 如果文件不在使用列表中,删除它
          if (!usedImagePaths.contains(filePath)) {
            await file.delete();
            deletedCount++;
          }
        }
      }

      return deletedCount;
    } catch (e) {
      print('Error cleaning up images: $e');
      return 0;
    }
  }

  /// 获取图片文件大小(字节)
  Future<int?> getImageSize(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      print('Error getting image size: $e');
      return null;
    }
  }

  /// 计算所有笔记图片占用的总空间(字节)
  Future<int> getTotalImagesSize() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String notesImagesDir = path.join(appDir.path, 'notes_images');
      final Directory directory = Directory(notesImagesDir);

      if (!await directory.exists()) {
        return 0;
      }

      int totalSize = 0;
      final List<FileSystemEntity> files = directory.listSync();

      for (final file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return totalSize;
    } catch (e) {
      print('Error calculating total images size: $e');
      return 0;
    }
  }
}
