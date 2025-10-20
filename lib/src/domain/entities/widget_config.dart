import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../infrastructure/hive/type_ids.dart';

part 'widget_config.freezed.dart';
part 'widget_config.g.dart';

@HiveType(typeId: HiveTypeIds.widgetConfig, adapterName: 'WidgetConfigAdapter')
@freezed
class WidgetConfig with _$WidgetConfig {
  const factory WidgetConfig({
    @HiveField(0) @Default(WidgetSize.medium) WidgetSize size,
    @HiveField(1) @Default(WidgetTheme.auto) WidgetTheme theme,
    @HiveField(2) @Default(5) int maxTasks,
    @HiveField(3) @Default(true) bool showCompleted,
    @HiveField(4) @Default(true) bool showOverdue,
    @HiveField(5) @Default(0xFFFFFFFF) int backgroundColor,
    @HiveField(6) @Default(0xFF000000) int textColor,
    @HiveField(7) @Default(true) bool showQuickAdd,
    @HiveField(8) @Default(true) bool showRefresh,
  }) = _WidgetConfig;

  const WidgetConfig._();

  factory WidgetConfig.fromJson(Map<String, dynamic> json) =>
      _$WidgetConfigFromJson(json);
}

@HiveType(typeId: HiveTypeIds.widgetSize, adapterName: 'WidgetSizeAdapter')
@JsonEnum()
enum WidgetSize {
  @HiveField(0)
  small,
  @HiveField(1)
  medium,
  @HiveField(2)
  large,
}

@HiveType(typeId: HiveTypeIds.widgetTheme, adapterName: 'WidgetThemeAdapter')
@JsonEnum()
enum WidgetTheme {
  @HiveField(0)
  auto,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
}
