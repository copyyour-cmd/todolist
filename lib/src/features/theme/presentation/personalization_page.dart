import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/theme_config.dart';
import 'package:todolist/src/features/theme/application/theme_providers.dart';

class PersonalizationPage extends ConsumerWidget {
  const PersonalizationPage({super.key});

  static const routePath = '/personalization';
  static const routeName = 'personalization';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeConfig = ref.watch(themeConfigProvider);
    final themeService = ref.read(themeServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('个性化设置'),
        actions: [
          TextButton(
            onPressed: () async {
              await themeService.resetToDefault();
              ref.invalidate(themeConfigProvider);
            },
            child: const Text('恢复默认'),
          ),
        ],
      ),
      body: ListView(
        children: [
          // 颜色方案
          _buildSection(
            theme,
            '颜色方案',
            Icons.palette,
            [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ColorSchemePreset.values
                    .where((p) => p != ColorSchemePreset.custom)
                    .map((preset) => _ColorChip(
                          preset: preset,
                          isSelected: themeConfig.colorScheme == preset,
                          onTap: () async {
                            await themeService.updateColorScheme(preset);
                            ref.invalidate(themeConfigProvider);
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
          const Divider(),

          // 字体大小
          _buildSection(
            theme,
            '字体大小',
            Icons.format_size,
            [
              SegmentedButton<FontSizePreset>(
                segments: FontSizePreset.values
                    .map((size) => ButtonSegment(
                          value: size,
                          label: Text(size.displayName),
                        ))
                    .toList(),
                selected: {themeConfig.fontSize},
                onSelectionChanged: (Set<FontSizePreset> selected) async {
                  await themeService.updateFontSize(selected.first);
                  ref.invalidate(themeConfigProvider);
                },
              ),
              const SizedBox(height: 8),
              Text(
                '预览文字: ${(14 * themeConfig.fontScale).toStringAsFixed(0)}sp',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14 * themeConfig.fontScale,
                ),
              ),
            ],
          ),
          const Divider(),

          // 卡片样式
          _buildSection(
            theme,
            '任务卡片样式',
            Icons.view_agenda,
            [
              ...TaskCardStyle.values.map((style) => RadioListTile<TaskCardStyle>(
                    title: Text(style.displayName),
                    subtitle: Text(_getCardStyleDescription(style)),
                    value: style,
                    groupValue: themeConfig.cardStyle,
                    onChanged: (value) async {
                      if (value != null) {
                        await themeService.updateCardStyle(value);
                        ref.invalidate(themeConfigProvider);
                      }
                    },
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  String _getCardStyleDescription(TaskCardStyle style) {
    switch (style) {
      case TaskCardStyle.compact:
        return '更紧凑的间距，显示更多内容';
      case TaskCardStyle.comfortable:
        return '适中的间距，平衡舒适度';
      case TaskCardStyle.spacious:
        return '宽松的间距，更易阅读';
    }
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final ColorSchemePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: preset.primaryColor,
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              preset.displayName,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
