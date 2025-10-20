import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/attachments/application/attachment_providers.dart';

class AudioRecorderDialog extends ConsumerStatefulWidget {
  const AudioRecorderDialog({super.key});

  @override
  ConsumerState<AudioRecorderDialog> createState() => _AudioRecorderDialogState();
}

class _AudioRecorderDialogState extends ConsumerState<AudioRecorderDialog> {
  bool _isRecording = false;
  int _recordingSeconds = 0;
  Stream<int>? _timerStream;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Record Audio'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isRecording ? Icons.mic : Icons.mic_none,
            size: 64,
            color: _isRecording ? theme.colorScheme.error : theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            _formatDuration(_recordingSeconds),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_isRecording) {
              await ref.read(attachmentServiceProvider).cancelRecording();
            }
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (_isRecording) {
              // Stop recording
              final attachment = await ref.read(attachmentServiceProvider).stopRecording();
              if (mounted) {
                Navigator.of(context).pop(attachment);
              }
            } else {
              // Start recording
              final started = await ref.read(attachmentServiceProvider).startRecording();
              if (started) {
                setState(() {
                  _isRecording = true;
                  _recordingSeconds = 0;
                });
                _startTimer();
              }
            }
          },
          child: Text(_isRecording ? 'Stop' : 'Start'),
        ),
      ],
    );
  }

  void _startTimer() {
    _timerStream = Stream.periodic(const Duration(seconds: 1), (count) => count + 1);
    _timerStream!.listen((seconds) {
      if (mounted) {
        setState(() {
          _recordingSeconds = seconds;
        });
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timerStream = null;
    super.dispose();
  }
}
