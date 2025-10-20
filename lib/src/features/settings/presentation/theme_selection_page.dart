import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/app/theme/app_theme.dart';
import 'package:todolist/src/domain/entities/app_settings.dart';
import 'package:todolist/src/features/settings/application/app_settings_service.dart';

class ThemeSelectionPage extends ConsumerWidget {
  const ThemeSelectionPage({super.key});

  static const routeName = 'theme_selection';
  static const routePath = '/settings/theme';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsService = ref.read(appSettingsServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('主题颜色'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              '选择预设主题',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _PresetThemeGrid(
            onThemeSelected: (colorScheme) async {
              await settingsService.updateThemeColor(colorScheme);
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          _CustomColorSection(
            onCustomColorSelected: (color) async {
              await settingsService.updateCustomColor(color);
            },
          ),
        ],
      ),
    );
  }
}

class _PresetThemeGrid extends ConsumerWidget {
  const _PresetThemeGrid({required this.onThemeSelected});

  final Function(AppThemeColor) onThemeSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final presetThemes = [
      AppThemeColor.bahamaBlue,
      AppThemeColor.purple,
      AppThemeColor.green,
      AppThemeColor.orange,
      AppThemeColor.pink,
      AppThemeColor.teal,
      AppThemeColor.indigo,
      AppThemeColor.amber,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: presetThemes.length,
      itemBuilder: (context, index) {
        final colorScheme = presetThemes[index];
        final color = AppTheme.getPreviewColor(colorScheme);
        final name = AppTheme.getThemeName(colorScheme);

        return InkWell(
          onTap: () => onThemeSelected(colorScheme),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: theme.colorScheme.primary == color
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomColorSection extends StatefulWidget {
  const _CustomColorSection({required this.onCustomColorSelected});

  final Function(Color) onCustomColorSelected;

  @override
  State<_CustomColorSection> createState() => _CustomColorSectionState();
}

class _CustomColorSectionState extends State<_CustomColorSection> {
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '自定义颜色',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _ColorPicker(
          selectedColor: _selectedColor,
          onColorChanged: (color) {
            setState(() {
              _selectedColor = color;
            });
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              widget.onCustomColorSelected(_selectedColor);
            },
            child: const Text('应用自定义颜色'),
          ),
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.selectedColor,
    required this.onColorChanged,
  });

  final Color selectedColor;
  final Function(Color) onColorChanged;

  static final List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _colors.map((color) {
        final isSelected = color.value == selectedColor.value;

        return InkWell(
          onTap: () => onColorChanged(color),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.outline.withOpacity(0.3),
                width: isSelected ? 3 : 2,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
