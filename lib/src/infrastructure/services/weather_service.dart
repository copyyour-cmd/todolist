import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/weather_info.dart';

/// 天气服务
///
/// 支持多个天气API提供商：
/// - OpenWeatherMap（默认，免费API）
/// - 和风天气（可选，国内更准确）
class WeatherService {
  WeatherService({
    required Clock clock,
    required IdGenerator idGenerator,
    required AppLogger logger,
    String? openWeatherMapApiKey,
    String? qweatherApiKey,
  })  : _clock = clock,
        _idGenerator = idGenerator,
        _logger = logger,
        _openWeatherMapApiKey = openWeatherMapApiKey,
        _qweatherApiKey = qweatherApiKey;

  final Clock _clock;
  final IdGenerator _idGenerator;
  final AppLogger _logger;
  final String? _openWeatherMapApiKey;
  final String? _qweatherApiKey;

  // OpenWeatherMap API基础URL
  static const String _openWeatherMapBaseUrl = 'https://api.openweathermap.org/data/2.5';

  // 和风天气API基础URL
  static const String _qweatherBaseUrl = 'https://devapi.qweather.com/v7';

  /// 获取指定位置的天气信息
  Future<WeatherInfo?> getWeather({
    required double latitude,
    required double longitude,
    required String locationName,
  }) async {
    try {
      // 优先使用和风天气（国内更准确）
      if (_qweatherApiKey != null && _qweatherApiKey!.isNotEmpty) {
        return await _getQWeather(latitude, longitude, locationName);
      }

      // 降级到OpenWeatherMap
      if (_openWeatherMapApiKey != null && _openWeatherMapApiKey!.isNotEmpty) {
        return await _getOpenWeatherMap(latitude, longitude, locationName);
      }

      // 如果都没有配置，使用模拟数据（开发模式）
      _logger.warning('No weather API key configured, using mock data');
      return _getMockWeather(latitude, longitude, locationName);
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch weather', e, stackTrace);
      return null;
    }
  }

  /// 使用OpenWeatherMap API获取天气
  Future<WeatherInfo?> _getOpenWeatherMap(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    final url = Uri.parse(
      '$_openWeatherMapBaseUrl/weather?lat=$latitude&lon=$longitude&appid=$_openWeatherMapApiKey&units=metric&lang=zh_cn',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      _logger.warning('OpenWeatherMap API error: ${response.statusCode}');
      return null;
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final main = data['main'] as Map<String, dynamic>;
    final weather = (data['weather'] as List).first as Map<String, dynamic>;
    final wind = data['wind'] as Map<String, dynamic>;

    final now = _clock.now();

    return WeatherInfo(
      id: _idGenerator.generate(),
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      condition: _parseOpenWeatherMapCondition(weather['main'] as String),
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      description: weather['description'] as String,
      fetchedAt: now,
      validUntil: now.add(const Duration(hours: 1)), // 1小时有效期
      precipitationProbability: null, // 需要调用额外API
      iconCode: weather['icon'] as String,
    );
  }

  /// 使用和风天气API获取天气
  Future<WeatherInfo?> _getQWeather(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    final locationStr = '$longitude,$latitude';
    final url = Uri.parse(
      '$_qweatherBaseUrl/weather/now?location=$locationStr&key=$_qweatherApiKey',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      _logger.warning('QWeather API error: ${response.statusCode}');
      return null;
    }

    final data = json.decode(response.body) as Map<String, dynamic>;

    if (data['code'] != '200') {
      _logger.warning('QWeather API error code: ${data['code']}');
      return null;
    }

    final now = data['now'] as Map<String, dynamic>;
    final currentTime = _clock.now();

    return WeatherInfo(
      id: _idGenerator.generate(),
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      condition: _parseQWeatherCondition(now['icon'] as String),
      temperature: double.parse(now['temp'] as String),
      feelsLike: double.parse(now['feelsLike'] as String),
      humidity: int.parse(now['humidity'] as String),
      windSpeed: double.parse(now['windSpeed'] as String),
      description: now['text'] as String,
      fetchedAt: currentTime,
      validUntil: currentTime.add(const Duration(hours: 1)),
      precipitationProbability: now['precip'] != null ? double.tryParse(now['precip'] as String) : null,
      iconCode: now['icon'] as String,
    );
  }

  /// 模拟天气数据（用于开发测试）
  WeatherInfo _getMockWeather(
    double latitude,
    double longitude,
    String locationName,
  ) {
    final now = _clock.now();
    final hour = now.hour;

    // 根据时间模拟不同天气
    WeatherCondition condition;
    double temperature;
    String description;

    if (hour >= 6 && hour < 12) {
      // 早上：晴天
      condition = WeatherCondition.clear;
      temperature = 18.0;
      description = '晴朗的早晨';
    } else if (hour >= 12 && hour < 18) {
      // 下午：可能有雨
      condition = WeatherCondition.drizzle;
      temperature = 25.0;
      description = '午后阵雨';
    } else {
      // 晚上：多云
      condition = WeatherCondition.clouds;
      temperature = 20.0;
      description = '多云的夜晚';
    }

    return WeatherInfo(
      id: _idGenerator.generate(),
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      condition: condition,
      temperature: temperature,
      feelsLike: temperature - 2,
      humidity: 65,
      windSpeed: 3.5,
      description: description,
      fetchedAt: now,
      validUntil: now.add(const Duration(hours: 1)),
      precipitationProbability: condition == WeatherCondition.drizzle ? 70.0 : 20.0,
      iconCode: '01d',
    );
  }

  /// 解析OpenWeatherMap天气状况
  WeatherCondition _parseOpenWeatherMapCondition(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return WeatherCondition.clear;
      case 'clouds':
        return WeatherCondition.clouds;
      case 'rain':
        return WeatherCondition.rain;
      case 'drizzle':
        return WeatherCondition.drizzle;
      case 'thunderstorm':
        return WeatherCondition.thunderstorm;
      case 'snow':
        return WeatherCondition.snow;
      case 'mist':
        return WeatherCondition.mist;
      case 'fog':
        return WeatherCondition.fog;
      case 'tornado':
        return WeatherCondition.tornado;
      default:
        return WeatherCondition.unknown;
    }
  }

  /// 解析和风天气图标代码
  WeatherCondition _parseQWeatherCondition(String iconCode) {
    // 和风天气图标代码参考：https://dev.qweather.com/docs/resource/icons/
    final code = int.tryParse(iconCode) ?? 999;

    if (code >= 100 && code < 200) {
      return WeatherCondition.clear;
    } else if (code >= 200 && code < 300) {
      return WeatherCondition.clouds;
    } else if (code >= 300 && code < 400) {
      if (code >= 300 && code < 320) {
        return WeatherCondition.rain;
      } else {
        return WeatherCondition.drizzle;
      }
    } else if (code >= 400 && code < 500) {
      return WeatherCondition.snow;
    } else if (code >= 500 && code < 600) {
      return WeatherCondition.mist;
    } else if (code >= 300 && code < 310) {
      return WeatherCondition.thunderstorm;
    }

    return WeatherCondition.unknown;
  }

  /// 获取未来天气预报（可选功能）
  Future<List<WeatherInfo>> getForecast({
    required double latitude,
    required double longitude,
    required String locationName,
    int days = 3,
  }) async {
    // TODO: 实现天气预报功能
    _logger.info('Weather forecast not yet implemented');
    return [];
  }
}
