import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/features/export/application/pdf_export_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

class ExportPage extends ConsumerStatefulWidget {
  const ExportPage({super.key});

  static const routeName = 'export';
  static const routePath = '/export';

  @override
  ConsumerState<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<ExportPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isExporting = false;
  String? _lastExportedFile;

  @override
  void initState() {
    super.initState();
    // 默认为本月
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // 确保结束日期不早于开始日期
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _exportToPdf() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择日期范围')),
      );
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      // 获取任务数据
      final taskRepository = ref.read(taskRepositoryProvider);
      final taskListRepository = ref.read(taskListRepositoryProvider);

      final allTasks = await taskRepository.getAll();
      final allLists = await taskListRepository.findAll();

      // 过滤日期范围内的任务
      final filteredTasks = allTasks.where((task) {
        if (task.createdAt.isAfter(_endDate!.add(const Duration(days: 1)))) {
          return false;
        }
        if (task.completedAt != null) {
          return task.completedAt!.isAfter(_startDate!) &&
              task.completedAt!.isBefore(_endDate!.add(const Duration(days: 1)));
        }
        if (task.dueAt != null) {
          return task.dueAt!.isAfter(_startDate!) &&
              task.dueAt!.isBefore(_endDate!.add(const Duration(days: 1)));
        }
        return task.createdAt.isAfter(_startDate!) &&
            task.createdAt.isBefore(_endDate!.add(const Duration(days: 1)));
      }).toList();

      // 创建清单映射
      final taskListsMap = <String, TaskList>{};
      for (final list in allLists) {
        taskListsMap[list.id] = list;
      }

      // 导出PDF
      final pdfService = PdfExportService();
      final file = await pdfService.exportTasksToPdf(
        tasks: filteredTasks,
        taskListsMap: taskListsMap,
        startDate: _startDate!,
        endDate: _endDate!,
      );

      setState(() {
        _lastExportedFile = file.path;
        _isExporting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导出成功: ${file.path.split('/').last}'),
            action: SnackBarAction(
              label: '打开',
              onPressed: () => OpenFile.open(file.path),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $e')),
        );
      }
    }
  }

  void _setQuickDateRange(String range) {
    final now = DateTime.now();
    switch (range) {
      case 'thisWeek':
        final weekday = now.weekday;
        _startDate = now.subtract(Duration(days: weekday - 1));
        _endDate = now.add(Duration(days: 7 - weekday));
      case 'lastWeek':
        final weekday = now.weekday;
        _startDate = now.subtract(Duration(days: weekday + 6));
        _endDate = now.subtract(Duration(days: weekday));
      case 'thisMonth':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 1, 0);
      case 'lastMonth':
        _startDate = DateTime(now.year, now.month - 1, 1);
        _endDate = DateTime(now.year, now.month, 0);
      case 'last30Days':
        _startDate = now.subtract(const Duration(days: 30));
        _endDate = now;
      case 'last90Days':
        _startDate = now.subtract(const Duration(days: 90));
        _endDate = now;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('导出任务'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 快速选择
          Text(
            '快速选择',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickChip('本周', 'thisWeek'),
              _buildQuickChip('上周', 'lastWeek'),
              _buildQuickChip('本月', 'thisMonth'),
              _buildQuickChip('上月', 'lastMonth'),
              _buildQuickChip('最近30天', 'last30Days'),
              _buildQuickChip('最近90天', 'last90Days'),
            ],
          ),

          const SizedBox(height: 32),

          // 自定义日期范围
          Text(
            '自定义日期范围',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // 开始日期
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('开始日期'),
              subtitle: Text(
                _startDate != null
                    ? DateFormat('yyyy-MM-dd').format(_startDate!)
                    : '请选择',
              ),
              onTap: _selectStartDate,
            ),
          ),

          const SizedBox(height: 8),

          // 结束日期
          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: const Text('结束日期'),
              subtitle: Text(
                _endDate != null
                    ? DateFormat('yyyy-MM-dd').format(_endDate!)
                    : '请选择',
              ),
              onTap: _selectEndDate,
            ),
          ),

          const SizedBox(height: 32),

          // 导出按钮
          FilledButton.icon(
            onPressed: _isExporting ? null : _exportToPdf,
            icon: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf),
            label: Text(_isExporting ? '导出中...' : '导出为PDF'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          if (_lastExportedFile != null) ...[
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '上次导出成功',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lastExportedFile!.split('/').last,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => OpenFile.open(_lastExportedFile),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('打开文件'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label, String range) {
    return ActionChip(
      label: Text(label),
      onPressed: () => _setQuickDateRange(range),
    );
  }
}
