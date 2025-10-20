import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

/// 手写/涂鸦对话框
class DrawingDialog extends StatefulWidget {
  const DrawingDialog({super.key});

  @override
  State<DrawingDialog> createState() => _DrawingDialogState();
}

class _DrawingDialogState extends State<DrawingDialog> {
  late SignatureController _controller;
  Color _penColor = Colors.black;
  double _penStrokeWidth = 2.0;

  // 预设颜色
  final List<Color> _colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  // 预设笔触宽度
  final List<double> _strokeWidths = [1.0, 2.0, 3.0, 5.0, 8.0];

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: _penStrokeWidth,
      penColor: _penColor,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Uint8List?> _exportDrawing() async {
    if (_controller.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('画布为空，请先绘制内容')),
        );
      }
      return null;
    }

    try {
      final signature = await _controller.toPngBytes();
      return signature;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $e')),
        );
      }
      return null;
    }
  }

  void _updatePenColor(Color color) {
    setState(() {
      _penColor = color;
      // 需要重新创建 controller 来应用新的颜色
      final points = _controller.points;
      _controller.dispose();
      _controller = SignatureController(
        penStrokeWidth: _penStrokeWidth,
        penColor: _penColor,
        exportBackgroundColor: Colors.white,
        points: points,
      );
    });
  }

  void _updateStrokeWidth(double width) {
    setState(() {
      _penStrokeWidth = width;
      // 需要重新创建 controller 来应用新的笔触宽度
      final points = _controller.points;
      _controller.dispose();
      _controller = SignatureController(
        penStrokeWidth: _penStrokeWidth,
        penColor: _penColor,
        exportBackgroundColor: Colors.white,
        points: points,
      );
    });
  }

  /// 显示颜色选择器弹窗
  Future<void> _showColorPicker() async {
    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) => _ColorPickerDialog(initialColor: _penColor),
    );

    if (selectedColor != null) {
      _updatePenColor(selectedColor);
    }
  }

  /// 显示笔触粗细选择器弹窗
  Future<void> _showStrokeWidthPicker() async {
    final selectedWidth = await showDialog<double>(
      context: context,
      builder: (context) => _StrokeWidthPickerDialog(
        initialWidth: _penStrokeWidth,
        currentColor: _penColor,
      ),
    );

    if (selectedWidth != null) {
      _updateStrokeWidth(selectedWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog.fullscreen(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 标题栏
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.brush_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '手写/涂鸦',
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
            const SizedBox(height: 16),

            // 工具栏
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 颜色选择 - 改为点击按钮弹出选择器
                  Row(
                    children: [
                      const Text(
                        '颜色:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 当前颜色预览按钮
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showColorPicker(),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _penColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _penColor.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.palette,
                                color: _penColor.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '点击选择',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 笔触宽度 - 改为点击按钮弹出选择器
                  Row(
                    children: [
                      const Text(
                        '粗细:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 当前粗细预览按钮
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showStrokeWidthPicker(),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: _penStrokeWidth * 3,
                                height: _penStrokeWidth * 3,
                                decoration: BoxDecoration(
                                  color: _penColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '点击选择',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 画布
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Signature(
                    controller: _controller,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 底部按钮
            Row(
              children: [
                // 清空按钮
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _controller.clear();
                    },
                    icon: const Icon(Icons.clear_rounded),
                    label: const Text('清空'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 撤销按钮
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (_controller.isNotEmpty) {
                        _controller.undo();
                      }
                    },
                    icon: const Icon(Icons.undo_rounded),
                    label: const Text('撤销'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 保存按钮
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () async {
                      final imageData = await _exportDrawing();
                      if (imageData != null && mounted) {
                        Navigator.pop(context, imageData);
                      }
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('保存'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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

/// 颜色选择器对话框
class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({required this.initialColor});

  final Color initialColor;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selectedColor;
  late HSVColor _hsvColor;

  // 预设颜色 - 更丰富的色板
  final List<List<Color>> _presetColors = [
    // 第一行 - 基础色
    [
      Colors.black,
      const Color(0xFF424242),
      const Color(0xFF757575),
      const Color(0xFFBDBDBD),
      Colors.white,
    ],
    // 第二行 - 红色系
    [
      const Color(0xFFFFEBEE),
      const Color(0xFFEF5350),
      const Color(0xFFE53935),
      const Color(0xFFC62828),
      const Color(0xFFB71C1C),
    ],
    // 第三行 - 粉色系
    [
      const Color(0xFFFCE4EC),
      const Color(0xFFEC407A),
      const Color(0xFFD81B60),
      const Color(0xFFC2185B),
      const Color(0xFF880E4F),
    ],
    // 第四行 - 紫色系
    [
      const Color(0xFFF3E5F5),
      const Color(0xFFAB47BC),
      const Color(0xFF8E24AA),
      const Color(0xFF7B1FA2),
      const Color(0xFF4A148C),
    ],
    // 第五行 - 蓝色系
    [
      const Color(0xFFE3F2FD),
      const Color(0xFF42A5F5),
      const Color(0xFF1E88E5),
      const Color(0xFF1565C0),
      const Color(0xFF0D47A1),
    ],
    // 第六行 - 青色系
    [
      const Color(0xFFE0F7FA),
      const Color(0xFF26C6DA),
      const Color(0xFF00ACC1),
      const Color(0xFF00838F),
      const Color(0xFF006064),
    ],
    // 第七行 - 绿色系
    [
      const Color(0xFFE8F5E9),
      const Color(0xFF66BB6A),
      const Color(0xFF43A047),
      const Color(0xFF2E7D32),
      const Color(0xFF1B5E20),
    ],
    // 第八行 - 黄色系
    [
      const Color(0xFFFFFDE7),
      const Color(0xFFFFEE58),
      const Color(0xFFFDD835),
      const Color(0xFFF9A825),
      const Color(0xFFF57F17),
    ],
    // 第九行 - 橙色系
    [
      const Color(0xFFFFF3E0),
      const Color(0xFFFF9800),
      const Color(0xFFF57C00),
      const Color(0xFFE65100),
      const Color(0xFFBF360C),
    ],
    // 第十行 - 棕色系
    [
      const Color(0xFFEFEBE9),
      const Color(0xFF8D6E63),
      const Color(0xFF6D4C41),
      const Color(0xFF5D4037),
      const Color(0xFF3E2723),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _hsvColor = HSVColor.fromColor(_selectedColor);
  }

  void _updateColor(Color color) {
    setState(() {
      _selectedColor = color;
      _hsvColor = HSVColor.fromColor(color);
    });
  }

  void _updateFromHSV(double hue, double saturation, double value) {
    setState(() {
      _hsvColor = HSVColor.fromAHSV(1.0, hue, saturation, value);
      _selectedColor = _hsvColor.toColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: size.width * 0.85,
        constraints: BoxConstraints(maxHeight: size.height * 0.8),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 标题栏
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.palette,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '选择颜色',
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

            // 当前颜色预览
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _selectedColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '当前颜色',
                  style: TextStyle(
                    color: _selectedColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // HSV 色调滑块
            _buildHueSlider(),
            const SizedBox(height: 16),

            // 饱和度滑块
            _buildSaturationSlider(),
            const SizedBox(height: 16),

            // 亮度滑块
            _buildValueSlider(),
            const SizedBox(height: 24),

            // 预设颜色标题
            Row(
              children: [
                Icon(
                  Icons.color_lens,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  '预设颜色',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 预设颜色网格 - 可滚动
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: _presetColors.map((colorRow) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: colorRow.map((color) {
                          final isSelected = color.value == _selectedColor.value;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _updateColor(color),
                              child: Container(
                                height: 40,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: color.computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white,
                                        size: 20,
                                      )
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 底部按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, _selectedColor),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('确定'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 色调滑块
  Widget _buildHueSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '色调',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              '${_hsvColor.hue.toInt()}°',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF0000), // 红
                Color(0xFFFFFF00), // 黄
                Color(0xFF00FF00), // 绿
                Color(0xFF00FFFF), // 青
                Color(0xFF0000FF), // 蓝
                Color(0xFFFF00FF), // 品红
                Color(0xFFFF0000), // 红
              ],
            ),
          ),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 0,
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: _hsvColor.hue,
              min: 0,
              max: 360,
              onChanged: (value) =>
                  _updateFromHSV(value, _hsvColor.saturation, _hsvColor.value),
            ),
          ),
        ),
      ],
    );
  }

  /// 饱和度滑块
  Widget _buildSaturationSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '饱和度',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              '${(_hsvColor.saturation * 100).toInt()}%',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                HSVColor.fromAHSV(1.0, _hsvColor.hue, 0.0, _hsvColor.value)
                    .toColor(),
                HSVColor.fromAHSV(1.0, _hsvColor.hue, 1.0, _hsvColor.value)
                    .toColor(),
              ],
            ),
          ),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 0,
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: _hsvColor.saturation,
              min: 0,
              max: 1,
              onChanged: (value) =>
                  _updateFromHSV(_hsvColor.hue, value, _hsvColor.value),
            ),
          ),
        ),
      ],
    );
  }

  /// 亮度滑块
  Widget _buildValueSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '亮度',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              '${(_hsvColor.value * 100).toInt()}%',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                HSVColor.fromAHSV(1.0, _hsvColor.hue, _hsvColor.saturation, 0.0)
                    .toColor(),
                HSVColor.fromAHSV(1.0, _hsvColor.hue, _hsvColor.saturation, 1.0)
                    .toColor(),
              ],
            ),
          ),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 0,
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: _hsvColor.value,
              min: 0,
              max: 1,
              onChanged: (value) =>
                  _updateFromHSV(_hsvColor.hue, _hsvColor.saturation, value),
            ),
          ),
        ),
      ],
    );
  }
}

