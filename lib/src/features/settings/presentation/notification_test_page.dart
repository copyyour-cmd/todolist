import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/infrastructure/notifications/notification_service.dart';

/// 通知测试页面 - 用于诊断和测试通知功能
class NotificationTestPage extends ConsumerStatefulWidget {
  const NotificationTestPage({super.key});

  @override
  ConsumerState<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends ConsumerState<NotificationTestPage> {
  final List<String> _logs = [];
  bool _isTestingPermissions = false;

  void _addLog(String message) {
    setState(() {
      final timestamp = DateTime.now().toString().substring(11, 19);
      _logs.insert(0, '[$timestamp] $message');
      if (_logs.length > 50) {
        _logs.removeLast();
      }
    });
  }

  Future<void> _testImmediateNotification() async {
    _addLog('🔔 测试立即通知...');
    try {
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.showNotification(
        id: 99999,
        title: '测试通知',
        body: '这是一个立即显示的测试通知',
        playSound: true,
        enableVibration: true,
        priority: NotificationPriority.high,
      );
      _addLog('✅ 立即通知已发送');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('通知已发送！如果没收到，请检查系统权限')),
        );
      }
    } catch (e) {
      _addLog('❌ 发送失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送失败: $e')),
        );
      }
    }
  }

  Future<void> _testScheduledNotification(int seconds) async {
    _addLog('⏰ 安排 $seconds 秒后的通知...');
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final clock = ref.read(clockProvider);
      final scheduledTime = clock.now().add(Duration(seconds: seconds));

      await notificationService.scheduleNotification(
        id: 88888,
        title: '定时通知测试',
        body: '这是 $seconds 秒前安排的通知',
        scheduledDate: scheduledTime,
      );
      _addLog('✅ 通知已安排在 ${scheduledTime.toString().substring(11, 19)}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('通知已安排在 $seconds 秒后，请等待...')),
        );
      }
    } catch (e) {
      _addLog('❌ 安排失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('安排失败: $e')),
        );
      }
    }
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _isTestingPermissions = true;
    });
    _addLog('🔍 检查通知权限...');

    try {
      // 这里我们无法直接检查权限状态，但可以尝试初始化
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.init();
      _addLog('✅ 通知服务已初始化');
      _addLog('📱 Android 13+: 需要 POST_NOTIFICATIONS 权限');
      _addLog('⏰ Android 12+: 需要 SCHEDULE_EXACT_ALARM 权限');
      _addLog('🔋 请确保应用未被省电模式限制');
    } catch (e) {
      _addLog('❌ 初始化失败: $e');
    } finally {
      setState(() {
        _isTestingPermissions = false;
      });
    }
  }

  Future<void> _testTaskNotification() async {
    _addLog('📋 测试任务提醒（10秒后）...');
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final clock = ref.read(clockProvider);
      final scheduledTime = clock.now().add(const Duration(seconds: 10));

      await notificationService.scheduleNotification(
        id: 77777,
        title: '任务提醒',
        body: '别忘了完成：测试任务',
        scheduledDate: scheduledTime,
        payload: 'test_task_id',
      );
      _addLog('✅ 任务提醒已安排');
    } catch (e) {
      _addLog('❌ 失败: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _addLog('📱 通知测试页面已加载');
    _addLog('👉 点击下方按钮测试通知功能');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知功能测试'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _logs.clear();
              });
            },
            tooltip: '清空日志',
          ),
        ],
      ),
      body: Column(
        children: [
          // 测试按钮区域
          Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '通知测试工具',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '用于诊断通知功能是否正常工作',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _testImmediateNotification,
                      icon: const Icon(Icons.notifications_active),
                      label: const Text('立即通知'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _testScheduledNotification(10),
                      icon: const Icon(Icons.alarm),
                      label: const Text('10秒后'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _testScheduledNotification(30),
                      icon: const Icon(Icons.alarm),
                      label: const Text('30秒后'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _testTaskNotification,
                      icon: const Icon(Icons.task),
                      label: const Text('任务提醒'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isTestingPermissions ? null : _checkPermissions,
                      icon: _isTestingPermissions
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.security),
                      label: const Text('检查权限'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 日志区域
          Expanded(
            child: _logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无日志',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _logs.length,
                    separatorBuilder: (_, __) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      Color? color;
                      if (log.contains('✅')) {
                        color = Colors.green;
                      } else if (log.contains('❌')) {
                        color = Colors.red;
                      } else if (log.contains('⏰') || log.contains('🔔')) {
                        color = Colors.blue;
                      }

                      return Text(
                        log,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: color,
                              fontFamily: 'monospace',
                            ),
                      );
                    },
                  ),
          ),

          // 说明区域
          Container(
            color: Theme.of(context).colorScheme.errorContainer,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '如果通知未触发，请检查：',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• 系统设置 → 应用 → Dog10 → 通知权限已开启\n'
                  '• 系统设置 → 应用 → Dog10 → 电池 → 无限制\n'
                  '• 未开启勿扰模式\n'
                  '• 小米/华为/OPPO: 需设置自启动和后台运行',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
