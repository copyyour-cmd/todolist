import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

/// 录音对话框
class AudioRecorderDialog extends StatefulWidget {
  const AudioRecorderDialog({super.key});

  @override
  State<AudioRecorderDialog> createState() => _AudioRecorderDialogState();
}

class _AudioRecorderDialogState extends State<AudioRecorderDialog> {
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();

  RecordState _recordState = RecordState.stop;
  String? _recordedFilePath;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('需要麦克风权限才能录音')),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final appDir = await getApplicationDocumentsDirectory();
        final audioDir = Directory('${appDir.path}/audio_notes');
        if (!await audioDir.exists()) {
          await audioDir.create(recursive: true);
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = '${audioDir.path}/audio_$timestamp.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: filePath,
        );

        setState(() {
          _recordState = RecordState.record;
          _recordDuration = Duration.zero;
        });

        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('录音失败: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _timer?.cancel();

      setState(() {
        _recordState = RecordState.stop;
        _recordedFilePath = path;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('停止录音失败: $e')),
        );
      }
    }
  }

  Future<void> _pauseRecording() async {
    try {
      await _audioRecorder.pause();
      _timer?.cancel();
      setState(() {
        _recordState = RecordState.pause;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('暂停录音失败: $e')),
        );
      }
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _audioRecorder.resume();
      _startTimer();
      setState(() {
        _recordState = RecordState.record;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('恢复录音失败: $e')),
        );
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration += const Duration(seconds: 1);
      });
    });
  }

  Future<void> _playAudio() async {
    if (_recordedFilePath == null) return;

    try {
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      setState(() {
        _isPlaying = true;
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
        });
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('播放失败: $e')),
        );
      }
    }
  }

  Future<void> _stopPlaying() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        width: size.width * 0.9,
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: size.height * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题 - 紧凑版
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.mic_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '录音',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 可滚动的内容区域
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 录音时长显示 - 精简版
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _recordState == RecordState.record
                              ? [
                                  const Color(0xFFEF4444).withOpacity(0.15),
                                  const Color(0xFFDC2626).withOpacity(0.08),
                                ]
                              : [
                                  Colors.grey.withOpacity(0.08),
                                  Colors.grey.withOpacity(0.03),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _recordState == RecordState.record
                              ? const Color(0xFFEF4444).withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_recordState == RecordState.record
                                    ? const Color(0xFFEF4444)
                                    : Colors.grey)
                                .withOpacity(0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 波形动画或状态图标 - 缩小版
                          if (_recordState == RecordState.record)
                            SizedBox(
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(7, (index) => _buildWaveBar(index)),
                              ),
                            )
                          else
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: _recordedFilePath != null
                                      ? [Colors.green, Colors.green.shade700]
                                      : [Colors.grey.shade300, Colors.grey.shade400],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (_recordedFilePath != null ? Colors.green : Colors.grey)
                                        .withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _recordedFilePath != null
                                    ? Icons.check_circle_rounded
                                    : Icons.mic_none_rounded,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            _formatDuration(_recordDuration),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: _recordState == RecordState.record
                                  ? const Color(0xFFEF4444)
                                  : theme.colorScheme.primary,
                              fontFeatures: const [FontFeature.tabularFigures()],
                              height: 1.0,
                              letterSpacing: -1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: (_recordState == RecordState.record
                                      ? const Color(0xFFEF4444)
                                      : Colors.grey)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _recordState == RecordState.record
                                  ? '🎙️ 录音中...'
                                  : _recordState == RecordState.pause
                                      ? '⏸️ 已暂停'
                                      : _recordedFilePath != null
                                          ? '✅ 录音完成'
                                          : '💡 点击开始录音',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _recordState == RecordState.record
                                    ? const Color(0xFFEF4444)
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 控制按钮 - 精简版
                    if (_recordedFilePath == null) ...[
                      // 录音控制
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_recordState == RecordState.record) ...[
                            // 暂停按钮
                            _buildControlButton(
                              icon: Icons.pause_rounded,
                              label: '暂停',
                              color: Colors.orange,
                              onTap: _pauseRecording,
                            ),
                            const SizedBox(width: 12),
                            // 停止按钮
                            _buildControlButton(
                              icon: Icons.stop_rounded,
                              label: '停止',
                              color: Colors.red,
                              onTap: _stopRecording,
                            ),
                          ] else if (_recordState == RecordState.pause) ...[
                            // 继续按钮
                            _buildControlButton(
                              icon: Icons.play_arrow_rounded,
                              label: '继续',
                              color: Colors.green,
                              onTap: _resumeRecording,
                            ),
                            const SizedBox(width: 12),
                            // 停止按钮
                            _buildControlButton(
                              icon: Icons.stop_rounded,
                              label: '停止',
                              color: Colors.red,
                              onTap: _stopRecording,
                            ),
                          ] else ...[
                            // 开始录音按钮
                            _buildControlButton(
                              icon: Icons.fiber_manual_record_rounded,
                              label: '开始录音',
                              color: Colors.red,
                              onTap: _startRecording,
                              large: true,
                            ),
                          ],
                        ],
                      ),
                    ] else ...[
                      // 播放和保存控制
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 重新录制
                          _buildControlButton(
                            icon: Icons.refresh_rounded,
                            label: '重录',
                            color: Colors.grey,
                            onTap: () {
                              setState(() {
                                _recordedFilePath = null;
                                _recordDuration = Duration.zero;
                              });
                            },
                          ),
                          const SizedBox(width: 12),
                          // 播放/停止
                          _buildControlButton(
                            icon: _isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                            label: _isPlaying ? '停止' : '试听',
                            color: Colors.blue,
                            onTap: _isPlaying ? _stopPlaying : _playAudio,
                          ),
                          const SizedBox(width: 12),
                          // 保存
                          _buildControlButton(
                            icon: Icons.check_rounded,
                            label: '保存',
                            color: Colors.green,
                            onTap: () => Navigator.pop(context, _recordedFilePath),
                            large: true,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveBar(int index) {
    // 创建更自然的波动高度
    final baseHeight = 15.0;
    final heights = [25.0, 45.0, 60.0, 50.0, 35.0, 45.0, 30.0];
    final targetHeight = baseHeight + heights[index % heights.length];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: baseHeight, end: targetHeight),
      duration: Duration(milliseconds: 400 + index * 80),
      curve: Curves.easeInOut,
      builder: (context, height, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 5,
          height: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        );
      },
      onEnd: () {
        // 循环动画
        if (_recordState == RecordState.record && mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool large = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(large ? 18 : 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                      spreadRadius: -3,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: large ? 28 : 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
