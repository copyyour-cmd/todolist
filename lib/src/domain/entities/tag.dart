import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

@HiveType(typeId: 3, adapterName: 'TagAdapter')
@freezed
class Tag with _$Tag {
  const factory Tag({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(3) required DateTime createdAt,
    @HiveField(4) required DateTime updatedAt,
    @HiveField(2) @Default('#8896AB') String colorHex,
  }) = _Tag;

  const Tag._();

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
