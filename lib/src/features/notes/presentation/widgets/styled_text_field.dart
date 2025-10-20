import 'package:flutter/material.dart';

/// 支持第一行特殊样式的文本编辑器
class StyledTextField extends StatefulWidget {
  const StyledTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.minLines = 1,
    this.maxLines,
    this.autofocus = false,
    this.hintText,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final int? maxLines;
  final bool autofocus;
  final String? hintText;

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: widget.controller,
      onChanged: (text) {
        setState(() {}); // 触发重建以更新样式
        widget.onChanged?.call(text);
      },
      autofocus: widget.autofocus,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        height: 1.8,
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontSize: 14,
        ),
        // 使用 prefixIcon 来显示第一行的提示
        prefixIcon: widget.controller.text.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 0, top: 12),
                child: Text(
                  '标题',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
      ),
      // 使用自定义的 TextSpan 来控制文本样式
      strutStyle: StrutStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        height: 1.8,
        forceStrutHeight: false,
      ),
    );
  }
}

/// 自定义 TextEditingController 支持富文本样式
class StyledTextEditingController extends TextEditingController {
  StyledTextEditingController({String? text}) : super(text: text);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final theme = Theme.of(context);
    final text = this.text;

    if (text.isEmpty) {
      return TextSpan(text: '', style: style);
    }

    final lines = text.split('\n');
    final spans = <InlineSpan>[];

    for (int i = 0; i < lines.length; i++) {
      final isFirstLine = i == 0;
      final line = lines[i];

      // 第一行使用特殊样式(加大加粗)
      if (isFirstLine && line.isNotEmpty) {
        spans.add(TextSpan(
          text: line,
          style: (style ?? const TextStyle()).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            height: 1.5,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: line,
          style: style,
        ));
      }

      // 添加换行符(除了最后一行)
      if (i < lines.length - 1) {
        spans.add(TextSpan(
          text: '\n',
          style: style,
        ));
      }
    }

    return TextSpan(children: spans, style: style);
  }
}
