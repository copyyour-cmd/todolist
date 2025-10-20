import 'package:flutter/material.dart';
import 'package:todolist/src/features/notes/domain/note_template.dart';

/// 模板选择对话框
class TemplateSelectorDialog extends StatefulWidget {
  const TemplateSelectorDialog({
    required this.presetTemplates,
    required this.customTemplates,
    super.key,
  });

  final List<NoteTemplate> presetTemplates;
  final List<NoteTemplate> customTemplates;

  @override
  State<TemplateSelectorDialog> createState() => _TemplateSelectorDialogState();
}

class _TemplateSelectorDialogState extends State<TemplateSelectorDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        height: size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 标题栏
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '选择模板',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tab 切换
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_rounded, size: 18),
                        SizedBox(width: 6),
                        Text('预设模板'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_rounded, size: 18),
                        SizedBox(width: 6),
                        Text('自定义'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 内容区域
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 预设模板列表
                  _buildTemplateList(widget.presetTemplates, true),
                  // 自定义模板列表
                  _buildTemplateList(widget.customTemplates, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateList(List<NoteTemplate> templates, bool isPreset) {
    if (templates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPreset ? Icons.inbox_rounded : Icons.add_circle_outline_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isPreset ? '暂无预设模板' : '暂无自定义模板',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (!isPreset) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  // TODO: 打开创建模板页面
                },
                icon: const Icon(Icons.add),
                label: const Text('创建模板'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return _buildTemplateCard(template);
      },
    );
  }

  Widget _buildTemplateCard(NoteTemplate template) {
    final theme = Theme.of(context);

    // 根据图标名称获取图标
    IconData getIcon(String iconName) {
      switch (iconName) {
        case 'groups':
          return Icons.groups_rounded;
        case 'book':
          return Icons.book_rounded;
        case 'assignment':
          return Icons.assignment_rounded;
        case 'edit_note':
          return Icons.edit_note_rounded;
        case 'school':
          return Icons.school_rounded;
        case 'flight':
          return Icons.flight_rounded;
        case 'description':
          return Icons.description_rounded;
        case 'bug_report':
          return Icons.bug_report_rounded;
        case 'work':
          return Icons.work_rounded;
        case 'fitness':
          return Icons.fitness_center_rounded;
        case 'shopping':
          return Icons.shopping_cart_rounded;
        case 'lightbulb':
          return Icons.lightbulb_rounded;
        case 'analytics':
          return Icons.analytics_rounded;
        case 'movie':
          return Icons.movie_rounded;
        case 'calendar_today':
          return Icons.calendar_today_rounded;
        case 'flag':
          return Icons.flag_rounded;
        case 'account_balance':
          return Icons.account_balance_rounded;
        case 'palette':
          return Icons.palette_rounded;
        case 'code':
          return Icons.code_rounded;
        case 'restaurant':
          return Icons.restaurant_rounded;
        case 'games':
          return Icons.games_rounded;
        case 'article':
          return Icons.article_rounded;
        case 'campaign':
          return Icons.campaign_rounded;
        case 'local_hospital':
          return Icons.local_hospital_rounded;
        default:
          return Icons.note_rounded;
      }
    }

    // 根据图标名称获取渐变色
    List<Color> getGradient(String iconName) {
      switch (iconName) {
        case 'groups':
          return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
        case 'book':
          return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
        case 'assignment':
          return [const Color(0xFF3B82F6), const Color(0xFF2563EB)];
        case 'edit_note':
          return [const Color(0xFF10B981), const Color(0xFF059669)];
        case 'school':
          return [const Color(0xFFEC4899), const Color(0xFFDB2777)];
        case 'flight':
          return [const Color(0xFF06B6D4), const Color(0xFF0891B2)];
        case 'description':
          return [const Color(0xFF6366F1), const Color(0xFF4F46E5)];
        case 'bug_report':
          return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
        case 'work':
          return [const Color(0xFF14B8A6), const Color(0xFF0D9488)];
        case 'fitness':
          return [const Color(0xFFF97316), const Color(0xFFEA580C)];
        case 'shopping':
          return [const Color(0xFFA855F7), const Color(0xFF9333EA)];
        case 'lightbulb':
          return [const Color(0xFFFBBF24), const Color(0xFFF59E0B)];
        case 'analytics':
          return [const Color(0xFF2563EB), const Color(0xFF1D4ED8)];
        case 'movie':
          return [const Color(0xFFE11D48), const Color(0xFFBE123C)];
        case 'calendar_today':
          return [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];
        case 'flag':
          return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
        case 'account_balance':
          return [const Color(0xFF10B981), const Color(0xFF059669)];
        case 'palette':
          return [const Color(0xFFF59E0B), const Color(0xFFEA580C)];
        case 'code':
          return [const Color(0xFF6366F1), const Color(0xFF4F46E5)];
        case 'restaurant':
          return [const Color(0xFFEC4899), const Color(0xFFDB2777)];
        case 'games':
          return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
        case 'article':
          return [const Color(0xFF06B6D4), const Color(0xFF0891B2)];
        case 'campaign':
          return [const Color(0xFFF97316), const Color(0xFFD97706)];
        case 'local_hospital':
          return [const Color(0xFFE11D48), const Color(0xFFBE123C)];
        default:
          return [const Color(0xFF64748B), const Color(0xFF475569)];
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pop(context, template),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 图标
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: getGradient(template.icon),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  getIcon(template.icon),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // 文字内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      template.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
