import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/features/search/application/ocr_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// 笔记OCR文字提取服务
/// 自动从笔记中的图片提取文字用于搜索
class NoteOcrService {
  NoteOcrService({
    required OcrService ocrService,
    required NoteRepository noteRepository,
  })  : _ocrService = ocrService,
        _noteRepository = noteRepository;

  final OcrService _ocrService;
  final NoteRepository _noteRepository;

  /// 为笔记的所有图片提取OCR文本
  Future<Note> extractOcrText(Note note) async {
    if (note.imageUrls.isEmpty) {
      // 没有图片,清空OCR文本
      if (note.ocrText != null) {
        return note.copyWith(ocrText: '');
      }
      return note;
    }

    try {
      // 提取所有图片的文字
      final ocrTexts = <String>[];
      for (final imagePath in note.imageUrls) {
        final text = await _ocrService.recognizeTextFromImage(imagePath);
        if (text.isNotEmpty) {
          ocrTexts.add(text);
        }
      }

      // 合并所有OCR文本
      final combinedOcrText = ocrTexts.join('\n');

      // 如果OCR文本没有变化,不需要更新
      if (note.ocrText == combinedOcrText) {
        return note;
      }

      // 更新笔记的OCR文本
      final updated = note.copyWith(ocrText: combinedOcrText);
      await _noteRepository.save(updated);

      return updated;
    } catch (e) {
      print('提取OCR文本失败: $e');
      return note;
    }
  }

  /// 批量提取所有笔记的OCR文本
  /// 用于初始化或重新索引
  Future<void> extractAllNotesOcr() async {
    try {
      final allNotes = await _noteRepository.getAll();
      final notesWithImages = allNotes.where((note) => note.hasImages).toList();

      for (final note in notesWithImages) {
        await extractOcrText(note);
      }
    } catch (e) {
      print('批量OCR提取失败: $e');
    }
  }

  /// 检查笔记是否需要OCR处理
  bool needsOcrProcessing(Note note) {
    // 有图片但没有OCR文本时需要处理
    return note.hasImages && (note.ocrText == null || note.ocrText!.isEmpty);
  }
}

final noteOcrServiceProvider = Provider<NoteOcrService>((ref) {
  final ocrService = ref.watch(ocrServiceProvider);
  final noteRepository = ref.watch(noteRepositoryProvider);

  return NoteOcrService(
    ocrService: ocrService,
    noteRepository: noteRepository,
  );
});
