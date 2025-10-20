import 'package:geolocator/geolocator.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/traffic_info.dart';
import 'package:todolist/src/domain/entities/weather_info.dart';
import 'package:todolist/src/infrastructure/notifications/notification_service.dart';
import 'package:todolist/src/infrastructure/services/traffic_service.dart';
import 'package:todolist/src/infrastructure/services/weather_service.dart';

/// 预测性提醒服务
///
/// 本小姐实现的智能功能：
/// - 天气条件提醒（下雨时提醒带伞任务）
/// - 交通预测提醒（根据路况提前提醒出发）
/// - 自动计算最佳出发时间
class PredictiveReminderService {
  PredictiveReminderService({
    required WeatherService weatherService,
    required TrafficService trafficService,
    required NotificationService notificationService,
    required Clock clock,
    required IdGenerator idGenerator,
    required AppLogger logger,
  })  : _weatherService = weatherService,
        _trafficService = trafficService,
        _notificationService = notificationService,
        _clock = clock,
        _idGenerator = idGenerator,
        _logger = logger;

  final WeatherService _weatherService;
  final TrafficService _trafficService;
  final NotificationService _notificationService;
  final Clock _clock;
  final IdGenerator _idGenerator;
  final AppLogger _logger;

  // 缓存
  WeatherInfo? _cachedWeather;
  final Map<String, TrafficInfo> _cachedTraffic = {};

