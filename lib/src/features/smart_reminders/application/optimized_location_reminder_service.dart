import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:todolist/src/domain/entities/smart_reminder.dart';
import 'package:todolist/src/domain/entities/location_battery_config.dart';

/// 优化的位置提醒服务，支持电池优化和地理围栏
class OptimizedLocationReminderService {
  OptimizedLocationReminderService({
    LocationBatteryConfig? initialConfig,
  }) : _config = initialConfig ?? LocationBatteryConfig.fromMode(BatteryOptimizationMode.balanced);

  LocationBatteryConfig _config;
  StreamSubscription<Position>? _positionStream;
  Timer? _backgroundTimer;
  final List<SmartReminder> _activeLocationReminders = [];
  final _triggerController = StreamController<SmartReminder>.broadcast();
  final _statusController = StreamController<LocationServiceStatus>.broadcast();

  Position? _lastPosition;
  DateTime? _lastUpdateTime;
  bool _isInBackground = false;
  int _updateCount = 0;

  Stream<SmartReminder> get triggerStream => _triggerController.stream;
  Stream<LocationServiceStatus> get statusStream => _statusController.stream;
  LocationBatteryConfig get config => _config;

  /// 更新电池优化配置
  Future<void> updateConfig(LocationBatteryConfig newConfig) async {
    _config = newConfig;

    // 如果正在监控，重新启动以应用新配置
    if (_positionStream != null && _activeLocationReminders.isNotEmpty) {
      await startMonitoring(_activeLocationReminders);
    }

    _emitStatus();
  }

  /// 检查并请求位置权限
  Future<bool> checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// 开始监控位置
  Future<void> startMonitoring(List<SmartReminder> reminders) async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return;

    // 过滤活跃的位置提醒
    _activeLocationReminders.clear();
    _activeLocationReminders.addAll(
      reminders.where(
        (r) => r.isActive && r.type == ReminderType.location && r.locationTrigger != null,
      ),
    );

    if (_activeLocationReminders.isEmpty) {
      stopMonitoring();
      return;
    }

    _updateCount = 0;

    // 根据配置选择监控模式
    if (_config.useGeofencing) {
      await _startGeofenceMonitoring();
    } else {
      await _startContinuousMonitoring();
    }

