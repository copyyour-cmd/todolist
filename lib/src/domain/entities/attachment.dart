import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

@HiveType(typeId: 8, adapterName: 'AttachmentAdapter')
enum AttachmentType {
  @HiveField(0)
  image,
  @HiveField(1)
  file,
  @HiveField(2)
  audio,
}

@HiveType(typeId: 9, adapterName: 'TaskAttachmentAdapter')
@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    @HiveField(0) required String id,
    @HiveField(1) required AttachmentType type,
    @HiveField(2) required String filePath,
    @HiveField(3) required String fileName,
    @HiveField(4) required int fileSize,
    @HiveField(5) required DateTime createdAt,
    @HiveField(6) String? mimeType,
    @HiveField(7) int? durationSeconds, // For audio attachments
  }) = _Attachment;

  const Attachment._();

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

  String get displaySize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get fileExtension {
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot == -1) return '';
    return fileName.substring(lastDot + 1).toUpperCase();
  }
}
