import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/app_settings.dart';
import 'package:todolist/src/features/settings/application/app_settings_provider.dart';

/// Provider that calculates the current theme color based on time-based auto-switching
final autoThemeColorProvider = StreamProvider<AppThemeColor?>((ref) {
  final controller = StreamController<AppThemeColor?>();

  // 创建定时器，每分钟检查一次
  Timer? timer;

  void checkAndUpdateTheme() {
    final settings = ref.read(appSettingsProvider).valueOrNull;
    if (settings == null || !settings.autoSwitchTheme) {
      controller.add(null); // 返回null表示不使用自动切换
      return;
    }

    final now = DateTime.now();
    final currentHour = now.hour;

    // 判断当前是日间还是夜间
    final dayStart = settings.dayThemeStartHour;
    final nightStart = settings.nightThemeStartHour;

    bool isDayTime;
    if (dayStart < nightStart) {
      // 正常情况: 例如 6:00 - 18:00 是日间
      isDayTime = currentHour >= dayStart && currentHour < nightStart;
    } else {
      // 跨越午夜的情况: 例如 18:00 - 6:00 是夜间
      isDayTime = currentHour >= dayStart || currentHour < nightStart;
    }

    final themeColor = isDayTime
        ? (settings.dayThemeColor ?? AppThemeColor.bahamaBlue)
        : (settings.nightThemeColor ?? AppThemeColor.deepBlue);

    controller.add(themeColor);
  }

  // 立即检查一次
  checkAndUpdateTheme();

  // 设置定时器，每分钟检查一次
  timer = Timer.periodic(const Duration(minutes: 1), (_) {
    checkAndUpdateTheme();
  });

  // 监听设置变化
  ref.listen(appSettingsProvider, (previous, next) {
    checkAndUpdateTheme();
  });

  // 清理
  ref.onDispose(() {
    timer?.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Provider that calculates the current theme mode based on time-based auto-switching
final autoThemeModeProvider = StreamProvider<bool?>((ref) {
  final controller = StreamController<bool?>();

  // 创建定时器，每分钟检查一次
  Timer? timer;

  void checkAndUpdateMode() {
    final settings = ref.read(appSettingsProvider).valueOrNull;
    if (settings == null || !settings.autoSwitchTheme) {
      controller.add(null); // 返回null表示不使用自动切换
      return;
    }

    final now = DateTime.now();
    final currentHour = now.hour;

    // 判断当前是日间还是夜间
    final dayStart = settings.dayThemeStartHour;
    final nightStart = settings.nightThemeStartHour;

    bool isDayTime;
    if (dayStart < nightStart) {
      // 正常情况: 例如 6:00 - 18:00 是日间
      isDayTime = currentHour >= dayStart && currentHour < nightStart;
    } else {
      // 跨越午夜的情况: 例如 18:00 - 6:00 是夜间
      isDayTime = currentHour >= dayStart || currentHour < nightStart;
    }

    controller.add(isDayTime);
  }

  // 立即检查一次
  checkAndUpdateMode();

  // 设置定时器，每分钟检查一次
  timer = Timer.periodic(const Duration(minutes: 1), (_) {
    checkAndUpdateMode();
  });

  // 监听设置变化
  ref.listen(appSettingsProvider, (previous, next) {
    checkAndUpdateMode();
  });

  // 清理
  ref.onDispose(() {
    timer?.cancel();
    controller.close();
  });

  return controller.stream;
});