    _emitStatus();
  }

  /// 启动地理围栏监控（推荐，省电）
  Future<void> _startGeofenceMonitoring() async {
    // 停止现有的监控
    _stopAllMonitoring();

    // 如果是智能模式，先获取当前位置以计算距离
    if (_config.mode == BatteryOptimizationMode.smart) {
      _lastPosition = await _getPosition();
    }

    // 使用定时器 + distanceFilter 的组合来模拟地理围栏
    // 真正的地理围栏需要原生平台支持
    final updateInterval = _getSmartUpdateInterval();

    _backgroundTimer = Timer.periodic(Duration(seconds: updateInterval), (timer) async {
      await _checkGeofences();
    });

    debugPrint('地理围栏监控已启动，更新间隔: ${updateInterval}秒');
  }

  /// 启动持续监控（高精度，但耗电）
  Future<void> _startContinuousMonitoring() async {
    _stopAllMonitoring();

    final locationSettings = _config.toLocationSettings();

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      _onPositionUpdate,
      onError: (Object error) {
        debugPrint('位置错误: $error');
      },
    );

    debugPrint('持续位置监控已启动，distanceFilter: ${_config.distanceFilterMeters}米');
  }

  /// 检查地理围栏
  Future<void> _checkGeofences() async {
    try {
      final position = await _getPosition();
      if (position == null) return;

      _lastPosition = position;
      _lastUpdateTime = DateTime.now();
      _updateCount++;

      _checkProximityToReminders(position);

      // 智能模式：根据距离调整更新频率
      if (_config.mode == BatteryOptimizationMode.smart) {
        _adjustSmartUpdateInterval(position);
      }

      _emitStatus();
    } catch (e) {
      debugPrint('地理围栏检查错误: $e');
    }
  }

  /// 智能调整更新间隔
  void _adjustSmartUpdateInterval(Position position) {
    // 计算到最近提醒点的距离
    double minDistance = double.infinity;

    for (final reminder in _activeLocationReminders) {
      final trigger = reminder.locationTrigger;
      if (trigger == null) continue;

      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        trigger.latitude,
        trigger.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    // 根据最近距离调整更新间隔
    final newInterval = _config.getUpdateIntervalForDistance(minDistance);

    if (_backgroundTimer != null) {
      final currentInterval = _backgroundTimer!.tick;
      if (currentInterval != newInterval) {
        _backgroundTimer?.cancel();
        _backgroundTimer = Timer.periodic(Duration(seconds: newInterval), (timer) async {
          await _checkGeofences();
        });

        debugPrint('智能调整更新间隔: $newInterval秒 (距离: ${minDistance.toInt()}米)');
      }
    }
  }

  /// 获取智能更新间隔
  int _getSmartUpdateInterval() {
    if (_config.mode != BatteryOptimizationMode.smart || _lastPosition == null) {
      return _isInBackground
          ? _config.backgroundUpdateIntervalSeconds
          : (_config.backgroundUpdateIntervalSeconds ~/ 2);
    }

    // 计算到最近目标的距离
    double minDistance = double.infinity;
    for (final reminder in _activeLocationReminders) {
      final trigger = reminder.locationTrigger;
      if (trigger == null) continue;

      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        trigger.latitude,
        trigger.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return _config.getUpdateIntervalForDistance(minDistance);
  }

  /// 处理位置更新（持续监控模式）
  void _onPositionUpdate(Position position) {
    _lastPosition = position;
    _lastUpdateTime = DateTime.now();
    _updateCount++;

    _checkProximityToReminders(position);
    _emitStatus();
  }

  /// 检查与提醒点的接近程度
  void _checkProximityToReminders(Position position) {
    final triggeredReminders = <SmartReminder>[];

    for (final reminder in _activeLocationReminders) {
      final trigger = reminder.locationTrigger;
      if (trigger == null) continue;

      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        trigger.latitude,
        trigger.longitude,
      );

      // 检查是否在半径范围内
      if (distance <= trigger.radiusMeters) {
        _triggerController.add(reminder);
        triggeredReminders.add(reminder);

        debugPrint('位置提醒触发: ${trigger.placeName}, 距离: ${distance.toInt()}米');
      }
    }

    // 移除已触发的提醒
    _activeLocationReminders.removeWhere((r) => triggeredReminders.contains(r));

    // 如果没有活跃提醒了，停止监控
    if (_activeLocationReminders.isEmpty) {
      stopMonitoring();
    }
  }

  /// 停止监控位置
  void stopMonitoring() {
    _stopAllMonitoring();
    _activeLocationReminders.clear();
    _emitStatus();

    debugPrint('位置监控已停止');
  }

  /// 停止所有监控
  void _stopAllMonitoring() {
    _positionStream?.cancel();
    _positionStream = null;
    _backgroundTimer?.cancel();
    _backgroundTimer = null;
  }

  /// 设置后台状态
  void setBackgroundState(bool isBackground) {
    if (_isInBackground == isBackground) return;

    _isInBackground = isBackground;

    // 如果启用了后台降频且正在监控
    if (_config.reduceFrequencyInBackground && _activeLocationReminders.isNotEmpty) {
      // 重新启动监控以应用新的频率
      startMonitoring(_activeLocationReminders);
    }

    debugPrint('应用${isBackground ? "进入" : "离开"}后台');
  }

  /// 获取当前位置
  Future<Position?> _getPosition() async {
    try {
      // 根据配置选择精度
      final accuracy = _isInBackground && _config.reduceFrequencyInBackground
          ? LocationAccuracy.low
          : _config.accuracy;

      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: accuracy),
      );
    } catch (e) {
      debugPrint('获取位置失败: $e');
      return null;
    }
  }

  /// 获取当前位置（公开方法）
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: _config.accuracy,
        ),
      );
    } catch (e) {
      debugPrint('获取位置错误: $e');
      return null;
    }
  }

  /// 计算两点之间的距离
  double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// 发送状态更新
  void _emitStatus() {
    final status = LocationServiceStatus(
      isMonitoring: _positionStream != null || _backgroundTimer != null,
      activeRemindersCount: _activeLocationReminders.length,
      config: _config,
      lastUpdateTime: _lastUpdateTime,
      currentMode: _config.mode,
      estimatedBatteryPerHour: _calculateEstimatedBatteryUsage(),
    );

    _statusController.add(status);
  }

  /// 计算预估电池使用
  double _calculateEstimatedBatteryUsage() {
    // 基于模式的基础消耗估算
    double baseUsage;

    switch (_config.mode) {
      case BatteryOptimizationMode.highAccuracy:
        baseUsage = 5.0; // 每小时5%
        break;
      case BatteryOptimizationMode.balanced:
        baseUsage = 2.0; // 每小时2%
        break;
      case BatteryOptimizationMode.powerSaver:
        baseUsage = 0.8; // 每小时0.8%
        break;
      case BatteryOptimizationMode.smart:
        baseUsage = 1.5; // 每小时1.5%（平均）
        break;
    }

    // 地理围栏降低30%消耗
    if (_config.useGeofencing) {
      baseUsage *= 0.7;
    }

    // 后台降频降低40%消耗
    if (_isInBackground && _config.reduceFrequencyInBackground) {
      baseUsage *= 0.6;
    }

    return baseUsage;
  }

  /// 获取当前状态
  LocationServiceStatus getCurrentStatus() {
    return LocationServiceStatus(
      isMonitoring: _positionStream != null || _backgroundTimer != null,
      activeRemindersCount: _activeLocationReminders.length,
      config: _config,
      lastUpdateTime: _lastUpdateTime,
      currentMode: _config.mode,
      estimatedBatteryPerHour: _calculateEstimatedBatteryUsage(),
    );
  }

  /// 获取统计信息
  Map<String, dynamic> getStatistics() {
    return {
      'updateCount': _updateCount,
      'activeReminders': _activeLocationReminders.length,
      'lastUpdate': _lastUpdateTime?.toIso8601String(),
      'isMonitoring': _positionStream != null || _backgroundTimer != null,
      'mode': _config.mode.name,
      'batteryUsage': _calculateEstimatedBatteryUsage(),
    };
  }

  void dispose() {
    stopMonitoring();
    _triggerController.close();
    _statusController.close();
  }
}
