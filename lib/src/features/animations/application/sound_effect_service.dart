import 'package:flutter/services.dart';

/// 音效服务接口
///
/// 提供任务完成、连击等事件的音效播放功能
/// 当前为预留接口,未来可以接入音频播放库
abstract class SoundEffectService {
  /// 播放任务完成音效
  Future<void> playCompletionSound();

  /// 播放连击音效
  Future<void> playComboSound(int comboCount);

  /// 播放成就解锁音效
  Future<void> playAchievementSound();

  /// 设置音效音量 (0.0 - 1.0)
  Future<void> setVolume(double volume);

  /// 启用/禁用音效
  Future<void> setEnabled(bool enabled);

  /// 释放资源
  Future<void> dispose();
}

/// 音效服务的默认实现（空实现）
///
/// 可以替换为使用 audioplayers 或 just_audio 的实现
class DefaultSoundEffectService implements SoundEffectService {
  bool _enabled = true;
  double _volume = 0.7;

  @override
  Future<void> playCompletionSound() async {
    if (!_enabled) return;

    // TODO: 实现音效播放
    // 可选方案：
    // 1. 使用 audioplayers 包
    // 2. 使用 just_audio 包
    // 3. 使用系统音效 SystemSound.play()

    // 临时使用系统反馈
    await HapticFeedback.mediumImpact();
  }

  @override
  Future<void> playComboSound(int comboCount) async {
    if (!_enabled) return;

    // 根据连击数播放不同音效
    if (comboCount >= 10) {
      // 高连击音效
      await HapticFeedback.heavyImpact();
    } else if (comboCount >= 5) {
      // 中连击音效
      await HapticFeedback.mediumImpact();
    } else {
      // 低连击音效
      await HapticFeedback.lightImpact();
    }
  }

  @override
  Future<void> playAchievementSound() async {
    if (!_enabled) return;

    // 成就解锁音效
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
  }

  @override
  Future<void> dispose() async {
    // 释放音频资源
  }
}
