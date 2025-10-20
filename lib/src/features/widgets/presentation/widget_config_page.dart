import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/widget_config.dart';
import 'package:todolist/src/features/widgets/application/widget_config_providers.dart';
import 'package:todolist/src/features/settings/presentation/widgets/settings_widgets.dart';

class WidgetConfigPage extends ConsumerStatefulWidget {
  const WidgetConfigPage({super.key});

  static const routePath = '/widget-config';
  static const routeName = 'widgetConfig';

  @override
  ConsumerState<WidgetConfigPage> createState() => _WidgetConfigPageState();
}

class _WidgetConfigPageState extends ConsumerState<WidgetConfigPage> {
  late WidgetConfig _config;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() {
    final configAsync = ref.read(widgetConfigProvider);
    configAsync.whenData((config) {
      setState(() {
        _config = config;
      });
    });
  }

  Future<void> _saveConfig() async {
    await ref.read(widgetConfigNotifierProvider.notifier).updateConfig(_config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('小部件配置已保存')),
      );
      setState(() => _hasChanges = false);
    }
  }

  void _updateConfig(WidgetConfig newConfig) {
    setState(() {
      _config = newConfig;
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final configAsync = ref.watch(widgetConfigProvider);

    return configAsync.when(
      data: (config) {
        if (!_hasChanges) {
          _config = config;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('小部件配置'),
            actions: [
              if (_hasChanges)
                TextButton(
                  onPressed: _saveConfig,
                  child: const Text('保存'),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              _buildSizeSection(theme),
              _buildThemeSection(theme),
              _buildDisplaySection(theme),
              _buildActionsSection(theme),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('加载配置失败: $error')),
      ),
    );
  }

  Widget _buildSizeSection(ThemeData theme) {
    return SettingsSection(
      title: '小部件尺寸',
      icon: Icons.photo_size_select_large,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<WidgetSize>(
            segments: const [
              ButtonSegment(
                value: WidgetSize.small,
                label: Text('小'),
                icon: Icon(Icons.crop_square),
              ),
              ButtonSegment(
                value: WidgetSize.medium,
                label: Text('中'),
                icon: Icon(Icons.crop_landscape),
              ),
              ButtonSegment(
                value: WidgetSize.large,
                label: Text('大'),
                icon: Icon(Icons.crop_portrait),
              ),
            ],
            selected: {_config.size},
            onSelectionChanged: (Set<WidgetSize> selection) {
              _updateConfig(_config.copyWith(size: selection.first));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(ThemeData theme) {
    return SettingsSection(
      title: '主题设置',
      icon: Icons.palette,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<WidgetTheme>(
            segments: const [
              ButtonSegment(
                value: WidgetTheme.auto,
                label: Text('自动'),
                icon: Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: WidgetTheme.light,
                label: Text('浅色'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: WidgetTheme.dark,
                label: Text('深色'),
                icon: Icon(Icons.dark_mode),
              ),
            ],
            selected: {_config.theme},
            onSelectionChanged: (Set<WidgetTheme> selection) {
              _updateConfig(_config.copyWith(theme: selection.first));
            },
          ),
        ),
        SettingsColorTile(
          title: '背景颜色',
          subtitle: '自定义小部件背景色',
          color: Color(_config.backgroundColor),
          onTap: () => _pickColor(
            '选择背景颜色',
            Color(_config.backgroundColor),
            (color) => _updateConfig(
              _config.copyWith(backgroundColor: color.value),
            ),
          ),
        ),
        SettingsColorTile(
          title: '文字颜色',
          subtitle: '自定义小部件文字色',
          color: Color(_config.textColor),
          onTap: () => _pickColor(
            '选择文字颜色',
            Color(_config.textColor),
            (color) => _updateConfig(
              _config.copyWith(textColor: color.value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplaySection(ThemeData theme) {
    return SettingsSection(
      title: '显示设置',
      icon: Icons.visibility,
      children: [
        SettingsSliderTile(
          leading: const Icon(Icons.format_list_numbered),
          title: '最大任务数',
          subtitle: '小部件最多显示的任务数量',
          value: _config.maxTasks.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (value) {
            _updateConfig(_config.copyWith(maxTasks: value.toInt()));
          },
          valueFormatter: (v) => '${v.toInt()} 个',
        ),
        SettingsSwitchTile(
          leading: const Icon(Icons.check_circle_outline),
          title: '显示已完成任务',
          subtitle: '在小部件中显示已完成的任务',
          value: _config.showCompleted,
          onChanged: (value) {
            _updateConfig(_config.copyWith(showCompleted: value));
          },
        ),
        SettingsSwitchTile(
          leading: const Icon(Icons.warning_amber),
          title: '显示逾期任务',
          subtitle: '高亮显示已逾期的任务',
          value: _config.showOverdue,
          onChanged: (value) {
            _updateConfig(_config.copyWith(showOverdue: value));
          },
        ),
      ],
    );
  }

  Widget _buildActionsSection(ThemeData theme) {
    return SettingsSection(
      title: '快速操作',
      icon: Icons.touch_app,
      children: [
        SettingsSwitchTile(
          leading: const Icon(Icons.add_circle_outline),
          title: '显示快速添加按钮',
          subtitle: '在小部件上显示添加任务按钮',
          value: _config.showQuickAdd,
          onChanged: (value) {
            _updateConfig(_config.copyWith(showQuickAdd: value));
          },
        ),
        SettingsSwitchTile(
          leading: const Icon(Icons.refresh),
          title: '显示刷新按钮',
          subtitle: '在小部件上显示刷新按钮',
          value: _config.showRefresh,
          onChanged: (value) {
            _updateConfig(_config.copyWith(showRefresh: value));
          },
        ),
      ],
    );
  }

  Future<void> _pickColor(
    String title,
    Color currentColor,
    void Function(Color) onColorChanged,
  ) async {
    var selectedColor = currentColor;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (color) {
              selectedColor = color;
            },
            labelTypes: const [],
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              onColorChanged(selectedColor);
              Navigator.of(context).pop();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
