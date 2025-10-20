import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/features/reminders/domain/reminder_mode.dart';

/// 提醒偏好设置服务
/// 管理用户的默认提醒模式偏好
class ReminderPreferencesService {
  ReminderPreferencesService({
    required SharedPreferences prefs,
    required AppLogger logger,
  })  : _prefs = prefs,
        _logger = logger;

  final SharedPreferences _prefs;
  final AppLogger _logger;

  static const _keyDefaultReminderMode = 'default_reminder_mode';

  /// 获取默认提醒模式
  ReminderMode getDefaultReminderMode() {
    try {
      final modeStr = _prefs.getString(_keyDefaultReminderMode);
      if (modeStr == null) {
        // 默认使用标准通知
        return ReminderMode.notification;
      }

      // 解析保存的模式
      switch (modeStr) {
        case 'notification':
          return ReminderMode.notification;
        case 'fullScreen':
          return ReminderMode.fullScreen;
        case 'systemAlarm':
          return ReminderMode.systemAlarm;
        default:
          _logger.warning('Unknown reminder mode: $modeStr');
          return ReminderMode.notification;
      }
    } catch (e, stackTrace) {
      _logger.error('Error getting default reminder mode', e, stackTrace);
      return ReminderMode.notification;
    }
  }

  /// 设置默认提醒模式
  Future<void> setDefaultReminderMode(ReminderMode mode) async {
    try {
      final modeStr = mode.name;
      await _prefs.setString(_keyDefaultReminderMode, modeStr);
      _logger.info('Default reminder mode set to: $modeStr');
    } catch (e, stackTrace) {
      _logger.error('Error setting default reminder mode', e, stackTrace);
      rethrow;
    }
  }

  /// 清除默认提醒模式设置
  Future<void> clearDefaultReminderMode() async {
    try {
      await _prefs.remove(_keyDefaultReminderMode);
      _logger.info('Default reminder mode cleared');
    } catch (e, stackTrace) {
      _logger.error('Error clearing default reminder mode', e, stackTrace);
      rethrow;
    }
  }
}

// Provider for ReminderPreferencesService
final reminderPreferencesServiceProvider = Provider<ReminderPreferencesService>((ref) {
  throw UnimplementedError('ReminderPreferencesService must be overridden');
});

// StateNotifier for managing the default reminder mode
class DefaultReminderModeNotifier extends StateNotifier<ReminderMode> {
  DefaultReminderModeNotifier({
    required ReminderPreferencesService preferencesService,
  })  : _preferencesService = preferencesService,
        super(preferencesService.getDefaultReminderMode());

  final ReminderPreferencesService _preferencesService;

  /// 更新默认提醒模式
  Future<void> updateMode(ReminderMode mode) async {
    await _preferencesService.setDefaultReminderMode(mode);
    state = mode;
  }

  /// 重置为默认值
  Future<void> reset() async {
    await _preferencesService.clearDefaultReminderMode();
    state = ReminderMode.notification;
  }
}

// Provider for the default reminder mode
final defaultReminderModeProvider =
    StateNotifierProvider<DefaultReminderModeNotifier, ReminderMode>((ref) {
  final preferencesService = ref.watch(reminderPreferencesServiceProvider);
  return DefaultReminderModeNotifier(preferencesService: preferencesService);
});
