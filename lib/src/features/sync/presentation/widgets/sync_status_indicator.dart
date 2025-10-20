import 'package:flutter/material.dart';
import 'package:todolist/src/infrastructure/services/cloud_sync_manager.dart';

/// 同步状态指示器
class SyncStatusIndicator extends StatelessWidget {

  const SyncStatusIndicator({
    required this.syncManager, super.key,
    this.onTap,
  });
  final CloudSyncManager syncManager;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: syncManager,
      builder: (context, _) {
        final status = syncManager.status;
        final lastSync = syncManager.lastSyncTime;

        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildStatusIcon(status),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getStatusText(status),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (lastSync != null)
                        Text(
                          '上次同步: ${_formatLastSync(lastSync)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      if (syncManager.errorMessage != null)
                        Text(
                          syncManager.errorMessage!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (syncManager.hasConflicts)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${syncManager.conflicts.length}个冲突',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return const Icon(Icons.cloud_outlined, color: Colors.grey);
      case SyncStatus.syncing:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case SyncStatus.success:
        return const Icon(Icons.cloud_done, color: Colors.green);
      case SyncStatus.failed:
        return const Icon(Icons.cloud_off, color: Colors.red);
      case SyncStatus.conflict:
        return const Icon(Icons.warning_amber_rounded, color: Colors.orange);
    }
  }

  String _getStatusText(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return '未同步';
      case SyncStatus.syncing:
        return '同步中...';
      case SyncStatus.success:
        return '已同步';
      case SyncStatus.failed:
        return '同步失败';
      case SyncStatus.conflict:
        return '有冲突需要处理';
    }
  }

  String _formatLastSync(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}

/// 浮动同步按钮
class SyncFloatingButton extends StatelessWidget {

  const SyncFloatingButton({
    required this.syncManager, required this.onPressed, super.key,
  });
  final CloudSyncManager syncManager;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: syncManager,
      builder: (context, _) {
        final status = syncManager.status;
        final isSyncing = status == SyncStatus.syncing;

        return FloatingActionButton(
          onPressed: isSyncing ? null : onPressed,
          child: isSyncing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.cloud_sync),
        );
      },
    );
  }
}
