import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/traffic_info.dart';

/// 交通服务
///
/// 支持多个地图API提供商：
/// - Google Maps Directions API（国际）
/// - 高德地图API（国内）
class TrafficService {
  TrafficService({
    required Clock clock,
    required IdGenerator idGenerator,
    required AppLogger logger,
    String? googleMapsApiKey,
    String? amapApiKey,
  })  : _clock = clock,
        _idGenerator = idGenerator,
        _logger = logger,
        _googleMapsApiKey = googleMapsApiKey,
        _amapApiKey = amapApiKey;

  final Clock _clock;
  final IdGenerator _idGenerator;
  final AppLogger _logger;
  final String? _googleMapsApiKey;
  final String? _amapApiKey;

  // Google Maps API基础URL
  static const String _googleMapsBaseUrl = 'https://maps.googleapis.com/maps/api';

  // 高德地图API基础URL
  static const String _amapBaseUrl = 'https://restapi.amap.com/v3';

  /// 获取路线交通信息
  Future<TrafficInfo?> getTrafficInfo({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    required String originAddress,
    required String destAddress,
    RoutePreference preference = RoutePreference.fastest,
  }) async {
    try {
      // 优先使用高德地图（国内更准确）
      if (_amapApiKey != null && _amapApiKey!.isNotEmpty) {
        return await _getAmapTraffic(
          originLat,
          originLng,
          destLat,
          destLng,
          originAddress,
          destAddress,
          preference,
        );
      }

      // 降级到Google Maps
      if (_googleMapsApiKey != null && _googleMapsApiKey!.isNotEmpty) {
        return await _getGoogleMapsTraffic(
          originLat,
          originLng,
          destLat,
          destLng,
          originAddress,
          destAddress,
          preference,
        );
      }

      // 如果都没有配置，使用模拟数据（开发模式）
      _logger.warning('No maps API key configured, using mock data');
      return _getMockTraffic(
        originLat,
        originLng,
        destLat,
        destLng,
        originAddress,
        destAddress,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch traffic info', e, stackTrace);
      return null;
    }
  }

  /// 使用Google Maps API获取交通信息
  Future<TrafficInfo?> _getGoogleMapsTraffic(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
    String originAddress,
    String destAddress,
    RoutePreference preference,
  ) async {
    final origin = '$originLat,$originLng';
    final destination = '$destLat,$destLng';

    final avoidParams = <String>[];
    switch (preference) {
      case RoutePreference.avoidHighways:
        avoidParams.add('highways');
        break;
      case RoutePreference.avoidTolls:
        avoidParams.add('tolls');
        break;
      case RoutePreference.fastest:
      case RoutePreference.shortest:
        break;
    }

    final url = Uri.parse(
      '$_googleMapsBaseUrl/directions/json?origin=$origin&destination=$destination&departure_time=now&traffic_model=best_guess&key=$_googleMapsApiKey${avoidParams.isNotEmpty ? '&avoid=${avoidParams.join(',')}' : ''}',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      _logger.warning('Google Maps API error: ${response.statusCode}');
      return null;
    }

    final data = json.decode(response.body) as Map<String, dynamic>;

    if (data['status'] != 'OK') {
      _logger.warning('Google Maps API error: ${data['status']}');
      return null;
    }

    final routes = data['routes'] as List;
    if (routes.isEmpty) {
      return null;
    }

    final route = routes.first as Map<String, dynamic>;
    final leg = (route['legs'] as List).first as Map<String, dynamic>;
    final duration = leg['duration'] as Map<String, dynamic>;
    final durationInTraffic = leg['duration_in_traffic'] as Map<String, dynamic>?;
    final distance = leg['distance'] as Map<String, dynamic>;
    final polyline = route['overview_polyline'] as Map<String, dynamic>;

    final now = _clock.now();

    return TrafficInfo(
      id: _idGenerator.generate(),
      routeName: _generateRouteName(originAddress, destAddress),
      originLat: originLat,
      originLng: originLng,
      destLat: destLat,
      destLng: destLng,
      originAddress: originAddress,
      destAddress: destAddress,
      durationSeconds: duration['value'] as int,
      durationInTrafficSeconds: durationInTraffic?['value'] as int? ?? duration['value'] as int,
      distanceMeters: distance['value'] as int,
      trafficCondition: _calculateTrafficCondition(
        duration['value'] as int,
        durationInTraffic?['value'] as int? ?? duration['value'] as int,
      ),
      fetchedAt: now,
      validUntil: now.add(const Duration(minutes: 15)), // 15分钟有效期
      polyline: polyline['points'] as String,
    );
  }

  /// 使用高德地图API获取交通信息
  Future<TrafficInfo?> _getAmapTraffic(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
    String originAddress,
    String destAddress,
    RoutePreference preference,
  ) async {
    final origin = '$originLng,$originLat'; // 高德使用经度在前
    final destination = '$destLng,$destLat';

    int strategy = 0; // 0: 速度优先
    switch (preference) {
      case RoutePreference.fastest:
        strategy = 0;
        break;
      case RoutePreference.shortest:
        strategy = 1;
        break;
      case RoutePreference.avoidHighways:
        strategy = 3;
        break;
      case RoutePreference.avoidTolls:
        strategy = 4;
        break;
    }

    final url = Uri.parse(
      '$_amapBaseUrl/direction/driving?origin=$origin&destination=$destination&strategy=$strategy&key=$_amapApiKey',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      _logger.warning('Amap API error: ${response.statusCode}');
      return null;
    }

    final data = json.decode(response.body) as Map<String, dynamic>;

    if (data['status'] != '1') {
      _logger.warning('Amap API error: ${data['info']}');
      return null;
    }

    final route = data['route'] as Map<String, dynamic>;
    final paths = route['paths'] as List;

    if (paths.isEmpty) {
      return null;
    }

    final path = paths.first as Map<String, dynamic>;
    final durationSeconds = int.parse(path['duration'] as String);
    final distanceMeters = int.parse(path['distance'] as String);

    // 高德API不直接提供实时交通时长,根据路况计算估值
    final trafficLights = int.parse(path['traffic_lights'] as String? ?? '0');
    final estimatedTrafficDelay = trafficLights * 30; // 每个红绿灯估计30秒延迟
    final durationInTrafficSeconds = durationSeconds + estimatedTrafficDelay;

    final now = _clock.now();

    return TrafficInfo(
      id: _idGenerator.generate(),
      routeName: _generateRouteName(originAddress, destAddress),
      originLat: originLat,
      originLng: originLng,
      destLat: destLat,
      destLng: destLng,
      originAddress: originAddress,
      destAddress: destAddress,
      durationSeconds: durationSeconds,
      durationInTrafficSeconds: durationInTrafficSeconds,
      distanceMeters: distanceMeters,
      trafficCondition: _calculateTrafficCondition(
        durationSeconds,
        durationInTrafficSeconds,
      ),
      fetchedAt: now,
      validUntil: now.add(const Duration(minutes: 15)),
      polyline: path['polyline'] as String?,
    );
  }

  /// 模拟交通数据（用于开发测试）
  TrafficInfo _getMockTraffic(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
    String originAddress,
    String destAddress,
  ) {
    final now = _clock.now();
    final hour = now.hour;

    // 根据时间模拟不同交通状况
    int baseDuration = 1800; // 30分钟
    int trafficDelay = 0;
    TrafficCondition condition;

    if ((hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19)) {
      // 高峰期
      trafficDelay = 900; // 15分钟延迟
      condition = TrafficCondition.heavy;
    } else if (hour >= 22 || hour <= 5) {
      // 深夜
      trafficDelay = 0;
      condition = TrafficCondition.clear;
    } else {
      // 一般时段
      trafficDelay = 300; // 5分钟延迟
      condition = TrafficCondition.moderate;
    }

    // 简单计算距离（使用哈弗赛因公式的近似）
    final latDiff = (destLat - originLat).abs();
    final lngDiff = (destLng - originLng).abs();
    final distanceMeters = (((latDiff + lngDiff) / 2) * 111000).toInt(); // 粗略估算

    return TrafficInfo(
      id: _idGenerator.generate(),
      routeName: _generateRouteName(originAddress, destAddress),
      originLat: originLat,
      originLng: originLng,
      destLat: destLat,
      destLng: destLng,
      originAddress: originAddress,
      destAddress: destAddress,
      durationSeconds: baseDuration,
      durationInTrafficSeconds: baseDuration + trafficDelay,
      distanceMeters: distanceMeters,
      trafficCondition: condition,
      fetchedAt: now,
      validUntil: now.add(const Duration(minutes: 15)),
      polyline: null,
    );
  }

  /// 计算交通状况
  TrafficCondition _calculateTrafficCondition(
    int normalDuration,
    int trafficDuration,
  ) {
    final delayRatio = (trafficDuration - normalDuration) / normalDuration;

    if (delayRatio < 0.1) {
      return TrafficCondition.clear;
    } else if (delayRatio < 0.3) {
      return TrafficCondition.moderate;
    } else if (delayRatio < 0.5) {
      return TrafficCondition.heavy;
    } else {
      return TrafficCondition.severe;
    }
  }

  /// 生成路线名称
  String _generateRouteName(String origin, String dest) {
    // 简化地址（只保留主要部分）
    final originShort = _shortenAddress(origin);
    final destShort = _shortenAddress(dest);
    return '$originShort → $destShort';
  }

  /// 简化地址
  String _shortenAddress(String address) {
    // 移除详细门牌号等信息，保留主要地名
    final parts = address.split(RegExp(r'[,，]'));
    if (parts.length > 2) {
      return parts.sublist(parts.length - 2).join('');
    }
    return address;
  }
}
