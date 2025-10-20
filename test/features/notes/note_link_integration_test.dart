import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/features/notes/data/note_link_service.dart';
import 'package:todolist/src/features/notes/domain/note_link_parser.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([NoteRepository])
import 'note_link_integration_test.mocks.dart';

/// 笔记链接功能集成测试
/// 测试 [[笔记标题]] 链接的完整流程
void main() {
  group('笔记链接功能集成测试', () {
    late MockNoteRepository mockRepository;
    late NoteLinkService linkService;
    late Note noteA;
    late Note noteB;
    late Note noteC;

    setUp(() {
      mockRepository = MockNoteRepository();
      linkService = NoteLinkService(noteRepository: mockRepository);

      // 创建测试笔记
      noteA = Note(
        id: 'note-a',
        title: '笔记A',
        content: '这是第一个测试笔记\n用于测试笔记链接功能',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        linkedNoteIds: [],
      );

      noteB = Note(
        id: 'note-b',
        title: '笔记B',
        content: '这是第二个笔记\n\n这里引用了 [[笔记A]]\n\n点击上面的链接应该可以跳转！',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        linkedNoteIds: [],
      );

      noteC = Note(
        id: 'note-c',
        title: '笔记C',
        content: '这里同时链接两个笔记：\n- [[笔记A]]\n- [[笔记B]]',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        linkedNoteIds: [],
      );
    });

    test('1. NoteLinkParser 应该能够正确解析 [[笔记标题]] 语法', () {
      // 测试笔记B的链接解析
      final links = NoteLinkParser.parseLinks(noteB.content);

      expect(links.length, 1);
      expect(links[0].title, '笔记A');
      expect(links[0].linkText, '[[笔记A]]');
    });

    test('2. NoteLinkParser 应该能够提取所有链接的标题', () {
      // 测试笔记C（包含两个链接）
      final titles = NoteLinkParser.extractLinkedTitles(noteC.content);

      expect(titles.length, 2);
      expect(titles, contains('笔记A'));
      expect(titles, contains('笔记B'));
    });

    test('3. NoteLinkParser 应该能够将 [[标题]] 转换为 Markdown 链接', () {
      final titleToIdMap = {
        '笔记A': 'note-a',
        '笔记B': 'note-b',
      };

      final convertedContent = NoteLinkParser.convertToMarkdownLinks(
        noteC.content,
        titleToIdMap,
      );

      // 应该包含转换后的 Markdown 链接
      expect(convertedContent, contains('[笔记A](note://note-a)'));
      expect(convertedContent, contains('[笔记B](note://note-b)'));

      // 不应该再包含原始的 [[]] 语法
      expect(convertedContent, isNot(contains('[[笔记A]]')));
      expect(convertedContent, isNot(contains('[[笔记B]]')));
    });

    test('4. NoteLinkService 应该能够构建标题到ID的映射', () async {
      // Mock repository
      when(mockRepository.getAll()).thenAnswer((_) async => [noteA, noteB, noteC]);

      final titleToIdMap = await linkService.buildTitleToIdMap();

      expect(titleToIdMap['笔记A'], 'note-a');
      expect(titleToIdMap['笔记B'], 'note-b');
      expect(titleToIdMap['笔记C'], 'note-c');
    });

    test('5. NoteLinkService 应该能够从笔记内容中提取链接关系', () async {
      // Mock repository
      when(mockRepository.getAll()).thenAnswer((_) async => [noteA, noteB, noteC]);

      final relations = await linkService.extractLinks(noteB);

      expect(relations.length, 1);
      expect(relations[0].sourceNoteId, 'note-b');
      expect(relations[0].targetNoteId, 'note-a');
      expect(relations[0].targetTitle, '笔记A');
    });

    test('6. NoteLinkService 应该能够更新笔记的链接关系', () async {
      // Mock repository
      when(mockRepository.getAll()).thenAnswer((_) async => [noteA, noteB, noteC]);
      when(mockRepository.save(any)).thenAnswer((_) async {});

      final updatedNote = await linkService.updateNoteLinks(noteB);

      expect(updatedNote.linkedNoteIds.length, 1);
      expect(updatedNote.linkedNoteIds, contains('note-a'));

      verify(mockRepository.save(any)).called(1);
    });

    test('7. NoteLinkService 应该能够获取反向链接（backlinks）', () async {
      // 先更新笔记B的链接
      final updatedNoteB = noteB.copyWith(linkedNoteIds: ['note-a']);

      // Mock repository
      when(mockRepository.getById('note-a')).thenAnswer((_) async => noteA);
      when(mockRepository.getAll()).thenAnswer((_) async => [noteA, updatedNoteB, noteC]);

      final backlinks = await linkService.getBacklinks('note-a');

      // 笔记B链接到了笔记A，所以笔记A的反向链接应该包含笔记B
      expect(backlinks.length, greaterThanOrEqualTo(1));
      expect(backlinks.any((note) => note.id == 'note-b'), true);
    });

    test('8. NoteLinkService 应该能够获取正向链接（outbound links）', () async {
      // 先更新笔记B的链接
      final updatedNoteB = noteB.copyWith(linkedNoteIds: ['note-a']);

      // Mock repository
      when(mockRepository.getById('note-b')).thenAnswer((_) async => updatedNoteB);
      when(mockRepository.getById('note-a')).thenAnswer((_) async => noteA);

      final outboundLinks = await linkService.getOutboundLinks('note-b');

      // 笔记B的正向链接应该包含笔记A
      expect(outboundLinks.length, 1);
      expect(outboundLinks[0].id, 'note-a');
    });

    test('9. NoteLinkService 应该能够获取链接统计信息', () async {
      // 准备数据：笔记B链接到笔记A，笔记C也链接到笔记A
      final updatedNoteB = noteB.copyWith(linkedNoteIds: ['note-a']);
      final updatedNoteC = noteC.copyWith(linkedNoteIds: ['note-a', 'note-b']);

      // Mock repository
      when(mockRepository.getById('note-a')).thenAnswer((_) async => noteA);
      when(mockRepository.getAll()).thenAnswer(
        (_) async => [noteA, updatedNoteB, updatedNoteC],
      );

      final stats = await linkService.getLinkStats('note-a');

      // 笔记A没有正向链接（它不链接任何笔记）
      expect(stats.outboundLinks.length, 0);

      // 笔记A有反向链接（笔记B和笔记C链接到它）
      expect(stats.backlinks.length, greaterThanOrEqualTo(2));
      expect(stats.hasLinks, true);
    });

    test('10. NoteLinkParser 应该能够处理标题变更时的链接替换', () {
      const oldContent = '这里引用了 [[旧标题]]\n还有 [[其他笔记]]';

      final newContent = NoteLinkParser.replaceLinkTitle(
        oldContent,
        '旧标题',
        '新标题',
      );

      expect(newContent, contains('[[新标题]]'));
      expect(newContent, isNot(contains('[[旧标题]]')));
      expect(newContent, contains('[[其他笔记]]')); // 其他链接不受影响
    });

    test('11. NoteLinkService 应该能够在标题变更时更新所有引用', () async {
      // 笔记B引用了笔记A
      final updatedNoteB = noteB.copyWith(linkedNoteIds: ['note-a']);

      // Mock repository
      when(mockRepository.getById('note-a')).thenAnswer((_) async => noteA);
      when(mockRepository.getAll()).thenAnswer((_) async => [noteA, updatedNoteB]);
      when(mockRepository.save(any)).thenAnswer((_) async {});

      // 模拟笔记A的标题从"笔记A"改为"笔记A新标题"
      await linkService.updateReferencesOnTitleChange(
        'note-a',
        '笔记A',
        '笔记A新标题',
      );

      // 验证保存被调用（笔记B的内容应该被更新）
      verify(mockRepository.save(any)).called(greaterThanOrEqualTo(1));
    });

    test('12. NoteLinkService 应该能够在笔记删除时清理链接', () async {
      // 笔记B引用了笔记A
      final updatedNoteB = noteB.copyWith(linkedNoteIds: ['note-a']);

      // Mock repository
      when(mockRepository.getAll()).thenAnswer((_) async => [updatedNoteB]);
      when(mockRepository.save(any)).thenAnswer((_) async {});

      // 删除笔记A时清理引用
      await linkService.cleanupLinksOnDelete('note-a', '笔记A');

      // 验证保存被调用（笔记B应该被更新以移除对笔记A的引用）
      verify(mockRepository.save(any)).called(greaterThanOrEqualTo(1));
    });

    test('13. NoteLinkParser 应该能够检测内容中是否包含特定标题的链接', () {
      const content = '这里引用了 [[笔记A]]\n还有 [[笔记B]]';

      expect(NoteLinkParser.containsLinkTo(content, '笔记A'), true);
      expect(NoteLinkParser.containsLinkTo(content, '笔记B'), true);
      expect(NoteLinkParser.containsLinkTo(content, '笔记C'), false);
    });

    test('14. NoteLinkParser 应该能够移除特定标题的链接', () {
      const content = '这里引用了 [[笔记A]]\n还有 [[笔记B]]';

      final newContent = NoteLinkParser.removeLinksTo(content, '笔记A');

      expect(newContent, isNot(contains('[[笔记A]]')));
      expect(newContent, contains('[[笔记B]]')); // 其他链接保留
    });

    test('15. NoteLinkService 应该能够搜索可链接的笔记', () async {
      // Mock repository
      when(mockRepository.getAll()).thenAnswer((_) async => [noteA, noteB, noteC]);

      // 搜索包含"笔记"的笔记
      final results = await linkService.searchLinkableNotes('笔记');
      expect(results.length, 3);

      // 搜索"笔记A"
      final resultsA = await linkService.searchLinkableNotes('笔记A');
      expect(resultsA.length, 1);
      expect(resultsA[0].id, 'note-a');

      // 搜索时排除当前笔记
      final resultsExclude = await linkService.searchLinkableNotes(
        '笔记',
        excludeNoteId: 'note-b',
      );
      expect(resultsExclude.any((note) => note.id == 'note-b'), false);
    });

    test('16. 完整流程：创建笔记、添加链接、获取反向链接', () async {
      // 模拟完整的用户使用流程

      // 1. 用户创建笔记A和笔记B
      when(mockRepository.getAll()).thenAnswer((_) async => [noteA, noteB]);
      when(mockRepository.save(any)).thenAnswer((_) async {});

      // 2. 用户在笔记B中输入 [[笔记A]]，系统自动更新链接
      final updatedNoteB = await linkService.updateNoteLinks(noteB);
      expect(updatedNoteB.linkedNoteIds, contains('note-a'));

      // 3. 用户查看笔记A，应该能看到笔记B在反向链接中
      final updatedNoteBWithLinks = noteB.copyWith(linkedNoteIds: ['note-a']);
      when(mockRepository.getById('note-a')).thenAnswer((_) async => noteA);
      when(mockRepository.getAll()).thenAnswer(
        (_) async => [noteA, updatedNoteBWithLinks],
      );

      final stats = await linkService.getLinkStats('note-a');
      expect(stats.hasLinks, true);
      expect(stats.backlinks.any((note) => note.id == 'note-b'), true);
    });
  });

  group('NoteLinkParser 边界情况测试', () {
    test('应该正确处理空内容', () {
      final links = NoteLinkParser.parseLinks('');
      expect(links, isEmpty);
    });

    test('应该正确处理没有链接的内容', () {
      const content = '这是一段普通文本，没有任何链接';
      final links = NoteLinkParser.parseLinks(content);
      expect(links, isEmpty);
    });

    test('应该正确处理不完整的链接语法', () {
      const content = '这里有不完整的语法：[[没有闭合\n还有 [单个括号]';
      final links = NoteLinkParser.parseLinks(content);
      expect(links, isEmpty);
    });

    test('应该正确处理重复的链接', () {
      const content = '多次引用 [[笔记A]]，这里又是 [[笔记A]]';
      final titles = NoteLinkParser.extractLinkedTitles(content);
      expect(titles.length, 1); // 应该去重
      expect(titles.contains('笔记A'), true);
    });

    test('应该正确处理多行链接', () {
      const content = '''
      第一行有 [[笔记A]]
      第二行有 [[笔记B]]
      第三行有 [[笔记C]]
      ''';
      final titles = NoteLinkParser.extractLinkedTitles(content);
      expect(titles.length, 3);
    });

    test('应该正确处理特殊字符的标题', () {
      const content = '引用特殊标题 [[包含-符号和_下划线的笔记]]';
      final links = NoteLinkParser.parseLinks(content);
      expect(links.length, 1);
      expect(links[0].title, '包含-符号和_下划线的笔记');
    });
  });
}
