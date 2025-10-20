import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/infrastructure/platform/reminder_protection_provider.dart';

/// 提醒保护设置页面
class ReminderProtectionPage extends ConsumerStatefulWidget {
  const ReminderProtectionPage({super.key});

  static const routePath = '/settings/reminder-protection';
  static const routeName = 'reminder-protection';

  @override
  ConsumerState<ReminderProtectionPage> createState() => _ReminderProtectionPageState();
}

class _ReminderProtectionPageState extends ConsumerState<ReminderProtectionPage> {
  bool _isServiceRunning = false;
  bool _isBatteryOptimized = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    setState(() => _isLoading = true);
    final service = ref.read(reminderProtectionServiceProvider);
    final isOptimized = await service.checkBatteryOptimization();
    setState(() {
      _isBatteryOptimized = !isOptimized; // 反转,因为我们检查的是"是否被忽略优化"
      _isLoading = false;
    });
  }

  Future<void> _toggleService(bool enable) async {
    final service = ref.read(reminderProtectionServiceProvider);
    final success = enable
        ? await service.startForegroundService()
        : await service.stopForegroundService();

    if (success) {
      setState(() => _isServiceRunning = enable);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(enable ? '✅ 提醒保护已开启' : '✅ 提醒保护已关闭'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _requestBatteryOptimization() async {
    final service = ref.read(reminderProtectionServiceProvider);
    await service.requestBatteryOptimizationExemption();

    // 等待用户操作后重新检查
    await Future.delayed(const Duration(seconds: 1));
    await _checkStatus();
  }

  Future<void> _openSettings() async {
    final service = ref.read(reminderProtectionServiceProvider);
    await service.openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('提醒保护'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 说明卡片
                _buildInfoCard(theme, isDark),
                const SizedBox(height: 24),

                // 前台服务开关
                _buildServiceCard(theme, isDark),
                const SizedBox(height: 16),

                // 电池优化设置
                _buildBatteryOptimizationCard(theme, isDark),
                const SizedBox(height: 16),

                // 其他设置建议
                _buildOtherSettingsCard(theme, isDark),
              ],
            ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, bool isDark) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  '为什么需要提醒保护?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Android系统为了省电,可能会在后台杀死应用,导致任务提醒失效。\n\n'
              '开启提醒保护后,应用会在后台保持活跃状态,确保您不会错过任何重要提醒。',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(ThemeData theme, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '提醒保护服务',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isServiceRunning ? '运行中' : '未运行',
                        style: TextStyle(
                          fontSize: 13,
                          color: _isServiceRunning ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isServiceRunning,
                  onChanged: _toggleService,
                  activeColor: theme.colorScheme.primary,
                ),
              ],
            ),
            if (_isServiceRunning) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '您的任务提醒现在受到保护',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryOptimizationCard(ThemeData theme, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isBatteryOptimized
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isBatteryOptimized ? Icons.battery_alert : Icons.battery_full,
                    color: _isBatteryOptimized ? Colors.orange : Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '电池优化',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isBatteryOptimized ? '需要关闭' : '已关闭',
                        style: TextStyle(
                          fontSize: 13,
                          color: _isBatteryOptimized ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '关闭电池优化可以让应用在后台更稳定地运行,建议为本应用关闭电池优化。',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            if (_isBatteryOptimized) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _requestBatteryOptimization,
                  icon: const Icon(Icons.settings_suggest, size: 20),
                  label: const Text('去设置'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOtherSettingsCard(ThemeData theme, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tips_and_updates_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  '其他建议',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTipItem(
              icon: Icons.lock_open,
              title: '允许后台活动',
              description: '在系统设置中允许应用后台运行',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildTipItem(
              icon: Icons.data_usage,
              title: '不限制数据使用',
              description: '允许应用在后台使用数据',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildTipItem(
              icon: Icons.autorenew,
              title: '允许自启动',
              description: '开机后自动启动应用(部分手机支持)',
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openSettings,
                icon: const Icon(Icons.settings, size: 20),
                label: const Text('打开应用设置'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: theme.colorScheme.primary),
                  foregroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
