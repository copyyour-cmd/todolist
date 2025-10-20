/// 笔记链接信息
class NoteLinkInfo {
  const NoteLinkInfo({
    required this.title,
    required this.startIndex,
    required this.endIndex,
  });

  final String title; // 被链接的笔记标题
  final int startIndex; // 在文本中的起始位置
  final int endIndex; // 在文本中的结束位置

  /// 获取完整的链接文本 [[title]]
  String get linkText => '[[$title]]';

  @override
  String toString() => 'NoteLinkInfo(title: $title, range: $startIndex-$endIndex)';
}

/// 笔记链接解析器
/// 用于解析 Markdown 内容中的 [[笔记名]] 语法
class NoteLinkParser {
  /// Wiki风格链接的正则表达式: [[笔记名]]
  static final RegExp _linkPattern = RegExp(r'\[\[([^\]]+)\]\]');

  /// 从文本中提取所有笔记链接
  static List<NoteLinkInfo> parseLinks(String content) {
    final links = <NoteLinkInfo>[];
    final matches = _linkPattern.allMatches(content);

    for (final match in matches) {
      final title = match.group(1)?.trim();
      if (title != null && title.isNotEmpty) {
        links.add(
          NoteLinkInfo(
            title: title,
            startIndex: match.start,
            endIndex: match.end,
          ),
        );
      }
    }

    return links;
  }

  /// 从文本中提取所有被链接的笔记标题（去重）
  static Set<String> extractLinkedTitles(String content) {
    final links = parseLinks(content);
    return links.map((link) => link.title).toSet();
  }

  /// 检查文本中是否包含特定标题的链接
  static bool containsLinkTo(String content, String title) {
    final links = extractLinkedTitles(content);
    return links.contains(title);
  }

  /// 将文本中的笔记链接替换为 Markdown 链接
  /// 例如: [[笔记A]] -> [笔记A](note://note-id)
  static String convertToMarkdownLinks(
    String content,
    Map<String, String> titleToIdMap,
  ) {
    return content.replaceAllMapped(_linkPattern, (match) {
      final title = match.group(1)?.trim();
      if (title == null || title.isEmpty) {
        return match.group(0)!;
      }

      final noteId = titleToIdMap[title];
      if (noteId != null) {
        // 转换为可点击的 Markdown 链接
        return '[$title](note://$noteId)';
      }

      // 如果找不到对应的笔记，保持原样但添加样式标记
      return '~~[[$title]]~~'; // 使用删除线标记不存在的链接
    });
  }

  /// 为文本中的链接添加自定义样式标记（用于富文本显示）
  static List<LinkSpan> parseLinkSpans(String content) {
    final spans = <LinkSpan>[];
    var lastEnd = 0;

    final matches = _linkPattern.allMatches(content);
    for (final match in matches) {
      final title = match.group(1)?.trim();
      if (title == null || title.isEmpty) continue;

      // 添加链接前的普通文本
      if (match.start > lastEnd) {
        spans.add(
          LinkSpan(
            text: content.substring(lastEnd, match.start),
            isLink: false,
          ),
        );
      }

      // 添加链接文本
      spans.add(
        LinkSpan(
          text: title,
          isLink: true,
          linkedTitle: title,
        ),
      );

      lastEnd = match.end;
    }

    // 添加最后的普通文本
    if (lastEnd < content.length) {
      spans.add(
        LinkSpan(
          text: content.substring(lastEnd),
          isLink: false,
        ),
      );
    }

    return spans;
  }

  /// 替换文本中的笔记标题引用
  /// 当笔记标题更改时，更新所有引用它的链接
  static String replaceLinkTitle(
    String content,
    String oldTitle,
    String newTitle,
  ) {
    final pattern = RegExp(r'\[\[' + RegExp.escape(oldTitle) + r'\]\]');
    return content.replaceAll(pattern, '[[$newTitle]]');
  }

  /// 移除文本中对特定笔记的所有链接
  static String removeLinksTo(String content, String title) {
    final pattern = RegExp(r'\[\[' + RegExp.escape(title) + r'\]\]');
    return content.replaceAll(pattern, title); // 移除链接标记，保留标题文本
  }
}

/// 链接文本片段（用于富文本渲染）
class LinkSpan {
  const LinkSpan({
    required this.text,
    required this.isLink,
    this.linkedTitle,
  });

  final String text;
  final bool isLink;
  final String? linkedTitle; // 如果是链接，存储被链接的笔记标题

  @override
  String toString() =>
      'LinkSpan(text: $text, isLink: $isLink, linkedTitle: $linkedTitle)';
}
