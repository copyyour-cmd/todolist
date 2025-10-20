// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteTemplateAdapter extends TypeAdapter<NoteTemplate> {
  @override
  final int typeId = 82;

  @override
  NoteTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteTemplate(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      content: fields[4] as String,
      isPreset: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      usageCount: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NoteTemplate obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.isPreset)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.usageCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
