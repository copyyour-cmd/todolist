// 这是一个集成示例文件，展示如何使用优化后的位置服务

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/location_battery_config.dart';
import 'package:todolist/src/domain/entities/smart_reminder.dart';
import 'package:todolist/src/features/smart_reminders/application/optimized_location_reminder_service.dart';

// ============================================================================
// Provider 定义
// ============================================================================

/// 位置电池配置的 StateProvider
/// 可以持久化到 SharedPreferences
final locationBatteryConfigProvider =
    StateProvider<LocationBatteryConfig>((ref) {
  // TODO: 从 SharedPreferences 加载保存的配置
  return LocationBatteryConfig.fromMode(BatteryOptimizationMode.balanced);
});

/// 优化的位置服务 Provider
final optimizedLocationServiceProvider = Provider<OptimizedLocationReminderService>((ref) {
  final config = ref.watch(locationBatteryConfigProvider);
  return OptimizedLocationReminderService(initialConfig: config);
});

/// 位置服务状态 Provider
final locationServiceStatusProvider = StreamProvider<LocationServiceStatus>((ref) {
  final service = ref.watch(optimizedLocationServiceProvider);
  return service.statusStream;
});

// ============================================================================
// 集成步骤 1: 更新 Provider
// ============================================================================

/// 在 smart_reminder_providers.dart 中，替换原有的 locationReminderServiceProvider:
///
/// ```dart
/// // 旧版本
/// final locationReminderServiceProvider = Provider<LocationReminderService>((ref) {
///   return LocationReminderService();
/// });
///
/// // 新版本
/// final locationReminderServiceProvider = Provider<OptimizedLocationReminderService>((ref) {
///   final config = ref.watch(locationBatteryConfigProvider);
///   return OptimizedLocationReminderService(initialConfig: config);
/// });
/// ```

// ============================================================================
// 集成步骤 2: 更新 SmartReminderService
// ============================================================================

/// 在 smart_reminder_service.dart 中更新依赖注入:
///
/// ```dart
/// class SmartReminderService {
///   final OptimizedLocationReminderService locationService; // 更新类型
///
///   SmartReminderService({
///     required this.locationService,
///     // ... 其他依赖
///   });
///
///   // 使用新的 API
///   Future<void> startLocationMonitoring() async {
///     final reminders = await _getActiveLocationReminders();
///     await locationService.startMonitoring(reminders);
///
///     // 监听状态更新
///     locationService.statusStream.listen((status) {
///       debugPrint('电池消耗: ${status.estimatedBatteryPerHour}%/h');
///       debugPrint('活跃提醒: ${status.activeRemindersCount}');
///     });
///   }
/// }
/// ```

// ============================================================================
// 集成步骤 3: 添加应用生命周期监听
// ============================================================================

