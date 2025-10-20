import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/location_battery_config.dart';
import 'package:geolocator/geolocator.dart';

/// 位置服务电池优化设置页面
class LocationBatterySettingsPage extends ConsumerStatefulWidget {
  const LocationBatterySettingsPage({super.key});

  @override
  ConsumerState<LocationBatterySettingsPage> createState() =>
      _LocationBatterySettingsPageState();
}

class _LocationBatterySettingsPageState
    extends ConsumerState<LocationBatterySettingsPage> {
  late LocationBatteryConfig _config;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    // TODO: 从SharedPreferences或Repository加载配置
    _config = LocationBatteryConfig.fromMode(BatteryOptimizationMode.balanced);
  }

  void _updateConfig(LocationBatteryConfig newConfig) {
    setState(() {
      _config = newConfig;
      _isModified = true;
    });
  }

  Future<void> _saveConfig() async {
    // TODO: 保存到SharedPreferences或Repository
    // TODO: 通知LocationReminderService更新配置

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('设置已保存')),
    );

    setState(() {
      _isModified = false;
    });
  }

  void _resetToDefault() {
    setState(() {
      _config = LocationBatteryConfig.fromMode(BatteryOptimizationMode.balanced);
      _isModified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('位置服务电池优化'),
        actions: [
          if (_isModified)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveConfig,
              tooltip: '保存设置',
            ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefault,
            tooltip: '恢复默认',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildModeSelector(),
          const SizedBox(height: 24),
          _buildBatteryEstimate(),
          const SizedBox(height: 24),
          _buildAdvancedSettings(),
          const SizedBox(height: 24),
          _buildSmartModeSettings(),
          const SizedBox(height: 24),
          _buildBackgroundSettings(),
          const SizedBox(height: 24),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '优化模式',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ModeOption(
              mode: BatteryOptimizationMode.highAccuracy,
              title: '最高精度',
              subtitle: '持续GPS定位，电池消耗高 (~5%/小时)',
              icon: Icons.gps_fixed,
              isSelected: _config.mode == BatteryOptimizationMode.highAccuracy,
              onTap: () => _updateConfig(
                LocationBatteryConfig.fromMode(BatteryOptimizationMode.highAccuracy),
              ),
            ),
            const Divider(),
            _ModeOption(
              mode: BatteryOptimizationMode.balanced,
              title: '平衡模式（推荐）',
              subtitle: '使用地理围栏，中等电池消耗 (~2%/小时)',
              icon: Icons.balance,
              isSelected: _config.mode == BatteryOptimizationMode.balanced,
              onTap: () => _updateConfig(
                LocationBatteryConfig.fromMode(BatteryOptimizationMode.balanced),
              ),
            ),
            const Divider(),
            _ModeOption(
              mode: BatteryOptimizationMode.powerSaver,
              title: '省电模式',
              subtitle: '低频率更新，电池消耗低 (~0.8%/小时)',
              icon: Icons.battery_saver,
              isSelected: _config.mode == BatteryOptimizationMode.powerSaver,
              onTap: () => _updateConfig(
                LocationBatteryConfig.fromMode(BatteryOptimizationMode.powerSaver),
              ),
            ),
            const Divider(),
            _ModeOption(
              mode: BatteryOptimizationMode.smart,
              title: '智能模式',
              subtitle: '根据距离动态调整，平衡精度与电池 (~1.5%/小时)',
              icon: Icons.psychology,
              isSelected: _config.mode == BatteryOptimizationMode.smart,
              onTap: () => _updateConfig(
                LocationBatteryConfig.fromMode(BatteryOptimizationMode.smart),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryEstimate() {
    final estimatedUsage = _calculateEstimatedBatteryUsage();

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.battery_charging_full, color: Colors.blue.shade700, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '预估电池消耗',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${estimatedUsage.toStringAsFixed(1)}% / 小时',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getBatteryDescription(estimatedUsage),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '高级设置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('使用地理围栏'),
              subtitle: const Text('推荐开启，可大幅降低电池消耗'),
              value: _config.useGeofencing,
              onChanged: (value) {
                _updateConfig(_config.copyWith(useGeofencing: value));
              },
            ),
            ListTile(
              title: const Text('定位精度'),
              subtitle: Text(_getAccuracyLabel(_config.accuracy)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showAccuracyDialog(),
            ),
            ListTile(
              title: const Text('距离过滤'),
              subtitle: Text('${_config.distanceFilterMeters} 米'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showDistanceFilterDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartModeSettings() {
    if (_config.mode != BatteryOptimizationMode.smart) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '智能模式设置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDistanceThresholdTile(
              '非常远',
              _config.smartThresholds.veryFarMeters,
              '更新间隔: 10分钟',
              (value) => _updateConfig(
                _config.copyWith(
                  smartThresholds: _config.smartThresholds.copyWith(
                    veryFarMeters: value,
                  ),
                ),
              ),
            ),
            _buildDistanceThresholdTile(
              '远',
              _config.smartThresholds.farMeters,
              '更新间隔: 5分钟',
              (value) => _updateConfig(
                _config.copyWith(
                  smartThresholds: _config.smartThresholds.copyWith(
                    farMeters: value,
                  ),
                ),
              ),
            ),
            _buildDistanceThresholdTile(
              '中等',
              _config.smartThresholds.nearMeters,
              '更新间隔: 2分钟',
              (value) => _updateConfig(
                _config.copyWith(
                  smartThresholds: _config.smartThresholds.copyWith(
                    nearMeters: value,
                  ),
                ),
              ),
            ),
            _buildDistanceThresholdTile(
              '接近',
              _config.smartThresholds.veryNearMeters,
              '更新间隔: 30秒',
              (value) => _updateConfig(
                _config.copyWith(
                  smartThresholds: _config.smartThresholds.copyWith(
                    veryNearMeters: value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceThresholdTile(
    String label,
    double currentValue,
    String intervalLabel,
    Function(double) onChanged,
  ) {
    return ListTile(
      title: Text(label),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${currentValue.toInt()} 米'),
          Text(
            intervalLabel,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showDistanceThresholdDialog(label, currentValue, onChanged),
    );
  }

  Widget _buildBackgroundSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '后台运行设置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('后台降低更新频率'),
              subtitle: const Text('应用在后台时减少位置更新，节省电池'),
              value: _config.reduceFrequencyInBackground,
              onChanged: (value) {
                _updateConfig(_config.copyWith(reduceFrequencyInBackground: value));
              },
            ),
            ListTile(
              title: const Text('后台更新间隔'),
              subtitle: Text('${_config.backgroundUpdateIntervalSeconds} 秒'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showBackgroundIntervalDialog(),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('低电量自动优化'),
              subtitle: Text(
                '电池低于 ${_config.lowBatteryThresholdPercent}% 时自动切换到省电模式',
              ),
              value: _config.autoSwitchOnLowBattery,
              onChanged: (value) {
                _updateConfig(_config.copyWith(autoSwitchOnLowBattery: value));
              },
            ),
            if (_config.autoSwitchOnLowBattery)
              ListTile(
                title: const Text('低电量阈值'),
                subtitle: Text('${_config.lowBatteryThresholdPercent}%'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLowBatteryThresholdDialog(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                const Text(
                  '优化建议',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('1. 推荐使用"平衡模式"或"智能模式"获得最佳体验'),
            const SizedBox(height: 4),
            const Text('2. 开启地理围栏可降低30%的电池消耗'),
            const SizedBox(height: 4),
            const Text('3. 智能模式会根据距离自动调整更新频率'),
            const SizedBox(height: 4),
            const Text('4. 后台降频可节省40%的电池消耗'),
            const SizedBox(height: 4),
            const Text('5. 实际电池消耗取决于设备和使用场景'),
          ],
        ),
      ),
    );
  }

  String _getAccuracyLabel(LocationAccuracy accuracy) {
    switch (accuracy) {
      case LocationAccuracy.lowest:
        return '最低 (~3公里)';
      case LocationAccuracy.low:
        return '低 (~1公里)';
      case LocationAccuracy.medium:
        return '中等 (~100米)';
      case LocationAccuracy.high:
        return '高 (~10米)';
      case LocationAccuracy.best:
        return '最高 (~米级)';
      case LocationAccuracy.bestForNavigation:
        return '导航级 (持续最高精度)';
      default:
        return '中等';
    }
  }

  double _calculateEstimatedBatteryUsage() {
    double baseUsage;

    switch (_config.mode) {
      case BatteryOptimizationMode.highAccuracy:
        baseUsage = 5.0;
        break;
      case BatteryOptimizationMode.balanced:
        baseUsage = 2.0;
        break;
      case BatteryOptimizationMode.powerSaver:
        baseUsage = 0.8;
        break;
      case BatteryOptimizationMode.smart:
        baseUsage = 1.5;
        break;
    }

    if (_config.useGeofencing) {
      baseUsage *= 0.7;
    }

    if (_config.reduceFrequencyInBackground) {
      baseUsage *= 0.6;
    }

    return baseUsage;
  }

  String _getBatteryDescription(double usage) {
    if (usage < 1.0) {
      return '极低消耗 - 可长时间运行';
    } else if (usage < 2.0) {
      return '低消耗 - 适合日常使用';
    } else if (usage < 4.0) {
      return '中等消耗 - 建议定期充电';
    } else {
      return '高消耗 - 建议仅在需要时使用';
    }
  }

  Future<void> _showAccuracyDialog() async {
    final accuracies = [
      LocationAccuracy.lowest,
      LocationAccuracy.low,
      LocationAccuracy.medium,
      LocationAccuracy.high,
      LocationAccuracy.best,
    ];

    final result = await showDialog<LocationAccuracy>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择定位精度'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: accuracies.map((accuracy) {
            return RadioListTile<LocationAccuracy>(
              title: Text(_getAccuracyLabel(accuracy)),
              value: accuracy,
              groupValue: _config.accuracy,
              onChanged: (value) {
                Navigator.of(context).pop(value);
              },
            );
          }).toList(),
        ),
      ),
    );

    if (result != null) {
      _updateConfig(_config.copyWith(accuracy: result));
    }
  }

  Future<void> _showDistanceFilterDialog() async {
    final controller = TextEditingController(
      text: _config.distanceFilterMeters.toString(),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('距离过滤（米）'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '距离（米）',
            helperText: '只有移动超过此距离才更新位置',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value >= 10 && value <= 1000) {
                Navigator.of(context).pop(value);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (result != null) {
      _updateConfig(_config.copyWith(distanceFilterMeters: result));
    }
  }

  Future<void> _showBackgroundIntervalDialog() async {
    final presets = [30, 60, 120, 300, 600];

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('后台更新间隔'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: presets.map((seconds) {
            final minutes = seconds ~/ 60;
            final label = minutes > 0 ? '$minutes 分钟' : '$seconds 秒';

            return RadioListTile<int>(
              title: Text(label),
              value: seconds,
              groupValue: _config.backgroundUpdateIntervalSeconds,
              onChanged: (value) {
                Navigator.of(context).pop(value);
              },
            );
          }).toList(),
        ),
      ),
    );

    if (result != null) {
      _updateConfig(_config.copyWith(backgroundUpdateIntervalSeconds: result));
    }
  }

  Future<void> _showLowBatteryThresholdDialog() async {
    final presets = [10, 15, 20, 25, 30];

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('低电量阈值'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: presets.map((percent) {
            return RadioListTile<int>(
              title: Text('$percent%'),
              value: percent,
              groupValue: _config.lowBatteryThresholdPercent,
              onChanged: (value) {
                Navigator.of(context).pop(value);
              },
            );
          }).toList(),
        ),
      ),
    );

    if (result != null) {
      _updateConfig(_config.copyWith(lowBatteryThresholdPercent: result));
    }
  }

  Future<void> _showDistanceThresholdDialog(
    String label,
    double currentValue,
    Function(double) onChanged,
  ) async {
    final controller = TextEditingController(text: currentValue.toInt().toString());

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$label 距离阈值'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '距离（米）',
            helperText: '设置距离阈值',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value >= 50 && value <= 10000) {
                Navigator.of(context).pop(value);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (result != null) {
      onChanged(result);
    }
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final BatteryOptimizationMode mode;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
            ),
            Icon(
              icon,
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Theme.of(context).colorScheme.primary : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
