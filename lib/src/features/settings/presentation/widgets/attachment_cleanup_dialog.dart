import 'package:flutter/material.dart';
import 'package:todolist/src/features/attachments/application/attachment_cleanup_service.dart';

/// 附件清理对话框
class AttachmentCleanupDialog extends StatefulWidget {
  const AttachmentCleanupDialog({
    required this.storageInfo,
    required this.cleanupService,
    super.key,
  });

  final StorageInfo storageInfo;
  final AttachmentCleanupService cleanupService;

  @override
  State<AttachmentCleanupDialog> createState() =>
      _AttachmentCleanupDialogState();
}

class _AttachmentCleanupDialogState extends State<AttachmentCleanupDialog> {
  bool _isScanning = false;
  bool _isCleaning = false;
  CleanupResult? _scanResult;
  CleanupResult? _cleanupResult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.cleaning_services),
          SizedBox(width: 12),
          Text('附件清理'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 存储信息
            _buildStorageInfoSection(theme),

            if (_scanResult != null) ...[
              const SizedBox(height: 24),
              _buildScanResultSection(theme),
            ],

            if (_cleanupResult != null) ...[
              const SizedBox(height: 24),
              _buildCleanupResultSection(theme),
            ],

            if (_isScanning || _isCleaning) ...[
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      _isScanning ? '正在扫描...' : '正在清理...',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!_isScanning && !_isCleaning) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          if (_scanResult == null)
            FilledButton.icon(
              onPressed: _performScan,
              icon: const Icon(Icons.search),
              label: const Text('扫描孤立文件'),
            ),
          if (_scanResult != null && _scanResult!.orphanedFiles > 0)
            FilledButton.icon(
              onPressed: _performCleanup,
              icon: const Icon(Icons.delete_sweep),
              label: const Text('开始清理'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildStorageInfoSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  '存储概览',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('总文件数', '${widget.storageInfo.totalFiles}'),
            _buildInfoRow('总大小', widget.storageInfo.totalSizeFormatted),
            const Divider(height: 16),
            _buildInfoRow('图片', '${widget.storageInfo.imageFiles} 个'),
            _buildInfoRow('录音', '${widget.storageInfo.audioFiles} 个'),
            _buildInfoRow('文档', '${widget.storageInfo.documentFiles} 个'),
          ],
        ),
      ),
    );
  }

  Widget _buildScanResultSection(ThemeData theme) {
    return Card(
      color: theme.colorScheme.errorContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: theme.colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Text(
                  '扫描结果',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('扫描文件数', '${_scanResult!.scannedFiles}'),
            _buildInfoRow(
              '孤立文件',
              '${_scanResult!.orphanedFiles}',
              valueColor: theme.colorScheme.error,
            ),
            if (_scanResult!.orphanedFiles > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '发现 ${_scanResult!.orphanedFiles} 个未被使用的文件',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            if (_scanResult!.orphanedFiles == 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '太好了！没有发现孤立文件 ✓',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanupResultSection(ThemeData theme) {
    return Card(
      color: Colors.green.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  '清理完成',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('已删除文件', '${_cleanupResult!.deletedFiles}'),
            _buildInfoRow('释放空间', _cleanupResult!.freedSpaceFormatted),
            if (_cleanupResult!.failedFiles > 0)
              _buildInfoRow(
                '删除失败',
                '${_cleanupResult!.failedFiles}',
                valueColor: theme.colorScheme.error,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performScan() async {
    setState(() {
      _isScanning = true;
      _scanResult = null;
    });

    try {
      final result = await widget.cleanupService.cleanupOrphanedFiles(
        dryRun: true, // 只扫描不删除
      );

      if (mounted) {
        setState(() {
          _scanResult = result;
          _isScanning = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('扫描失败: $e')),
        );
      }
    }
  }

  Future<void> _performCleanup() async {
    // 二次确认
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清理'),
        content: Text(
          '即将删除 ${_scanResult!.orphanedFiles} 个孤立文件。\n\n此操作不可撤销，确定继续吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('确定删除'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isCleaning = true;
      _cleanupResult = null;
    });

    try {
      final result = await widget.cleanupService.cleanupOrphanedFiles(
        dryRun: false, // 实际删除
      );

      if (mounted) {
        setState(() {
          _cleanupResult = result;
          _isCleaning = false;
          _scanResult = null; // 清理后重置扫描结果
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '清理完成！删除了 ${result.deletedFiles} 个文件，释放 ${result.freedSpaceFormatted}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCleaning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('清理失败: $e')),
        );
      }
    }
  }
}
