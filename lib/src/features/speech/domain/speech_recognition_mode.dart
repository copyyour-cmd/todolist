import 'package:flutter/material.dart';

/// 语音识别模式
enum SpeechRecognitionMode {
  /// 在线模式（需要网络，识别准确）
  online,

  /// 离线模式（本地识别，速度快）
  offline,

  /// 自动模式（根据网络状态自动切换）
  auto;

  String get displayName {
    switch (this) {
      case SpeechRecognitionMode.online:
        return '在线模式';
      case SpeechRecognitionMode.offline:
        return '离线模式';
      case SpeechRecognitionMode.auto:
        return '自动模式';
    }
  }

  String get description {
    switch (this) {
      case SpeechRecognitionMode.online:
        return '使用云端识别，需要网络连接，识别准确率高';
      case SpeechRecognitionMode.offline:
        return '使用设备本地识别，无需网络，速度更快';
      case SpeechRecognitionMode.auto:
        return '根据网络状态自动选择最佳模式';
    }
  }

  IconData get icon {
    switch (this) {
      case SpeechRecognitionMode.online:
        return Icons.cloud;
      case SpeechRecognitionMode.offline:
        return Icons.phone_android;
      case SpeechRecognitionMode.auto:
        return Icons.auto_awesome;
    }
  }
}
