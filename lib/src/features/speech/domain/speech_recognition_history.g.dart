// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_recognition_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpeechRecognitionHistoryAdapter
    extends TypeAdapter<SpeechRecognitionHistory> {
  @override
  final int typeId = 86;

  @override
  SpeechRecognitionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpeechRecognitionHistory(
      id: fields[0] as String,
      text: fields[1] as String,
      language: fields[2] as String,
      timestamp: fields[3] as DateTime,
      duration: fields[4] as int?,
      mode: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SpeechRecognitionHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.mode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeechRecognitionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
