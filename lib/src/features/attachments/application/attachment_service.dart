import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/attachment.dart';

class AttachmentService {
  AttachmentService(this._clock, this._idGenerator);

  final Clock _clock;
  final IdGenerator _idGenerator;
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  Future<String> get _attachmentsDir async {
    final appDir = await getApplicationDocumentsDirectory();
    final attachmentsDir = Directory('${appDir.path}/attachments');
    if (!await attachmentsDir.exists()) {
      await attachmentsDir.create(recursive: true);
    }
    return attachmentsDir.path;
  }

  // 图片附件
  Future<Attachment?> pickImageFromCamera() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _saveImageAttachment(image);
    } catch (e) {
      print('Failed to pick image from camera: $e');
      return null;
    }
  }

  Future<Attachment?> pickImageFromGallery() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _saveImageAttachment(image);
    } catch (e) {
      print('Failed to pick image from gallery: $e');
      return null;
    }
  }

  Future<Attachment> _saveImageAttachment(XFile image) async {
    final dir = await _attachmentsDir;
    final id = _idGenerator.generate();
    final ext = path.extension(image.path);
    final fileName = 'IMG_${_clock.now().millisecondsSinceEpoch}$ext';
    final filePath = '$dir/$fileName';

    await File(image.path).copy(filePath);
    final fileSize = await File(filePath).length();

    return Attachment(
      id: id,
      type: AttachmentType.image,
      filePath: filePath,
      fileName: fileName,
      fileSize: fileSize,
      createdAt: _clock.now(),
      mimeType: 'image/${ext.replaceAll('.', '')}',
    );
  }

  // 文件附件
  Future<Attachment?> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
      );

      if (result == null) return null;

      final file = result.files.first;
      final dir = await _attachmentsDir;
      final id = _idGenerator.generate();
      final ext = path.extension(file.name);
      final fileName = 'DOC_${_clock.now().millisecondsSinceEpoch}$ext';
      final filePath = '$dir/$fileName';

      if (file.path != null) {
        await File(file.path!).copy(filePath);
        final fileSize = await File(filePath).length();

        return Attachment(
          id: id,
          type: AttachmentType.file,
          filePath: filePath,
          fileName: file.name,
          fileSize: fileSize,
          createdAt: _clock.now(),
          mimeType: _getMimeType(ext),
        );
      }

      return null;
    } catch (e) {
      print('Failed to pick file: $e');
      return null;
    }
  }

  // 录音附件
  Future<bool> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await _attachmentsDir;
        final fileName = 'AUDIO_${_clock.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          const RecordConfig(),
          path: '$dir/$fileName',
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to start recording: $e');
      return false;
    }
  }

  Future<Attachment?> stopRecording() async {
    try {
      final filePath = await _audioRecorder.stop();
      if (filePath == null) return null;

      final file = File(filePath);
      final fileSize = await file.length();
      final fileName = path.basename(filePath);

      return Attachment(
        id: _idGenerator.generate(),
        type: AttachmentType.audio,
        filePath: filePath,
        fileName: fileName,
        fileSize: fileSize,
        createdAt: _clock.now(),
        mimeType: 'audio/m4a',
      );
    } catch (e) {
      print('Failed to stop recording: $e');
      return null;
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _audioRecorder.cancel();
    } catch (e) {
      print('Failed to cancel recording: $e');
    }
  }

  Future<bool> isRecording() async {
    return _audioRecorder.isRecording();
  }

  // 删除附件
  Future<void> deleteAttachment(Attachment attachment) async {
    try {
      final file = File(attachment.filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Failed to delete attachment: $e');
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case '.pdf':
        return 'application/pdf';
      case '.doc':
      case '.docx':
        return 'application/msword';
      case '.xls':
      case '.xlsx':
        return 'application/vnd.ms-excel';
      case '.txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }
}
