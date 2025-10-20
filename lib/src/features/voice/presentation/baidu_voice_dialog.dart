import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/voice/application/baidu_voice_providers.dart';

/// 百度语音输入对话框
class BaiduVoiceDialog extends ConsumerStatefulWidget {
  const BaiduVoiceDialog({super.key});

  /// 显示语音输入对话框
  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const BaiduVoiceDialog(),
    );
  }

  @override
  ConsumerState<BaiduVoiceDialog> createState() => _BaiduVoiceDialogState();
}

class _BaiduVoiceDialogState extends ConsumerState<BaiduVoiceDialog>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _isProcessing = false;
  String _recognizedText = '';
  String? _errorMessage;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // 如果正在录音，取消录音
    if (_isRecording) {
      ref.read(baiduVoiceServiceProvider).cancelRecording();
    }
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isProcessing) return;

    final service = ref.read(baiduVoiceServiceProvider);

    if (_isRecording) {
      // 停止录音并识别
      setState(() {
        _isRecording = false;
        _isProcessing = true;
        _errorMessage = null;
      });

      try {
        final result = await service.stopRecordingAndRecognize();

        if (mounted) {
          if (result != null && result.isNotEmpty) {
            setState(() {
              _recognizedText = result;
              _isProcessing = false;
            });
          } else {
            setState(() {
              _errorMessage =
                  '未识别到语音内容\n'
                  '• 请靠近麦克风说话\n'
                  '• 说话时间至少2-3秒\n'
                  '• 避免环境噪音干扰';
              _isProcessing = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = '识别出错: $e';
            _isProcessing = false;
          });
        }
      }
    } else {
      // 开始录音
      final started = await service.startRecording();

      if (mounted) {
        if (started) {
          setState(() {
            _isRecording = true;
            _recognizedText = '';
            _errorMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = '无法启动录音，请检查麦克风权限';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('语音输入'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 麦克风图标和动画
          GestureDetector(
            onTap: _toggleRecording,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 外层脉冲波纹（仅录音时显示）
                if (_isRecording) ...[
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_animationController.value * 0.3),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withOpacity(
                              0.15 * (1 - _animationController.value),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final delayedValue =
                          (_animationController.value + 0.3) % 1.0;
                      return Transform.scale(
                        scale: 1.0 + (delayedValue * 0.3),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withOpacity(
                              0.1 * (1 - delayedValue),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],

                // 中心麦克风按钮
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording
                        ? theme.colorScheme.primary.withOpacity(0.2)
                        : theme.colorScheme.surfaceContainerHighest,
                    boxShadow: _isRecording
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: _isProcessing
                      ? SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: theme.colorScheme.primary,
                          ),
                        )
                      : AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            // 录音时有轻微缩放脉冲
                            final scale = _isRecording
                                ? 1.0 +
                                      (0.1 *
                                          (0.5 +
                                              0.5 *
                                                  (1 -
                                                      (_animationController
                                                                      .value -
                                                                  0.5)
                                                              .abs() *
                                                          2)))
                                : 1.0;

                            return Transform.scale(
                              scale: scale,
                              child: Icon(
                                Icons.mic,
                                size: 64,
                                color: _isRecording
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 状态文本
          if (_isProcessing)
            Text(
              '正在识别...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else if (_isRecording)
            Column(
              children: [
                Text(
                  '正在聆听，点击停止...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '请清晰说话至少2-3秒',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  '点击麦克风开始录音',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '建议靠近麦克风，清晰发音',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // 识别结果
          if (_recognizedText.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _recognizedText,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),

          // 错误信息
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _recognizedText.isEmpty
              ? null
              : () {
                  Navigator.of(context).pop(_recognizedText);
                },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
