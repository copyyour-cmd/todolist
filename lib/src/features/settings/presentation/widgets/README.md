# Settings Widgets 使用指南

这个文件夹包含了设置页面的可复用组件。

## 组件列表

### 1. SettingsSection - 设置分组
用于将设置项分组显示,带标题和可选图标。

```dart
SettingsSection(
  title: '外观设置',
  icon: Icons.palette,
  children: [
    // 设置项...
  ],
)
```

### 2. SettingsTile - 通用设置项
基础的设置项组件,支持自定义leading/trailing。

```dart
SettingsTile(
  leading: const Icon(Icons.info),
  title: '版本号',
  subtitle: 'v1.0.0',
  onTap: () {},
)
```

### 3. SettingsSwitchTile - 开关设置项
带开关的设置项。

```dart
SettingsSwitchTile(
  leading: const Icon(Icons.dark_mode),
  title: '深色模式',
  subtitle: '启用深色主题',
  value: isDarkMode,
  onChanged: (value) => setDarkMode(value),
)
```

### 4. SettingsSliderTile - 滑块设置项
带滑块的设置项,用于调整数值。

```dart
SettingsSliderTile(
  leading: const Icon(Icons.volume_up),
  title: '音量',
  value: volume,
  min: 0,
  max: 100,
  divisions: 10,
  onChanged: (value) => setVolume(value),
  valueFormatter: (v) => '${v.toInt()}%',
)
```

### 5. SettingsNavigationTile - 导航设置项
带右箭头的导航项,用于跳转到子页面。

```dart
SettingsNavigationTile(
  leading: const Icon(Icons.language),
  title: '语言设置',
  subtitle: '中文简体',
  onTap: () => navigateToLanguageSettings(),
)
```

### 6. SettingsInfoTile - 信息展示项
不可点击的信息展示项。

```dart
SettingsInfoTile(
  leading: const Icon(Icons.storage),
  title: '存储空间',
  value: '125 MB',
)
```

### 7. SettingsDangerTile - 危险操作项
红色样式的危险操作项(如删除、清空等)。

```dart
SettingsDangerTile(
  title: '清空所有数据',
  subtitle: '此操作不可撤销',
  icon: Icons.delete_forever,
  onTap: () => clearAllData(),
)
```

### 8. SettingsColorTile - 颜色选择项
带颜色预览的设置项。

```dart
SettingsColorTile(
  title: '主题颜色',
  subtitle: '选择应用主色调',
  color: Colors.blue,
  onTap: () => showColorPicker(),
)
```

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'settings_widgets.dart';

class ExampleSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          SettingsSection(
            title: '外观',
            icon: Icons.palette,
            children: [
              SettingsSwitchTile(
                leading: const Icon(Icons.dark_mode),
                title: '深色模式',
                value: true,
                onChanged: (value) {},
              ),
              SettingsColorTile(
                title: '主题颜色',
                color: Colors.blue,
                onTap: () {},
              ),
            ],
          ),

          SettingsSection(
            title: '通知',
            icon: Icons.notifications,
            children: [
              SettingsSwitchTile(
                leading: const Icon(Icons.notifications_active),
                title: '启用通知',
                value: true,
                onChanged: (value) {},
              ),
              SettingsSliderTile(
                leading: const Icon(Icons.volume_up),
                title: '通知音量',
                value: 80,
                max: 100,
                divisions: 10,
                onChanged: (value) {},
              ),
            ],
          ),

          SettingsSection(
            title: '关于',
            icon: Icons.info,
            children: [
              SettingsInfoTile(
                leading: const Icon(Icons.info_outline),
                title: '版本',
                value: 'v1.0.0',
              ),
              SettingsNavigationTile(
                leading: const Icon(Icons.article),
                title: '许可证',
                onTap: () {},
              ),
            ],
          ),

          SettingsSection(
            title: '危险操作',
            icon: Icons.warning,
            children: [
              SettingsDangerTile(
                title: '清空所有数据',
                subtitle: '删除所有任务和设置',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## 优势

1. **一致性**: 所有设置项使用统一的组件,保持UI一致
2. **可维护性**: 修改样式只需修改组件,不用改每个页面
3. **可复用性**: 可在多个设置页面中使用
4. **可扩展性**: 易于添加新的设置项类型
5. **DRY原则**: 避免重复代码

## 架构优势 (SOLID/KISS/DRY)

- **单一职责(S)**: 每个组件只负责一种设置项类型
- **简洁性(KISS)**: 组件接口简单清晰
- **避免重复(DRY)**: 消除了settings_page.dart中的大量重复ListTile代码
- **组合优于继承**: 使用composition而非inheritance
