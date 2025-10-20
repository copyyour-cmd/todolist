import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/widget_config.dart';
import 'package:todolist/src/domain/repositories/widget_config_repository.dart';

class HiveWidgetConfigRepository implements WidgetConfigRepository {
  HiveWidgetConfigRepository(this._box);

  final Box<WidgetConfig> _box;

  static const _configKey = 'widget_config';

  static Future<HiveWidgetConfigRepository> create() async {
    final box = await Hive.openBox<WidgetConfig>('widget_config');
    return HiveWidgetConfigRepository(box);
  }

  @override
  Future<WidgetConfig> getConfig() async {
    return _box.get(_configKey, defaultValue: const WidgetConfig()) ??
        const WidgetConfig();
  }

  @override
  Future<void> saveConfig(WidgetConfig config) async {
    await _box.put(_configKey, config);
  }

  @override
  Stream<WidgetConfig> watchConfig() async* {
    // 先发出当前值
    yield _box.get(_configKey, defaultValue: const WidgetConfig()) ??
        const WidgetConfig();

    // 然后监听后续变化
    await for (final event in _box.watch(key: _configKey)) {
      yield event.value as WidgetConfig? ?? const WidgetConfig();
    }
  }
}
