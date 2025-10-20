import 'package:flutter/material.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/infrastructure/services/sync_service.dart';

/// 同步冲突解决对话框
class SyncConflictDialog extends StatelessWidget {

  const SyncConflictDialog({
    required this.conflict, required this.onResolveWithServer, required this.onResolveWithClient, super.key,
  });
  final SyncConflict conflict;
  final VoidCallback onResolveWithServer;
  final VoidCallback onResolveWithClient;

  @override
  Widget build(BuildContext context) {
    final serverTask = conflict.serverData != null
        ? Task.fromJson(conflict.serverData!)
        : null;
    final clientTask = conflict.clientData != null
        ? Task.fromJson(conflict.clientData!)
        : null;

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          SizedBox(width: 8),
          Text('同步冲突'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '任务在多个设备上被同时修改，请选择要保留的版本：',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // 服务器版本
            if (serverTask != null) ...[
              _buildVersionCard(
                context,
                title: '服务器版本',
                subtitle: '版本 ${conflict.serverVersion}',
                task: serverTask,
                color: Colors.blue,
                icon: Icons.cloud,
                onTap: onResolveWithServer,
              ),
              const SizedBox(height: 12),
            ],

            // 客户端版本
            if (clientTask != null) ...[
              _buildVersionCard(
                context,
                title: '本地版本',
                subtitle: '版本 ${conflict.clientVersion}',
                task: clientTask,
                color: Colors.green,
                icon: Icons.phone_android,
                onTap: onResolveWithClient,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('稍后处理'),
        ),
      ],
    );
  }

  Widget _buildVersionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Task task,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const Spacer(),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChip(
                  Icons.flag,
                  task.priority.displayName,
                  _getPriorityColor(task.priority),
                ),
                const SizedBox(width: 8),
                _buildChip(
                  Icons.check_circle,
                  task.status.displayName,
                  _getStatusColor(task.status),
                ),
                if (task.updatedAt != null) ...[
                  const Spacer(),
                  Text(
                    _formatDate(task.updatedAt!),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.blue;
      case TaskPriority.none:
        return Colors.grey;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.pending:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
