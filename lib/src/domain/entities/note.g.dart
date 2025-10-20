// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 81;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      createdAt: fields[16] as DateTime,
      updatedAt: fields[17] as DateTime,
      category: fields[3] as NoteCategory,
      tags: (fields[4] as List).cast<String>(),
      isPinned: fields[5] as bool,
      isFavorite: fields[6] as bool,
      isArchived: fields[7] as bool,
      folderPath: fields[8] as String?,
      linkedTaskIds: (fields[9] as List).cast<String>(),
      linkedNoteIds: (fields[10] as List).cast<String>(),
      imageUrls: (fields[11] as List).cast<String>(),
      attachmentUrls: (fields[12] as List).cast<String>(),
      coverImageUrl: fields[13] as String?,
      wordCount: fields[14] as int?,
      readingTimeMinutes: fields[15] as int?,
      lastViewedAt: fields[18] as DateTime?,
      viewCount: fields[19] as int,
      version: fields[20] as int,
      ocrText: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.isPinned)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.isArchived)
      ..writeByte(8)
      ..write(obj.folderPath)
      ..writeByte(9)
      ..write(obj.linkedTaskIds)
      ..writeByte(10)
      ..write(obj.linkedNoteIds)
      ..writeByte(11)
      ..write(obj.imageUrls)
      ..writeByte(12)
      ..write(obj.attachmentUrls)
      ..writeByte(13)
      ..write(obj.coverImageUrl)
      ..writeByte(14)
      ..write(obj.wordCount)
      ..writeByte(15)
      ..write(obj.readingTimeMinutes)
      ..writeByte(18)
      ..write(obj.lastViewedAt)
      ..writeByte(19)
      ..write(obj.viewCount)
      ..writeByte(20)
      ..write(obj.version)
      ..writeByte(21)
      ..write(obj.ocrText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteCategoryAdapter extends TypeAdapter<NoteCategory> {
  @override
  final int typeId = 80;

  @override
  NoteCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NoteCategory.general;
      case 1:
        return NoteCategory.work;
      case 2:
        return NoteCategory.personal;
      case 3:
        return NoteCategory.study;
      case 4:
        return NoteCategory.project;
      case 5:
        return NoteCategory.meeting;
      case 6:
        return NoteCategory.journal;
      case 7:
        return NoteCategory.reference;
      default:
        return NoteCategory.general;
    }
  }

  @override
  void write(BinaryWriter writer, NoteCategory obj) {
    switch (obj) {
      case NoteCategory.general:
        writer.writeByte(0);
        break;
      case NoteCategory.work:
        writer.writeByte(1);
        break;
      case NoteCategory.personal:
        writer.writeByte(2);
        break;
      case NoteCategory.study:
        writer.writeByte(3);
        break;
      case NoteCategory.project:
        writer.writeByte(4);
        break;
      case NoteCategory.meeting:
        writer.writeByte(5);
        break;
      case NoteCategory.journal:
        writer.writeByte(6);
        break;
      case NoteCategory.reference:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: $enumDecodeNullable(_$NoteCategoryEnumMap, json['category']) ??
          NoteCategory.general,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      isPinned: json['isPinned'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      folderPath: json['folderPath'] as String?,
      linkedTaskIds: (json['linkedTaskIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      linkedNoteIds: (json['linkedNoteIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      attachmentUrls: (json['attachmentUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      coverImageUrl: json['coverImageUrl'] as String?,
      wordCount: (json['wordCount'] as num?)?.toInt(),
      readingTimeMinutes: (json['readingTimeMinutes'] as num?)?.toInt(),
      lastViewedAt: json['lastViewedAt'] == null
          ? null
          : DateTime.parse(json['lastViewedAt'] as String),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      version: (json['version'] as num?)?.toInt() ?? 0,
      ocrText: json['ocrText'] as String?,
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'category': _$NoteCategoryEnumMap[instance.category]!,
      'tags': instance.tags,
      'isPinned': instance.isPinned,
      'isFavorite': instance.isFavorite,
      'isArchived': instance.isArchived,
      'folderPath': instance.folderPath,
      'linkedTaskIds': instance.linkedTaskIds,
      'linkedNoteIds': instance.linkedNoteIds,
      'imageUrls': instance.imageUrls,
      'attachmentUrls': instance.attachmentUrls,
      'coverImageUrl': instance.coverImageUrl,
      'wordCount': instance.wordCount,
      'readingTimeMinutes': instance.readingTimeMinutes,
      'lastViewedAt': instance.lastViewedAt?.toIso8601String(),
      'viewCount': instance.viewCount,
      'version': instance.version,
      'ocrText': instance.ocrText,
    };

const _$NoteCategoryEnumMap = {
  NoteCategory.general: 'general',
  NoteCategory.work: 'work',
  NoteCategory.personal: 'personal',
  NoteCategory.study: 'study',
  NoteCategory.project: 'project',
  NoteCategory.meeting: 'meeting',
  NoteCategory.journal: 'journal',
  NoteCategory.reference: 'reference',
};
