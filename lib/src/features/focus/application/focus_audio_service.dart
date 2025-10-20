import 'package:just_audio/just_audio.dart';

class FocusAudioService {
  FocusAudioService() {
    _player = AudioPlayer();
  }

  late final AudioPlayer _player;

  // 使用系统铃声作为完成提示音
  Future<void> playCompletionSound() async {
    try {
      // 播放系统通知音（简单的beep音）
      // 注意：这需要音频资源文件，这里使用系统音效
      await _player.setAsset('assets/sounds/completion.mp3').catchError((_) async {
        // 如果没有资源文件，使用音量来模拟提示音
        await _player.setVolume(0.5);
      });
      await _player.play();
    } catch (e) {
      // 静默失败 - 音频播放不是关键功能
      print('Failed to play completion sound: $e');
    }
  }

  Future<void> playTickSound() async {
    try {
      await _player.setVolume(0.3);
      // 使用短促的音效作为倒计时音
    } catch (e) {
      print('Failed to play tick sound: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
