import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/logging_providers.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/features/predictive_reminders/application/predictive_reminder_service.dart';
import 'package:todolist/src/infrastructure/notifications/notification_service.dart';
import 'package:todolist/src/infrastructure/services/traffic_service.dart';
import 'package:todolist/src/infrastructure/services/weather_service.dart';

/// 天气服务Provider
final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService(
    clock: ref.watch(clockProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    logger: ref.watch(appLoggerProvider),
    // TODO: 从设置中读取API密钥
    openWeatherMapApiKey: null, // 需要用户配置
    qweatherApiKey: null, // 需要用户配置
  );
});

/// 交通服务Provider
final trafficServiceProvider = Provider<TrafficService>((ref) {
  return TrafficService(
    clock: ref.watch(clockProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    logger: ref.watch(appLoggerProvider),
    // TODO: 从设置中读取API密钥
    googleMapsApiKey: null, // 需要用户配置
    amapApiKey: null, // 需要用户配置
  );
});

/// 预测性提醒服务Provider
final predictiveReminderServiceProvider = Provider<PredictiveReminderService>((ref) {
  return PredictiveReminderService(
    weatherService: ref.watch(weatherServiceProvider),
    trafficService: ref.watch(trafficServiceProvider),
    notificationService: ref.watch(notificationServiceProvider),
    clock: ref.watch(clockProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