/// 在主应用中监听生命周期，以优化后台性能
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final locationService = ref.read(optimizedLocationServiceProvider);

    switch (state) {
      case AppLifecycleState.resumed:
        // 应用回到前台
        locationService.setBackgroundState(false);
        debugPrint('位置服务: 切换到前台模式');
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // 应用进入后台
        locationService.setBackgroundState(true);
        debugPrint('位置服务: 切换到后台模式');
        break;

      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // 应用即将关闭
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

// ============================================================================
// 集成步骤 4: 创建配置管理页面入口
// ============================================================================

/// 在设置页面中添加位置电池优化入口
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(locationServiceStatusProvider);

    return ListView(
      children: [
        // ... 其他设置项

        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('位置服务电池优化'),
          subtitle: statusAsync.when(
            data: (status) => Text(
              '当前模式: ${_getModeLabel(status.currentMode)} - '
              '预估消耗: ${status.batteryUsageDescription}',
            ),
            loading: () => const Text('加载中...'),
            error: (_, __) => const Text('位置服务未运行'),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // 打开位置电池优化设置页面
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const LocationBatterySettingsPage(),
            //   ),
            // );
          },
        ),

        // 快速切换模式
        _buildQuickModeSwitch(context, ref),
      ],
    );
  }

  Widget _buildQuickModeSwitch(BuildContext context, WidgetRef ref) {
    final config = ref.watch(locationBatteryConfigProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '快速切换优化模式',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<BatteryOptimizationMode>(
              segments: const [
                ButtonSegment(
                  value: BatteryOptimizationMode.powerSaver,
                  label: Text('省电'),
                  icon: Icon(Icons.battery_saver),
                ),
                ButtonSegment(
                  value: BatteryOptimizationMode.balanced,
                  label: Text('平衡'),
                  icon: Icon(Icons.balance),
                ),
                ButtonSegment(
                  value: BatteryOptimizationMode.smart,
                  label: Text('智能'),
                  icon: Icon(Icons.psychology),
                ),
                ButtonSegment(
                  value: BatteryOptimizationMode.highAccuracy,
                  label: Text('高精度'),
                  icon: Icon(Icons.gps_fixed),
                ),
              ],
              selected: {config.mode},
              onSelectionChanged: (Set<BatteryOptimizationMode> newSelection) {
                final newMode = newSelection.first;
                final newConfig = LocationBatteryConfig.fromMode(newMode);

                // 更新配置
                ref.read(locationBatteryConfigProvider.notifier).state = newConfig;

                // 更新位置服务
                ref.read(optimizedLocationServiceProvider).updateConfig(newConfig);

                // TODO: 保存到 SharedPreferences
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getModeLabel(BatteryOptimizationMode mode) {
    switch (mode) {
      case BatteryOptimizationMode.highAccuracy:
        return '最高精度';
      case BatteryOptimizationMode.balanced:
        return '平衡模式';
      case BatteryOptimizationMode.powerSaver:
        return '省电模式';
      case BatteryOptimizationMode.smart:
        return '智能模式';
    }
  }
}

// ============================================================================
// 集成步骤 5: 添加状态监控 Widget
// ============================================================================

/// 位置服务状态监控 Widget
/// 可以放在设置页面或调试页面
class LocationServiceStatusWidget extends ConsumerWidget {
  const LocationServiceStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(locationServiceStatusProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '位置服务状态',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            statusAsync.when(
              data: (status) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusRow(
                    '监控状态',
                    status.isMonitoring ? '运行中' : '已停止',
                    status.isMonitoring ? Colors.green : Colors.grey,
                  ),
                  const Divider(),
                  _buildStatusRow(
                    '活跃提醒',
                    '${status.activeRemindersCount} 个',
                    null,
                  ),
                  const Divider(),
                  _buildStatusRow(
                    '优化模式',
                    _getModeLabel(status.currentMode),
                    null,
                  ),
                  const Divider(),
                  _buildStatusRow(
                    '预估电池消耗',
                    status.batteryUsageDescription,
                    _getBatteryColor(status.estimatedBatteryPerHour),
                  ),
                  const Divider(),
                  _buildStatusRow(
                    '最后更新',
                    status.lastUpdateTime != null
                        ? _formatDateTime(status.lastUpdateTime!)
                        : '从未',
                    null,
                  ),
                  const Divider(),
                  _buildConfigInfo(status.config),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('错误: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigInfo(LocationBatteryConfig config) {
    return ExpansionTile(
      title: const Text('配置详情'),
      children: [
        _buildStatusRow('地理围栏', config.useGeofencing ? '开启' : '关闭', null),
        _buildStatusRow('距离过滤', '${config.distanceFilterMeters} 米', null),
        _buildStatusRow('定位精度', config.accuracy.name, null),
        _buildStatusRow('后台降频', config.reduceFrequencyInBackground ? '开启' : '关闭', null),
        _buildStatusRow('后台间隔', '${config.backgroundUpdateIntervalSeconds} 秒', null),
      ],
    );
  }

  String _getModeLabel(BatteryOptimizationMode mode) {
    switch (mode) {
      case BatteryOptimizationMode.highAccuracy:
        return '最高精度';
      case BatteryOptimizationMode.balanced:
        return '平衡模式';
      case BatteryOptimizationMode.powerSaver:
        return '省电模式';
      case BatteryOptimizationMode.smart:
        return '智能模式';
    }
  }

  Color _getBatteryColor(double usage) {
    if (usage < 1.5) return Colors.green;
    if (usage < 3.0) return Colors.orange;
    return Colors.red;
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} 秒前';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} 分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} 小时前';
    } else {
      return '${diff.inDays} 天前';
    }
  }
}

// ============================================================================
// 使用示例
// ============================================================================

/// 示例：在任务详情页面中使用位置服务
class TaskDetailExample extends ConsumerWidget {
  const TaskDetailExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('任务详情')),
      body: Column(
        children: [
          // ... 任务信息

          // 添加位置提醒
          ElevatedButton(
            onPressed: () async {
              final locationService = ref.read(optimizedLocationServiceProvider);

              // 获取当前位置
              final position = await locationService.getCurrentPosition();

              if (position != null) {
                // 创建位置提醒
                final reminder = SmartReminder(
                  id: 'reminder-id',
                  taskId: 'task-id',
                  type: ReminderType.location,
                  createdAt: DateTime.now(),
                  locationTrigger: LocationTrigger(
                    latitude: position.latitude,
                    longitude: position.longitude,
                    radiusMeters: 100,
                    placeName: '当前位置',
                  ),
                );

                // 开始监控（实际应该通过 SmartReminderService）
                await locationService.startMonitoring([reminder]);

                // 监听触发
                locationService.triggerStream.listen((triggeredReminder) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('您已到达目标位置！')),
                  );
                });
              }
            },
            child: const Text('添加位置提醒'),
          ),

          // 显示位置服务状态
          const LocationServiceStatusWidget(),
        ],
      ),
    );
  }
}

