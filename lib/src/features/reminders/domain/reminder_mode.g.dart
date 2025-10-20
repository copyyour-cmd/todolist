// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_mode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderModeAdapter extends TypeAdapter<ReminderMode> {
  @override
  final int typeId = 69;

  @override
  ReminderMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderMode.notification;
      case 1:
        return ReminderMode.fullScreen;
      case 2:
        return ReminderMode.systemAlarm;
      default:
        return ReminderMode.notification;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderMode obj) {
    switch (obj) {
      case ReminderMode.notification:
        writer.writeByte(0);
        break;
      case ReminderMode.fullScreen:
        writer.writeByte(1);
        break;
      case ReminderMode.systemAlarm:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
