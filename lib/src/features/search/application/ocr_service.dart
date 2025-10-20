import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// OCR文字识别服务
/// 用于从图片中提取文本,支持搜索
///
/// 注意: OCR功能需要添加 google_mlkit_text_recognition 依赖
/// 当前版本暂时禁用,待网络环境稳定后启用
class OcrService {
  OcrService() {
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);
  }

  late final TextRecognizer _textRecognizer;

  /// 从图片文件中识别文字
  Future<String> recognizeTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      print('OCR识别失败: $e');
      return '';
    }
  }

  /// 从多个图片中批量识别文字
  Future<Map<String, String>> recognizeTextFromImages(
    List<String> imagePaths,
  ) async {
    final results = <String, String>{};

    for (final path in imagePaths) {
      final text = await recognizeTextFromImage(path);
      if (text.isNotEmpty) {
        results[path] = text;
      }
    }

    return results;
  }

  /// 检查图片是否包含文字
  Future<bool> hasText(String imagePath) async {
    final text = await recognizeTextFromImage(imagePath);
    return text.trim().isNotEmpty;
  }

  /// 释放资源
  void dispose() {
    _textRecognizer.close();
  }
}

final ocrServiceProvider = Provider<OcrService>((ref) {
  final service = OcrService();
  ref.onDispose(() => service.dispose());
  return service;
});