  /// 检查任务是否需要天气相关提醒
  Future<bool> checkWeatherReminder(Task task, {List<String>? weatherKeywords}) async {
    try {
      // 默认天气关键词
      final keywords = weatherKeywords ??
          ['雨', '伞', '雨伞', '防晒', '太阳', '外出', '户外', '运动', '跑步', '骑行'];

      // 检查任务标题或备注是否包含天气相关关键词
      final hasWeatherKeyword = keywords.any(
        (keyword) => task.title.contains(keyword) || (task.notes?.contains(keyword) ?? false),
      );

      if (!hasWeatherKeyword) {
        return false;
      }

      // 获取当前位置
      final position = await _getCurrentPosition();
      if (position == null) {
        _logger.warning('无法获取当前位置');
        return false;
      }

      // 获取天气信息
      final weather = await _getWeather(
        position.latitude,
        position.longitude,
        '当前位置',
      );

      if (weather == null) {
        return false;
      }

      // 检查是否需要提醒
      if (weather.needsRainReminder) {
        await _sendWeatherReminder(task, weather);
        return true;
      }

      if (weather.isExtremeWeather) {
        await _sendExtremeWeatherReminder(task, weather);
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      _logger.error('天气提醒检查失败', e, stackTrace);
      return false;
    }
  }

  /// 计算并提醒出行时间
  Future<DateTime?> calculateDepartureTime({
    required Task task,
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    required String originAddress,
    required String destAddress,
    required DateTime appointmentTime,
    int bufferMinutes = 15,
  }) async {
    try {
      // 获取交通信息
      final traffic = await _getTraffic(
        originLat,
        originLng,
        destLat,
        destLng,
        originAddress,
        destAddress,
      );

      if (traffic == null) {
        _logger.warning('无法获取交通信息');
        return null;
      }

      // 计算出发时间
      final travelMinutes = (traffic.durationInTrafficSeconds / 60).ceil();
      final totalMinutes = travelMinutes + bufferMinutes;
      final departureTime = appointmentTime.subtract(Duration(minutes: totalMinutes));

      // 检查是否需要立即提醒
      final now = _clock.now();
      final reminderTime = departureTime.subtract(const Duration(minutes: 10));

      if (now.isAfter(reminderTime) && now.isBefore(departureTime)) {
        await _sendDepartureReminder(task, traffic, departureTime);
      } else if (now.isBefore(reminderTime)) {
        // 计划提醒
        await _scheduleDepartureReminder(task, traffic, reminderTime, departureTime);
      }

      return departureTime;
    } catch (e, stackTrace) {
      _logger.error('出行时间计算失败', e, stackTrace);
      return null;
    }
  }

  /// 获取当前位置
  Future<Position?> _getCurrentPosition() async {
    try {
      // 检查权限
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          return null;
        }
      }

      // 获取当前位置
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      _logger.warning('获取位置失败', e);
      return null;
    }
  }

  /// 获取天气信息（带缓存）
  Future<WeatherInfo?> _getWeather(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    // 检查缓存
    if (_cachedWeather != null && !_cachedWeather!.isExpired(_clock.now())) {
      return _cachedWeather;
    }

    // 获取新数据
    final weather = await _weatherService.getWeather(
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
    );

    if (weather != null) {
      _cachedWeather = weather;
    }

    return weather;
  }

  /// 获取交通信息（带缓存）
  Future<TrafficInfo?> _getTraffic(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
    String originAddress,
    String destAddress,
  ) async {
    final routeKey = '$originLat,$originLng-$destLat,$destLng';

    // 检查缓存
    final cached = _cachedTraffic[routeKey];
    if (cached != null && !cached.isExpired(_clock.now())) {
      return cached;
    }

    // 获取新数据
    final traffic = await _trafficService.getTrafficInfo(
      originLat: originLat,
      originLng: originLng,
      destLat: destLat,
      destLng: destLng,
      originAddress: originAddress,
      destAddress: destAddress,
    );

    if (traffic != null) {
      _cachedTraffic[routeKey] = traffic;
    }

    return traffic;
  }

  /// 发送天气提醒
  Future<void> _sendWeatherReminder(Task task, WeatherInfo weather) async {
    final title = '${weather.emoji} 天气提醒';
    final body = '今天${weather.description}，别忘了完成任务：${task.title}';

    await _notificationService.showNotification(
      id: _generateNotificationId('weather_${task.id}'),
      title: title,
      body: body,
      payload: task.id,
    );

    _logger.info('已发送天气提醒', {'taskId': task.id, 'weather': weather.condition});
  }

  /// 发送极端天气提醒
  Future<void> _sendExtremeWeatherReminder(Task task, WeatherInfo weather) async {
    final title = '⚠️ 极端天气警告';
    final body = '当前${weather.description}（${weather.temperature.toStringAsFixed(1)}°C），请注意安全！\n任务：${task.title}';

    await _notificationService.showNotification(
      id: _generateNotificationId('extreme_weather_${task.id}'),
      title: title,
      body: body,
      payload: task.id,
      priority: NotificationPriority.high,
    );

    _logger.info('已发送极端天气提醒', {'taskId': task.id});
  }

  /// 发送出发提醒
  Future<void> _sendDepartureReminder(
    Task task,
    TrafficInfo traffic,
    DateTime departureTime,
  ) async {
    final now = _clock.now();
    final minutesUntilDeparture = departureTime.difference(now).inMinutes;

    String urgency;
    if (minutesUntilDeparture <= 5) {
      urgency = '🚨 马上';
    } else if (minutesUntilDeparture <= 15) {
      urgency = '⏰ 即将';
    } else {
      urgency = '📍 注意';
    }

    final title = '$urgency 出发提醒';
    final body = '''
任务：${task.title}
路线：${traffic.routeName}
距离：${traffic.formattedDistance}
预计耗时：${traffic.formattedDuration}
${traffic.isSevereTraffic ? '⚠️ 当前路况拥堵！' : ''}
建议${minutesUntilDeparture}分钟后出发
''';

    await _notificationService.showNotification(
      id: _generateNotificationId('departure_${task.id}'),
      title: title,
      body: body,
      payload: task.id,
      priority: minutesUntilDeparture <= 5
          ? NotificationPriority.high
          : NotificationPriority.low,
    );

    _logger.info('已发送出发提醒', {
      'taskId': task.id,
      'minutesUntilDeparture': minutesUntilDeparture,
    });
  }

  /// 计划出发提醒
  Future<void> _scheduleDepartureReminder(
    Task task,
    TrafficInfo traffic,
    DateTime reminderTime,
    DateTime departureTime,
  ) async {
    final title = '📍 出发提醒';
    final body = '''
任务：${task.title}
路线：${traffic.routeName}
预计耗时：${traffic.formattedDuration}
建议出发时间：${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')}
''';

    await _notificationService.scheduleNotification(
      id: _generateNotificationId('scheduled_departure_${task.id}'),
      title: title,
      body: body,
      scheduledDate: reminderTime,
      payload: task.id,
    );

    _logger.info('已计划出发提醒', {
      'taskId': task.id,
      'reminderTime': reminderTime.toIso8601String(),
    });
  }

  /// 生成通知ID
  int _generateNotificationId(String key) {
    return key.hashCode & 0x7fffffff;
  }

  /// 清除缓存
  void clearCache() {
    _cachedWeather = null;
    _cachedTraffic.clear();
  }
}
