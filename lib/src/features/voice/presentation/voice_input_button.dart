import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/voice/application/voice_input_providers.dart';

/// Voice input button widget
/// Shows a microphone button that opens voice input dialog when pressed
class VoiceInputButton extends ConsumerWidget {
  const VoiceInputButton({
    required this.onTextRecognized, super.key,
    this.size,
  });

  final Function(String) onTextRecognized;
  final double? size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        print('VoiceInputButton: Button pressed'); // Debug log
        try {
          final result = await showDialog<String>(
            context: context,
            builder: (context) {
              print('VoiceInputButton: Showing dialog'); // Debug log
              return const VoiceInputDialog();
            },
          );

          print('VoiceInputButton: Dialog result: $result'); // Debug log
          if (result != null && result.isNotEmpty) {
            onTextRecognized(result);
          }
        } catch (e, st) {
          print('VoiceInputButton: Error: $e'); // Debug log
          print('VoiceInputButton: Stack: $st'); // Debug log
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: Icon(
          Icons.mic,
          size: size ?? 24,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// Voice input dialog
class VoiceInputDialog extends ConsumerStatefulWidget {
  const VoiceInputDialog({super.key});

  @override
  ConsumerState<VoiceInputDialog> createState() => _VoiceInputDialogState();
}

class _VoiceInputDialogState extends ConsumerState<VoiceInputDialog>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _recognizedText = '';
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
    if (_isListening) {
      ref.read(voiceInputServiceProvider).stopListening();
    }
    super.dispose();
  }

  Future<void> _toggleListening() async {
    final service = ref.read(voiceInputServiceProvider);

    if (_isListening) {
      await service.stopListening();
      setState(() {
        _isListening = false;
      });
    } else {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('正在初始化语音识别...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      final started = await service.startListening(
        onResult: (text) {
          setState(() {
            _recognizedText = text;
          });
        },
      );

      if (started) {
        setState(() {
          _isListening = true;
          _recognizedText = '';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('开始聆听，请说话...'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('语音识别不可用，请检查麦克风权限'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
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
          // Microphone icon with animation
          GestureDetector(
            onTap: _toggleListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.surfaceContainerHighest,
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Icon(
                    Icons.mic,
                    size: 64,
                    color: _isListening
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Status text
          Text(
            _isListening ? '正在聆听...' : '点击麦克风开始',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Recognized text
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
