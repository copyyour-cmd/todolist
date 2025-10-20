import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/ai/application/ai_providers.dart';

/// 笔记AI操作组件
/// 提供摘要、标签推荐、相关笔记、问答等AI功能
class NoteAIActions extends ConsumerWidget {
  const NoteAIActions({
    required this.note,
    super.key,
  });

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiService = ref.watch(noteAIServiceProvider);

    // 如果AI服务未配置,显示提示
    if (aiService == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.auto_awesome, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'AI功能未启用',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '请先在设置中配置AI服务',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  // TODO: 导航到AI设置页面
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请在设置中配置AI服务')),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('去设置'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI功能按钮组
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 20, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'AI助手',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildActionChip(
                      context: context,
                      icon: Icons.summarize,
                      label: '生成摘要',
                      onPressed: () => _showSummaryDialog(context, ref),
                    ),
                    _buildActionChip(
                      context: context,
                      icon: Icons.label,
                      label: '推荐标签',
                      onPressed: () => _showTagsDialog(context, ref),
                    ),
                    _buildActionChip(
                      context: context,
                      icon: Icons.link,
                      label: '相关笔记',
                      onPressed: () => _showRelatedNotesDialog(context, ref),
                    ),
                    _buildActionChip(
                      context: context,
                      icon: Icons.question_answer,
                      label: '智能问答',
                      onPressed: () => _showQuestionDialog(context, ref),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
    );
  }

  // 显示摘要对话框
  void _showSummaryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _SummaryDialog(note: note),
    );
  }

  // 显示标签推荐对话框
  void _showTagsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _TagsDialog(note: note),
    );
  }

  // 显示相关笔记对话框
  void _showRelatedNotesDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _RelatedNotesDialog(note: note),
    );
  }

  // 显示智能问答对话框
  void _showQuestionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _QuestionDialog(note: note),
    );
  }
}

/// 摘要对话框
class _SummaryDialog extends ConsumerWidget {
  const _SummaryDialog({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(generateNoteSummaryProvider(note));

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.summarize, color: Colors.blue),
          SizedBox(width: 8),
          Text('智能摘要'),
        ],
      ),
      content: summaryAsync.when(
        data: (summary) {
          if (summary == null) {
            return const Text('AI服务未配置');
          }
          return SingleChildScrollView(
            child: SelectableText(summary),
          );
        },
        loading: () => const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('AI正在生成摘要...'),
          ],
        ),
        error: (error, stack) => Text('生成失败: $error'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
        if (summaryAsync.hasValue && summaryAsync.value != null)
          FilledButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: summaryAsync.value!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('摘要已复制到剪贴板')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('复制'),
          ),
      ],
    );
  }
}

/// 标签推荐对话框
class _TagsDialog extends ConsumerWidget {
  const _TagsDialog({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(suggestNoteTagsProvider(note));

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.label, color: Colors.green),
          SizedBox(width: 8),
          Text('标签推荐'),
        ],
      ),
      content: tagsAsync.when(
        data: (tags) {
          if (tags == null || tags.isEmpty) {
            return const Text('暂无推荐标签');
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Chip(
                label: Text(tag),
                onDeleted: () {
                  // TODO: 添加标签到笔记
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已添加标签: $tag')),
                  );
                },
                deleteIcon: const Icon(Icons.add),
              );
            }).toList(),
          );
        },
        loading: () => const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('AI正在分析标签...'),
          ],
        ),
        error: (error, stack) => Text('推荐失败: $error'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    );
  }
}

/// 相关笔记对话框
class _RelatedNotesDialog extends ConsumerWidget {
  const _RelatedNotesDialog({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(recommendedNotesProvider(note));

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.link, color: Colors.orange),
          SizedBox(width: 8),
          Text('相关笔记'),
        ],
      ),
      content: notesAsync.when(
        data: (notes) {
          if (notes == null || notes.isEmpty) {
            return const Text('暂无相关笔记');
          }
          return SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final relatedNote = notes[index];
                return ListTile(
                  leading: Text(relatedNote.getCategoryIcon()),
                  title: Text(relatedNote.title),
                  subtitle: Text(
                    relatedNote.getPreviewText(maxLength: 50),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: 导航到笔记详情页
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        },
        loading: () => const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在查找相关笔记...'),
          ],
        ),
        error: (error, stack) => Text('查找失败: $error'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    );
  }
}

/// 智能问答对话框
class _QuestionDialog extends ConsumerStatefulWidget {
  const _QuestionDialog({required this.note});

  final Note note;

  @override
  ConsumerState<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends ConsumerState<_QuestionDialog> {
  final _questionController = TextEditingController();
  String? _answer;
  bool _isLoading = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _askQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
      _answer = null;
    });

    try {
      final answer = await ref.read(
        askAboutNoteProvider((note: widget.note, question: question)).future,
      );

      if (mounted) {
        setState(() {
          _answer = answer;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _answer = '回答失败: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.question_answer, color: Colors.purple),
          SizedBox(width: 8),
          Text('智能问答'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: '输入你的问题',
                hintText: '例如: 这篇笔记的核心观点是什么?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onSubmitted: (_) => _askQuestion(),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('AI正在思考...'),
                  ],
                ),
              )
            else if (_answer != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'AI回答:',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(_answer!),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
        FilledButton.icon(
          onPressed: _isLoading ? null : _askQuestion,
          icon: const Icon(Icons.send),
          label: const Text('提问'),
        ),
      ],
    );
  }
}