// ============================================================================
// 持久化配置示例
// ============================================================================

/// 配置持久化服务
class LocationBatteryConfigPersistence {
  static const String _keyMode = 'location_battery_mode';
  static const String _keyUseGeofencing = 'location_battery_use_geofencing';
  static const String _keyDistanceFilter = 'location_battery_distance_filter';
  static const String _keyAccuracy = 'location_battery_accuracy';
  static const String _keyReduceBackground = 'location_battery_reduce_background';
  static const String _keyBackgroundInterval = 'location_battery_background_interval';

  /// 保存配置
  static Future<void> saveConfig(LocationBatteryConfig config) async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(_keyMode, config.mode.name);
    // await prefs.setBool(_keyUseGeofencing, config.useGeofencing);
    // await prefs.setInt(_keyDistanceFilter, config.distanceFilterMeters);
    // await prefs.setString(_keyAccuracy, config.accuracy.name);
    // await prefs.setBool(_keyReduceBackground, config.reduceFrequencyInBackground);
    // await prefs.setInt(_keyBackgroundInterval, config.backgroundUpdateIntervalSeconds);
  }

  /// 加载配置
  static Future<LocationBatteryConfig> loadConfig() async {
    // final prefs = await SharedPreferences.getInstance();
    // final modeName = prefs.getString(_keyMode);
    //
    // if (modeName != null) {
    //   final mode = BatteryOptimizationMode.values.firstWhere(
    //     (m) => m.name == modeName,
    //     orElse: () => BatteryOptimizationMode.balanced,
    //   );
    //
    //   // 加载自定义配置或使用预设
    //   return LocationBatteryConfig.fromMode(mode);
    // }

    // 默认配置
    return LocationBatteryConfig.fromMode(BatteryOptimizationMode.balanced);
  }
}

// ============================================================================
// 说明
// ============================================================================

/// 集成清单：
///
/// 1. ✅ 创建配置 Provider (locationBatteryConfigProvider)
/// 2. ✅ 创建服务 Provider (optimizedLocationServiceProvider)
/// 3. ✅ 在 SmartReminderService 中使用新服务
/// 4. ✅ 添加应用生命周期监听
/// 5. ✅ 在设置页面添加配置入口
/// 6. ✅ 添加状态监控 Widget
/// 7. ⏳ 实现配置持久化（SharedPreferences）
/// 8. ⏳ 在位置提醒创建流程中集成
/// 9. ⏳ 添加电池监控（可选）
/// 10. ⏳ 测试各种场景下的表现
