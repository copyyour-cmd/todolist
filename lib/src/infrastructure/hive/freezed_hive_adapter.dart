import 'package:hive/hive.dart';

/// Freezed 实体的 JSON 序列化 Adapter
///
/// 由于 Freezed 生成 _$XxxImpl 实现类,而 Hive 查找 adapter 时使用运行时类型,
/// 导致类型不匹配。这个 adapter 通过 JSON 序列化来绕过类型检查。
///
/// 工作原理:
/// 1. 写入时: 将 Freezed 对象转换为 JSON Map,然后序列化 Map
/// 2. 读取时: 反序列化为 Map,然后使用 fromJson 构造 Freezed 对象
class FreezedJsonAdapter<T> extends TypeAdapter<T> {
  FreezedJsonAdapter({
    required this.typeId,
    required this.toJson,
    required this.fromJson,
  });

  @override
  final int typeId;

  final Map<String, dynamic> Function(T obj) toJson;
  final T Function(Map<String, dynamic> json) fromJson;

  @override
  T read(BinaryReader reader) {
    // 读取 Map
    final map = reader.read() as Map;
    // 转换为 Map<String, dynamic>
    final jsonMap = Map<String, dynamic>.from(map);
    // 使用 fromJson 构造对象
    return fromJson(jsonMap);
  }

  @override
  void write(BinaryWriter writer, T obj) {
    // 将对象转换为 JSON Map
    final jsonMap = toJson(obj);
    // 写入 Map
    writer.write(jsonMap);
  }
}

/// 为 Freezed 实体注册 JSON Adapter
///
/// 使用示例:
/// ```dart
/// registerFreezedJsonAdapter<PrizeConfig>(
///   typeId: 50,
///   toJson: (obj) => obj.toJson(),
///   fromJson: (json) => PrizeConfig.fromJson(json),
/// );
/// ```
void registerFreezedJsonAdapter<T>({
  required int typeId,
  required Map<String, dynamic> Function(T obj) toJson,
  required T Function(Map<String, dynamic> json) fromJson,
}) {
  if (!Hive.isAdapterRegistered(typeId)) {
    final adapter = FreezedJsonAdapter<T>(
      typeId: typeId,
      toJson: toJson,
      fromJson: fromJson,
    );
    Hive.registerAdapter(adapter);
  }
}
