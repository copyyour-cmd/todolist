import 'package:flutter/material.dart';

/// 表格向导对话框
class TableWizardDialog extends StatefulWidget {
  const TableWizardDialog({super.key});

  @override
  State<TableWizardDialog> createState() => _TableWizardDialogState();
}

class _TableWizardDialogState extends State<TableWizardDialog> {
  int _rows = 3;
  int _columns = 3;
  TextAlign _alignment = TextAlign.left;
  bool _hasHeader = true;

  final List<List<TextEditingController>> _controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers.clear();
    for (int i = 0; i < _rows; i++) {
      final row = <TextEditingController>[];
      for (int j = 0; j < _columns; j++) {
        row.add(TextEditingController(
          text: i == 0 && _hasHeader ? '标题${j + 1}' : '数据',
        ));
      }
      _controllers.add(row);
    }
  }

  @override
  void dispose() {
    for (final row in _controllers) {
      for (final controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  String _generateMarkdownTable() {
    final buffer = StringBuffer();

    // 生成表头
    buffer.write('|');
    for (int j = 0; j < _columns; j++) {
      buffer.write(' ${_controllers[0][j].text} |');
    }
    buffer.writeln();

    // 生成分隔线
    buffer.write('|');
    for (int j = 0; j < _columns; j++) {
      switch (_alignment) {
        case TextAlign.left:
          buffer.write(':-----|');
          break;
        case TextAlign.center:
          buffer.write(':----:|');
          break;
        case TextAlign.right:
          buffer.write('-----:|');
          break;
        default:
          buffer.write('-----|');
      }
    }
    buffer.writeln();

    // 生成数据行
    final startRow = _hasHeader ? 1 : 0;
    for (int i = startRow; i < _rows; i++) {
      buffer.write('|');
      for (int j = 0; j < _columns; j++) {
        buffer.write(' ${_controllers[i][j].text} |');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 标题
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.table_chart_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '表格向导',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 配置区域
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // 行列配置
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '行数: $_rows',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Slider(
                              value: _rows.toDouble(),
                              min: 2,
                              max: 10,
                              divisions: 8,
                              label: '$_rows',
                              onChanged: (value) {
                                setState(() {
                                  _rows = value.toInt();
                                  _initializeControllers();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '列数: $_columns',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Slider(
                              value: _columns.toDouble(),
                              min: 2,
                              max: 6,
                              divisions: 4,
                              label: '$_columns',
                              onChanged: (value) {
                                setState(() {
                                  _columns = value.toInt();
                                  _initializeControllers();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 对齐方式和表头选项
                  Row(
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('包含表头'),
                          value: _hasHeader,
                          onChanged: (value) {
                            setState(() {
                              _hasHeader = value;
                              _initializeControllers();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<TextAlign>(
                          value: _alignment,
                          decoration: const InputDecoration(
                            labelText: '对齐方式',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: TextAlign.left,
                              child: Text('左对齐'),
                            ),
                            DropdownMenuItem(
                              value: TextAlign.center,
                              child: Text('居中'),
                            ),
                            DropdownMenuItem(
                              value: TextAlign.right,
                              child: Text('右对齐'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _alignment = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 表格编辑区域
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        theme.colorScheme.primaryContainer.withOpacity(0.3),
                      ),
                      columns: List.generate(
                        _columns,
                        (i) => DataColumn(
                          label: Text('列${i + 1}'),
                        ),
                      ),
                      rows: List.generate(
                        _rows,
                        (i) => DataRow(
                          color: WidgetStateProperty.all(
                            i == 0 && _hasHeader
                                ? theme.colorScheme.primaryContainer
                                    .withOpacity(0.1)
                                : null,
                          ),
                          cells: List.generate(
                            _columns,
                            (j) => DataCell(
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _controllers[i][j],
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: TextStyle(
                                    fontWeight: i == 0 && _hasHeader
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 预览区域
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Markdown 预览:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      _generateMarkdownTable(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context, _generateMarkdownTable());
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('插入表格'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