/// 笔触粗细选择器对话框
class _StrokeWidthPickerDialog extends StatefulWidget {
  const _StrokeWidthPickerDialog({
    required this.initialWidth,
    required this.currentColor,
  });

  final double initialWidth;
  final Color currentColor;

  @override
  State<_StrokeWidthPickerDialog> createState() =>
      _StrokeWidthPickerDialogState();
}

class _StrokeWidthPickerDialogState extends State<_StrokeWidthPickerDialog> {
  late double _selectedWidth;

  // 预设粗细值
  final List<double> _presetWidths = [
    0.5,
    1.0,
    1.5,
    2.0,
    2.5,
    3.0,
    4.0,
    5.0,
    6.0,
    8.0,
    10.0,
    12.0,
    15.0,
    20.0,
    25.0,
    30.0,
  ];

  @override
  void initState() {
    super.initState();
    _selectedWidth = widget.initialWidth;
  }

  void _updateWidth(double width) {
    setState(() {
      _selectedWidth = width;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: size.width * 0.8,
        constraints: BoxConstraints(maxHeight: size.height * 0.7),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 标题栏
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.line_weight,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '选择笔触粗细',
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

            // 当前粗细预览
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: _selectedWidth * 4,
                      height: _selectedWidth * 4,
                      decoration: BoxDecoration(
                        color: widget.currentColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.currentColor.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_selectedWidth.toStringAsFixed(1)} px',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 滑块调节
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '自定义粗细',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_selectedWidth.toStringAsFixed(1)} px',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: theme.colorScheme.primary,
                    inactiveTrackColor:
                        theme.colorScheme.primary.withValues(alpha: 0.2),
                    thumbColor: theme.colorScheme.primary,
                    overlayColor:
                        theme.colorScheme.primary.withValues(alpha: 0.2),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 12),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _selectedWidth,
                    min: 0.5,
                    max: 50.0,
                    divisions: 99,
                    onChanged: (value) => _updateWidth(value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 预设粗细标题
            Row(
              children: [
                Icon(
                  Icons.format_size,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  '预设粗细',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 预设粗细网格 - 可滚动
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _presetWidths.map((width) {
                    final isSelected = (_selectedWidth - width).abs() < 0.1;
                    return GestureDetector(
                      onTap: () => _updateWidth(width),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.1)
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: width * 2.5,
                              height: width * 2.5,
                              decoration: BoxDecoration(
                                color: widget.currentColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: widget.currentColor
                                          .withValues(alpha: 0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${width.toStringAsFixed(1)}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 底部按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, _selectedWidth),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('确定'),
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
