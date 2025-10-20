import 'dart:math';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/features/ai/domain/ai_message.dart';
import 'package:todolist/src/features/ai/domain/ai_service.dart';

/// 笔记AI增强服务
/// 提供智能摘要、标签推荐、相关笔记推荐、智能问答等功能
class NoteAIService {
  NoteAIService({
    required AIService aiService,
    required NoteRepository noteRepository,
  })  : _aiService = aiService,
        _noteRepository = noteRepository;

  final AIService _aiService;
  final NoteRepository _noteRepository;

  /// 生成笔记摘要
  ///
  /// [note] 要生成摘要的笔记
  /// [maxLength] 摘要最大长度,默认100字
  Future<String> generateSummary(Note note, {int maxLength = 100}) async {
    // 组合标题和内容
    final text = '标题:${note.title}\n\n${note.content}';
    return _aiService.generateSummary(
      text: text,
      maxLength: maxLength,
    );
  }

  /// 推荐标签
  ///
  /// [note] 要分析的笔记
  /// [count] 推荐的标签数量,默认5个
  Future<List<String>> suggestTags(Note note, {int count = 5}) async {
    // 组合标题、内容和现有标签作为上下文
    final context = '''
标题: ${note.title}
内容: ${note.content}
${note.tags.isNotEmpty ? '现有标签: ${note.tags.join(', ')}' : ''}
''';

    return _aiService.extractKeywords(
      text: context,
      count: count,
    );
  }

  /// 推荐相关笔记
  ///
  /// [note] 当前笔记
  /// [limit] 返回的笔记数量,默认5个
  ///
  /// 使用TF-IDF和余弦相似度算法计算笔记之间的相似性
  Future<List<Note>> recommendRelatedNotes(
    Note note, {
    int limit = 5,
  }) async {
    final allNotes = await _noteRepository.getAll();

    // 排除当前笔记和归档笔记
    final candidates = allNotes
        .where((n) => n.id != note.id && !n.isArchived)
        .toList();

    if (candidates.isEmpty) {
      return [];
    }

    // 计算相似度
    final similarities = <Note, double>{};
    for (final other in candidates) {
      final similarity = _calculateSimilarity(note, other);
      if (similarity > 0) {
        similarities[other] = similarity;
      }
    }

    // 按相似度排序并返回前N个
    final sorted = similarities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((e) => e.key).toList();
  }

  /// 智能问答
  ///
  /// [note] 笔记上下文
  /// [question] 用户问题
  Future<String> askAboutNote(Note note, String question) async {
    final response = await _aiService.chat(
      messages: [
        AIMessage.system('你是一个智能笔记助手，帮助用户理解和分析笔记内容。'),
        AIMessage.user('''
笔记信息：
标题: ${note.title}
分类: ${note.getCategoryName()}
创建时间: ${note.createdAt}
标签: ${note.tags.isEmpty ? '无' : note.tags.join(', ')}

笔记内容：
${note.content}

用户问题：
$question

请基于笔记内容回答用户的问题。如果笔记中没有相关信息，请诚实地说明，不要编造内容。
'''),
      ],
      temperature: 0.7,
      maxTokens: 500,
    );

    return response.content.trim();
  }

  /// 批量生成摘要
  ///
  /// [notes] 笔记列表
  /// [maxLength] 每个摘要的最大长度
  Future<Map<String, String>> batchGenerateSummaries(
    List<Note> notes, {
    int maxLength = 100,
  }) async {
    final summaries = <String, String>{};

    for (final note in notes) {
      try {
        final summary = await generateSummary(note, maxLength: maxLength);
        summaries[note.id] = summary;
      } catch (e) {
        // 失败时跳过,继续处理其他笔记
        continue;
      }
    }

    return summaries;
  }

  /// 计算两个笔记之间的相似度 (0-100)
  ///
  /// 使用简化的TF-IDF方法:
  /// 1. 标题匹配权重高
  /// 2. 共同标签加分
  /// 3. 内容词频相似度
  /// 4. 同分类加分
  double _calculateSimilarity(Note note1, Note note2) {
    var score = 0.0;

    // 1. 标题相似度 (权重40%)
    final titleSimilarity = _textSimilarity(
      note1.title.toLowerCase(),
      note2.title.toLowerCase(),
    );
    score += titleSimilarity * 40;

    // 2. 共同标签 (权重30%)
    if (note1.tags.isNotEmpty && note2.tags.isNotEmpty) {
      final commonTags = note1.tags
          .where((tag) => note2.tags.contains(tag))
          .length;
      final maxTags = max(note1.tags.length, note2.tags.length);
      final tagSimilarity = commonTags / maxTags;
      score += tagSimilarity * 30;
    }

    // 3. 内容相似度 (权重20%)
    final contentSimilarity = _textSimilarity(
      note1.content.toLowerCase(),
      note2.content.toLowerCase(),
    );
    score += contentSimilarity * 20;

    // 4. 同分类加分 (权重10%)
    if (note1.category == note2.category) {
      score += 10;
    }

    return score.clamp(0, 100);
  }

  /// 计算两段文本的相似度 (0-1)
  /// 使用简单的词频重叠方法
  double _textSimilarity(String text1, String text2) {
    if (text1.isEmpty || text2.isEmpty) return 0;

    // 分词 (简单按空格和标点分割)
    final words1 = _tokenize(text1);
    final words2 = _tokenize(text2);

    if (words1.isEmpty || words2.isEmpty) return 0;

    // 计算词频
    final freq1 = _wordFrequency(words1);
    final freq2 = _wordFrequency(words2);

    // 计算余弦相似度
    return _cosineSimilarity(freq1, freq2);
  }

  /// 简单分词
  List<String> _tokenize(String text) {
    // 移除标点,分割成词
    return text
        .replaceAll(RegExp(r'[^\w\s\u4e00-\u9fa5]'), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.length >= 2) // 过滤掉单字
        .toList();
  }

  /// 计算词频
  Map<String, int> _wordFrequency(List<String> words) {
    final freq = <String, int>{};
    for (final word in words) {
      freq[word] = (freq[word] ?? 0) + 1;
    }
    return freq;
  }

  /// 余弦相似度
  double _cosineSimilarity(
    Map<String, int> freq1,
    Map<String, int> freq2,
  ) {
    // 获取所有词的并集
    final allWords = {...freq1.keys, ...freq2.keys};
    if (allWords.isEmpty) return 0;

    var dotProduct = 0.0;
    var norm1 = 0.0;
    var norm2 = 0.0;

    for (final word in allWords) {
      final f1 = freq1[word] ?? 0;
      final f2 = freq2[word] ?? 0;

      dotProduct += f1 * f2;
      norm1 += f1 * f1;
      norm2 += f2 * f2;
    }

    if (norm1 == 0 || norm2 == 0) return 0;

    return dotProduct / (sqrt(norm1) * sqrt(norm2));
  }
}
