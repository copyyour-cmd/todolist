import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/sync/presentation/widgets/sync_conflict_dialog.dart';
import 'package:todolist/src/features/sync/presentation/widgets/sync_status_indicator.dart';
import 'package:todolist/src/infrastructure/services/cloud_sync_provider.dart';

/// 同步设置页面
class SyncSettingsPage extends ConsumerWidget {
  const SyncSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncManager = ref.watch(cloudSyncManagerProvider);
    final autoSyncEnabled = ref.watch(autoSyncEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('云同步设置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showSyncInfo(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          // 同步状态
          Card(
            margin: const EdgeInsets.all(16),
            child: SyncStatusIndicator(
              syncManager: syncManager,
              onTap: () => _showSyncStatus(context, syncManager),
            ),
          ),

          // 同步操作
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: syncManager.status == SyncStatus.syncing
                      ? null
                      : syncManager.syncAll,
                  icon: const Icon(Icons.sync),
                  label: const Text('立即同步'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: syncManager.status == SyncStatus.syncing
                      ? null
                      : () => _confirmFullSync(context, syncManager),
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('强制全量同步'),
                ),
              ],
            ),
          ),

          const Divider(height: 32),

          // 自动同步设置
          SwitchListTile(
            title: const Text('自动同步'),
            subtitle: const Text('每5分钟自动同步一次'),
            value: autoSyncEnabled,
            onChanged: (value) {
              ref.read(autoSyncEnabledProvider.notifier).state = value;
              syncManager.setAutoSync(value);
            },
          ),

          // 冲突列表
          if (syncManager.hasConflicts) ...[
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '冲突列表 (${syncManager.conflicts.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            ...syncManager.conflicts.map((conflict) {
              return ListTile(
                leading: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                title: Text('任务冲突 #${conflict.clientId}'),
                subtitle: Text(
                  '客户端版本${conflict.clientVersion} vs 服务器版本${conflict.serverVersion}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showConflictDialog(context, conflict, syncManager),
              );
            }),
          ],

          // 同步历史
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('同步历史'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSyncHistory(context, syncManager),
          ),
        ],
      ),
    );
  }

  void _showSyncStatus(BuildContext context, syncManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('同步状态'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow(
              '状态',
              _getStatusText(syncManager.status),
              _getStatusColor(syncManager.status),
            ),
            if (syncManager.lastSyncTime != null)
              _buildStatusRow(
                '上次同步',
                _formatDateTime(syncManager.lastSyncTime!),
                Colors.grey,
              ),
            if (syncManager.hasConflicts)
              _buildStatusRow(
                '冲突',
                '${syncManager.conflicts.length}个',
                Colors.orange,
              ),
            if (syncManager.errorMessage != null)
              _buildStatusRow(
                '错误',
                syncManager.errorMessage!,
                Colors.red,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmFullSync(BuildContext context, syncManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('强制全量同步'),
        content: const Text(
          '这将用服务器数据覆盖本地所有数据，本地未同步的修改将丢失。确定要继续吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              syncManager.forceFullSync();
            },
            child: const Text(
              '确定',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showConflictDialog(
    BuildContext context,
    conflict,
    syncManager,
  ) {
    showDialog(
      context: context,
      builder: (context) => SyncConflictDialog(
        conflict: conflict,
        onResolveWithServer: () =>
            syncManager.resolveConflictWithServer(conflict),
        onResolveWithClient: () =>
            syncManager.resolveConflictWithClient(conflict),
      ),
    );
  }

  Future<void> _showSyncHistory(BuildContext context, syncManager) async {
    final status = await syncManager.getSyncStatus();
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('同步历史'),
        content: status == null
            ? const Text('无法获取同步历史')
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...status.syncHistory.map((record) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          record.status == 'success'
                              ? Icons.check_circle
                              : Icons.error,
                          color: record.status == 'success'
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(record.syncType),
                        subtitle: Text(
                          '${record.recordsCount}条记录 - ${_formatDateTime(record.syncAt)}',
                        ),
                      );
                    }),
                  ],
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showSyncInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于云同步'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '云同步功能说明',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 自动同步: 每5分钟自动同步一次'),
              Text('• 增量同步: 只同步变更的数据'),
              Text('• 冲突检测: 自动检测版本冲突'),
              Text('• 离线支持: 离线时保存到队列'),
              SizedBox(height: 16),
              Text(
                '冲突处理',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('当多个设备同时修改同一任务时会产生冲突，'),
              Text('系统会提示您选择保留哪个版本。'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return '未同步';
      case SyncStatus.syncing:
        return '同步中';
      case SyncStatus.success:
        return '已同步';
      case SyncStatus.failed:
        return '同步失败';
      case SyncStatus.conflict:
        return '有冲突';
    }
  }

  Color _getStatusColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return Colors.grey;
      case SyncStatus.syncing:
        return Colors.blue;
      case SyncStatus.success:
        return Colors.green;
      case SyncStatus.failed:
        return Colors.red;
      case SyncStatus.conflict:
        return Colors.orange;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
