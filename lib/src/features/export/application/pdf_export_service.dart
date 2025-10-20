import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';

class PdfExportService {
  pw.Font? _chineseFont;

  /// 加载中文字体
  Future<pw.Font> _loadChineseFont() async {
    if (_chineseFont != null) return _chineseFont!;

    // 从assets加载中文字体
    final fontData = await rootBundle.load('assets/fonts/NotoSansSC-Regular.otf');
    _chineseFont = pw.Font.ttf(fontData);
    return _chineseFont!;
  }

  /// 导出任务为PDF
  Future<File> exportTasksToPdf({
    required List<Task> tasks,
    required Map<String, TaskList> taskListsMap,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // 加载中文字体
    final chineseFont = await _loadChineseFont();

    final pdf = pw.Document();

    // 按清单分组任务
    final groupedTasks = <String, List<Task>>{};
    for (final task in tasks) {
      final listId = task.listId;
      if (!groupedTasks.containsKey(listId)) {
        groupedTasks[listId] = [];
      }
      groupedTasks[listId]!.add(task);
    }

    // 统计数据
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final pendingTasks = totalTasks - completedTasks;
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks * 100).toStringAsFixed(1) : '0.0';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: chineseFont),
        build: (pw.Context context) {
          return [
            // 标题
            pw.Header(
              level: 0,
              child: pw.Text(
                '任务导出报告',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: chineseFont),
              ),
            ),
            pw.SizedBox(height: 10),

            // 时间范围
            pw.Text(
              '时间范围: ${DateFormat('yyyy-MM-dd').format(startDate)} 至 ${DateFormat('yyyy-MM-dd').format(endDate)}',
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700, font: chineseFont),
            ),
            pw.SizedBox(height: 20),

            // 统计概览
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '统计概览',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: chineseFont),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('总任务数', totalTasks.toString(), chineseFont),
                      _buildStatItem('已完成', completedTasks.toString(), chineseFont),
                      _buildStatItem('未完成', pendingTasks.toString(), chineseFont),
                      _buildStatItem('完成率', '$completionRate%', chineseFont),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),

            // 任务列表(按清单分组)
            ...groupedTasks.entries.map((entry) {
              final listId = entry.key;
              final tasks = entry.value;
              final taskList = taskListsMap[listId];
              final listName = taskList?.name ?? '未分类';

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.blue100,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
                    ),
                    child: pw.Text(
                      '$listName (${tasks.length})',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        font: chineseFont,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  ...tasks.map((task) => _buildTaskItem(task, chineseFont)),
                  pw.SizedBox(height: 20),
                ],
              );
            }),
          ];
        },
      ),
    );

    // 保存PDF
    final output = await _getOutputFile(startDate, endDate);
    await output.writeAsBytes(await pdf.save());
    return output;
  }

  pw.Widget _buildStatItem(String label, String value, pw.Font font) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
            font: font,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600, font: font),
        ),
      ],
    );
  }

  pw.Widget _buildTaskItem(Task task, pw.Font font) {
    final priorityColor = _getPriorityColor(task.priority);
    final statusIcon = task.isCompleted ? '✓' : '○';

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // 状态图标
          pw.Container(
            width: 20,
            height: 20,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: task.isCompleted ? PdfColors.green : PdfColors.grey),
              shape: pw.BoxShape.circle,
            ),
            child: pw.Text(
              statusIcon,
              style: pw.TextStyle(
                fontSize: 12,
                color: task.isCompleted ? PdfColors.green : PdfColors.grey,
                font: font,
              ),
            ),
          ),
          pw.SizedBox(width: 10),

          // 任务内容
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  task.title,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    decoration: task.isCompleted ? pw.TextDecoration.lineThrough : null,
                    font: font,
                  ),
                ),
                if (task.notes != null && task.notes!.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text(
                    task.notes!,
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700, font: font),
                    maxLines: 2,
                  ),
                ],
                if (task.dueAt != null) ...[
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '截止: ${DateFormat('yyyy-MM-dd HH:mm').format(task.dueAt!)}',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600, font: font),
                  ),
                ],
              ],
            ),
          ),

          // 优先级标签
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: pw.BoxDecoration(
              color: priorityColor,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
            ),
            child: pw.Text(
              _getPriorityText(task.priority),
              style: pw.TextStyle(fontSize: 8, color: PdfColors.white, font: font),
            ),
          ),
        ],
      ),
    );
  }

  PdfColor _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return PdfColors.red800;
      case TaskPriority.high:
        return PdfColors.orange800;
      case TaskPriority.medium:
        return PdfColors.blue800;
      case TaskPriority.low:
        return PdfColors.green800;
      case TaskPriority.none:
        return PdfColors.grey;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return '紧急';
      case TaskPriority.high:
        return '高';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.low:
        return '低';
      case TaskPriority.none:
        return '无';
    }
  }

  Future<File> _getOutputFile(DateTime startDate, DateTime endDate) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'tasks_${DateFormat('yyyyMMdd').format(startDate)}_${DateFormat('yyyyMMdd').format(endDate)}.pdf';
    return File('${directory.path}/$fileName');
  }
}
