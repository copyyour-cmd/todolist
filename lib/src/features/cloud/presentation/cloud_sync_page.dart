import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/cloud/application/cloud_auth_provider.dart';
import 'package:todolist/src/features/cloud/application/cloud_sync_provider.dart';

/// 云同步管理页面
class CloudSyncPage extends ConsumerStatefulWidget {
  const CloudSyncPage({super.key});

  static const routePath = '/cloud/sync';
  static const routeName = 'cloudSync';

  @override
  ConsumerState<CloudSyncPage> createState() => _CloudSyncPageState();
}

class _CloudSyncPageState extends ConsumerState<CloudSyncPage> {
  bool _isSyncing = false;
  double _progress = 0.0;
  String _progressMessage = '';

  Future<void> _uploadToCloud() async {
    setState(() {
      _isSyncing = true;
      _progress = 0.0;
      _progressMessage = '准备上传...';
    });

    try {
      // 显示进度对话框
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _ProgressDialog(
            progress: _progress,
            message: _progressMessage,
          ),
        );
      }

      setState(() {
        _progress = 0.2;
        _progressMessage = '正在读取本地数据...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _progress = 0.5;
        _progressMessage = '正在上传到云端...';
      });

      final summary = await ref.read(cloudSyncServiceProvider).uploadAll();

      setState(() {
        _progress = 1.0;
        _progressMessage = '上传完成！';
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pop(); // 关闭进度对话框

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ 上传成功！\n'
              '任务 ${summary['tasks']} 条 | 列表 ${summary['lists']} 个\n'
              '标签 ${summary['tags']} 个 | 灵感 ${summary['ideas']} 条',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() => _progressMessage = '上传失败');
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pop(); // 关闭进度对话框

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 上传失败: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _progress = 0.0;
          _progressMessage = '';
        });
      }
    }
  }

  Future<void> _downloadFromCloud({bool clearLocal = false}) async {
    if (clearLocal) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ 警告'),
          content: const Text(
            '此操作将清空本地所有数据，并从云端完全恢复。\n\n'
            '本地数据将被永久删除，确定继续吗？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('确定恢复'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    setState(() => _isSyncing = true);

    try {
      final summary = await ref.read(cloudSyncServiceProvider).downloadAll(
            clearLocal: clearLocal,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '下载成功！任务${summary['tasks']}条，列表${summary['lists']}个，'
              '标签${summary['tags']}个，灵感${summary['ideas']}条',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('下载失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _createSnapshot() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建云端快照'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '快照名称',
                hintText: '例如: 2024年10月备份',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: '描述（可选）',
                hintText: '备注信息',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('创建'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(cloudSyncServiceProvider).createSnapshot(
            name: nameController.text.trim(),
            description: descController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('快照创建成功'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('创建失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('云同步')),
        body: const Center(child: Text('请先登录')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('☁️ 云同步管理'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 用户信息卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              user.email,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.cloud_done,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 同步操作区域
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.cloud_upload, color: theme.colorScheme.primary),
                  title: const Text('上传到云端'),
                  subtitle: const Text('将本地数据上传到云端'),
                  trailing: _isSyncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: _isSyncing ? null : _uploadToCloud,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.cloud_download, color: theme.colorScheme.secondary),
                  title: const Text('从云端下载'),
                  subtitle: const Text('将云端数据合并到本地'),
                  trailing: _isSyncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: _isSyncing ? null : () => _downloadFromCloud(clearLocal: false),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.restore, color: Colors.orange),
                  title: const Text('完全恢复'),
                  subtitle: const Text('清空本地数据，从云端完全恢复'),
                  trailing: _isSyncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: _isSyncing ? null : () => _downloadFromCloud(clearLocal: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 快照管理
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: theme.colorScheme.tertiary),
                  title: const Text('创建快照'),
                  subtitle: const Text('保存当前云端数据快照'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _createSnapshot,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('快照历史'),
                  subtitle: const Text('查看和恢复历史快照'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed('/cloud/snapshots');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 自动备份设置
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('备份设置'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.sync, size: 20),
                  title: const Text('自动备份'),
                  subtitle: const Text('退出应用时自动上传到云端'),
                  value: false, // TODO: 从设置中读取
                  onChanged: (value) {
                    // TODO: 保存到设置
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('自动备份功能即将上线')),
                    );
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.schedule, size: 20),
                  title: const Text('定时备份'),
                  subtitle: const Text('每天自动备份一次'),
                  value: false, // TODO: 从设置中读取
                  onChanged: (value) {
                    // TODO: 保存到设置
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('定时备份功能即将上线')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 数据统计
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 云端数据统计',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: Icons.task_alt,
                        label: '任务',
                        value: '-',
                        color: Colors.blue,
                      ),
                      _StatItem(
                        icon: Icons.list_alt,
                        label: '列表',
                        value: '-',
                        color: Colors.green,
                      ),
                      _StatItem(
                        icon: Icons.label,
                        label: '标签',
                        value: '-',
                        color: Colors.orange,
                      ),
                      _StatItem(
                        icon: Icons.lightbulb,
                        label: '灵感',
                        value: '-',
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('数据统计功能即将上线')),
                        );
                      },
                      child: const Text('刷新统计'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 说明文字
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 使用说明',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• 上传到云端：将本地数据备份到云端，不影响本地数据\n'
                  '• 从云端下载：将云端数据合并到本地，已有数据不会删除\n'
                  '• 完全恢复：清空本地数据，从云端完全恢复，谨慎使用\n'
                  '• 创建快照：在云端保存当前数据快照，可随时恢复\n'
                  '• 自动备份：退出应用时自动上传最新数据到云端\n'
                  '• 定时备份：每天定时自动备份数据',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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

/// 进度对话框
class _ProgressDialog extends StatelessWidget {
  const _ProgressDialog({
    required this.progress,
    required this.message,
  });

  final double progress;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          CircularProgressIndicator(
            value: progress > 0 ? progress : null,
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (progress > 0) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// 数据统计项widget
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

