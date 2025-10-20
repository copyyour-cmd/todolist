import 'package:todolist/src/domain/entities/widget_config.dart';

abstract class WidgetConfigRepository {
  Future<WidgetConfig> getConfig();
  Future<void> saveConfig(WidgetConfig config);
  Stream<WidgetConfig> watchConfig();
}
