import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 冲突解决对话框
/// 当云端数据和本地数据发生冲突时,让用户选择保留哪个版本
class ConflictResolutionDialog extends StatelessWidget {
  const ConflictResolutionDialog({
    required this.conflictTitle,
    required this.localData,
    required this.serverData,
    super.key,
  });

  final String conflictTitle;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;

  /// 显示冲突解决对话框
  static Future<ConflictResolution?> show(
    BuildContext context, {
    required String conflictTitle,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> serverData,
  }) {
    return showDialog<ConflictResolution>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConflictResolutionDialog(
        conflictTitle: conflictTitle,
        localData: localData,
        serverData: serverData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm');

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '⚠️ 数据冲突',
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '以下数据发生冲突：$conflictTitle',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // 本地版本
            _buildVersionCard(
              context,
              theme,
              title: '📱 本地版本',
              data: localData,
              dateFormatter: dateFormatter,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // 云端版本
            _buildVersionCard(
              context,
              theme,
              title: '☁️ 云端版本',
              data: serverData,
              dateFormatter: dateFormatter,
              color: Colors.green,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '提示',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '请选择要保留的版本。\n'
                    '• 保留本地：使用你设备上的数据\n'
                    '• 保留云端：使用云端服务器上的数据\n'
                    '• 全部保留云端：对所有冲突使用云端数据',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(ConflictResolution.skip),
          child: const Text('跳过'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(ConflictResolution.useServerForAll),
          child: const Text('全部保留云端'),
        ),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(ConflictResolution.useLocal),
          icon: const Icon(Icons.phone_android),
          label: const Text('保留本地'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(ConflictResolution.useServer),
          icon: const Icon(Icons.cloud),
          label: const Text('保留云端'),
        ),
      ],
    );
  }

  Widget _buildVersionCard(
    BuildContext context,
    ThemeData theme, {
    required String title,
    required Map<String, dynamic> data,
    required DateFormat dateFormatter,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._buildDataEntries(theme, data, dateFormatter),
        ],
      ),
    );
  }

  List<Widget> _buildDataEntries(
    ThemeData theme,
    Map<String, dynamic> data,
    DateFormat dateFormatter,
  ) {
    final entries = <Widget>[];

    data.forEach((key, value) {
      // 跳过一些不重要的字段
      if (key == 'id' || key == 'version') return;

      String displayValue = value.toString();

      // 格式化日期
      if (key.contains('At') && value is String) {
        try {
          final date = DateTime.parse(value);
          displayValue = dateFormatter.format(date);
        } catch (_) {}
      }

      // 格式化布尔值
      if (value is bool) {
        displayValue = value ? '是' : '否';
      }

      // 限制长度
      if (displayValue.length > 50) {
        displayValue = '${displayValue.substring(0, 50)}...';
      }

      entries.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  _formatKey(key),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayValue,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return entries;
  }

  String _formatKey(String key) {
    // 将驼峰命名转换为可读格式
    final formatted = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    ).trim();

    // 翻译常见字段名
    final translations = {
      'title': '标题',
      'notes': '备注',
      'status': '状态',
      'priority': '优先级',
      'due At': '截止时间',
      'updated At': '更新时间',
      'created At': '创建时间',
      'completed At': '完成时间',
      'name': '名称',
      'description': '描述',
    };

    return translations[formatted] ?? formatted;
  }
}

/// 冲突解决方案
enum ConflictResolution {
  useLocal, // 使用本地版本
  useServer, // 使用服务器版本
  useServerForAll, // 对所有冲突使用服务器版本
  skip, // 跳过此冲突
}
