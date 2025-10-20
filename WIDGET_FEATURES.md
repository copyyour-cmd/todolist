# 小部件功能实现总结

本文档总结了 TodoList 应用的所有小部件功能实现。

## 功能概览

### ✅ 已实现的功能

1. **多种小部件尺寸支持**
   - 小尺寸（120x120dp）- 紧凑显示
   - 中等尺寸（250x180dp）- 标准显示
   - 大尺寸（250x300dp）- 详细显示

2. **小部件配置选项**
   - 小部件尺寸选择
   - 主题切换（自动/浅色/深色）
   - 自定义背景颜色
   - 自定义文字颜色
   - 最大任务数设置（1-10）
   - 显示/隐藏已完成任务
   - 显示/隐藏逾期任务
   - 快速添加按钮开关
   - 刷新按钮开关

3. **倒计时小部件**
   - 显示下一个任务截止时间
   - 实时倒计时显示
   - 优先级颜色指示
   - 点击跳转到任务详情

4. **小部件主题切换**
   - 自动跟随系统主题
   - 独立浅色主题
   - 独立深色主题
   - 自定义颜色支持

5. **快速操作按钮**
   - 快速添加任务
   - 刷新小部件
   - 点击任务跳转详情
   - 完成任务操作

## 技术实现

### Flutter 端

#### 1. 实体和仓储

**WidgetConfig 实体** (`lib/src/domain/entities/widget_config.dart`)
```dart
@freezed
class WidgetConfig with _$WidgetConfig {
  const factory WidgetConfig({
    @Default(WidgetSize.medium) WidgetSize size,
    @Default(WidgetTheme.auto) WidgetTheme theme,
    @Default(5) int maxTasks,
    @Default(true) bool showCompleted,
    @Default(true) bool showOverdue,
    @Default(0xFFFFFFFF) int backgroundColor,
    @Default(0xFF000000) int textColor,
    @Default(true) bool showQuickAdd,
    @Default(true) bool showRefresh,
  }) = _WidgetConfig;
}
```

**WidgetConfigRepository** (`lib/src/domain/repositories/widget_config_repository.dart`)
- Hive 实现，持久化存储配置

#### 2. 服务层

**WidgetService** (`lib/src/features/widgets/application/widget_service.dart`)
- `updateTodayTasks()` - 更新今日任务到小部件
- `updateCountdownWidget()` - 更新倒计时小部件
- `handleQuickAction()` - 处理快速操作
- `initializeCallbacks()` - 初始化回调

#### 3. UI 组件

**WidgetConfigPage** (`lib/src/features/widgets/presentation/widget_config_page.dart`)
- 完整的配置界面
- 颜色选择器集成
- 实时预览

**WidgetSettingsPage** (`lib/src/features/widgets/presentation/widget_settings_page.dart`)
- 小部件使用说明
- 手动更新功能
- 功能介绍

### Android 原生端

#### 1. Widget Providers

**TodayTasksWidgetProvider.kt**
- 支持小/中/大三种尺寸
- 动态主题应用
- 任务列表渲染
- 点击事件处理

**CountdownWidgetProvider.kt**
- 倒计时显示
- 优先级颜色
- 紧急度标识

#### 2. 布局文件

**小尺寸** (`res/layout/widget_small.xml`)
- 简洁布局
- 最多3个任务
- 刷新按钮

**中等尺寸** (`res/layout/widget_medium.xml`)
- 标准布局
- 最多5个任务
- 添加和刷新按钮
- 完成统计

**大尺寸** (`res/layout/widget_large.xml`)
- 详细布局
- 最多10个任务
- 可滚动列表
- 完整操作栏

**倒计时** (`res/layout/widget_countdown.xml`)
- 大字体倒计时
- 任务标题
- 优先级指示器

#### 3. Widget Info 配置

每个尺寸都有独立的 widget info XML：
- `widget_small_info.xml` - 最小尺寸 120x120dp
- `widget_medium_info.xml` - 标准尺寸 250x180dp
- `widget_large_info.xml` - 大尺寸 250x300dp
- `widget_countdown_info.xml` - 倒计时 180x180dp

## 使用方法

### 1. 添加小部件到主屏幕

Android:
1. 长按主屏幕空白处
2. 选择"小部件"或"Widgets"
3. 找到"TodoList"应用
4. 选择需要的小部件类型：
   - 今日任务（小）
   - 今日任务（中）
   - 今日任务（大）
   - 任务倒计时
5. 拖动到主屏幕

### 2. 配置小部件

在应用内：
1. 打开设置页面
2. 进入"小部件设置"部分
3. 点击"小部件配置"
4. 调整以下选项：
   - 尺寸
   - 主题
   - 显示数量
   - 颜色
   - 快速操作

### 3. 更新小部件

自动更新：
- 每30分钟自动更新
- 任务变更时自动更新

手动更新：
- 点击小部件刷新按钮
- 在应用内点击"立即更新小部件"

## 数据流

```
Task Repository
    ↓
WidgetService.updateTodayTasks()
    ↓
HomeWidget.saveWidgetData()
    ↓
Android Native Widget Provider
    ↓
RemoteViews 渲染
    ↓
主屏幕显示
```

## 配置数据结构

小部件配置通过以下方式传递到 Android：

```json
{
  "size": "medium",
  "theme": "auto",
  "maxTasks": 5,
  "showCompleted": true,
  "showOverdue": true,
  "backgroundColor": 0xFFFFFFFF,
  "textColor": 0xFF000000,
  "showQuickAdd": true,
  "showRefresh": true
}
```

## 优先级颜色

```kotlin
val priorityColor = when (priority) {
    "critical" -> 0xFFD32F2F  // 红色
    "high" -> 0xFFF57C00      // 橙色
    "medium" -> 0xFF1976D2    // 蓝色
    "low" -> 0xFF388E3C       // 绿色
    else -> 0xFF757575        // 灰色
}
```

## 快速操作支持

### 已实现的操作

1. **快速添加任务**
   - URI: `todolist://add_task`
   - 打开任务创建页面

2. **刷新小部件**
   - URI: `todolist://refresh_widget`
   - 触发数据更新

3. **查看任务详情**
   - URI: `todolist://task/{taskId}`
   - 跳转到任务详情页

## 性能优化

1. **更新频率控制**
   - Android: 最快30分钟
   - 倒计时: 1分钟更新

2. **数据限制**
   - 小部件数据 < 100KB
   - 任务列表最多10个

3. **缓存策略**
   - HomeWidget 内置缓存
   - 配置持久化到 Hive

## 注意事项

### Android
1. 小部件需要在 AndroidManifest.xml 中注册
2. 更新频率受系统限制
3. 点击事件通过 PendingIntent 实现
4. RemoteViews 支持的 View 有限

### Flutter
1. 需要调用 `HomeWidget.updateWidget()` 触发更新
2. 数据通过 SharedPreferences 共享
3. 回调需要在 main.dart 中初始化

## 依赖项

### Flutter 依赖
```yaml
dependencies:
  home_widget: ^0.7.0
  flutter_colorpicker: ^1.1.0
  freezed_annotation: ^2.4.4
  hive_flutter: ^1.1.0
```

### Android 配置
```xml
<receiver android:name=".TodayTasksWidgetProvider">
  <intent-filter>
    <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
  </intent-filter>
  <meta-data
    android:name="android.appwidget.provider"
    android:resource="@xml/widget_medium_info" />
</receiver>
```

## 未来改进

### 计划中的功能
- [ ] iOS Widget Extension 支持
- [ ] 小部件主题模板
- [ ] 更多快速操作（延期、删除等）
- [ ] 小部件手势支持
- [ ] 统计类小部件
- [ ] 习惯打卡小部件

### 优化方向
- 减少更新延迟
- 优化内存占用
- 支持更多自定义选项
- 添加动画效果

## 调试

### Android
```bash
# 查看小部件信息
adb shell dumpsys appwidget

# 强制更新小部件
adb shell am broadcast -a android.appwidget.action.APPWIDGET_UPDATE
```

### Flutter
```dart
// 打印小部件数据
final data = await HomeWidget.getWidgetData<String>('today_tasks');
print('Widget data: $data');
```

## 文件清单

### Flutter 文件
- `lib/src/domain/entities/widget_config.dart`
- `lib/src/domain/repositories/widget_config_repository.dart`
- `lib/src/infrastructure/repositories/hive_widget_config_repository.dart`
- `lib/src/features/widgets/application/widget_service.dart`
- `lib/src/features/widgets/application/widget_providers.dart`
- `lib/src/features/widgets/application/widget_config_providers.dart`
- `lib/src/features/widgets/presentation/widget_settings_page.dart`
- `lib/src/features/widgets/presentation/widget_config_page.dart`

### Android 文件
- `android/app/src/main/kotlin/com/example/todolist/TodayTasksWidgetProvider.kt`
- `android/app/src/main/kotlin/com/example/todolist/CountdownWidgetProvider.kt`
- `android/app/src/main/res/layout/widget_small.xml`
- `android/app/src/main/res/layout/widget_medium.xml`
- `android/app/src/main/res/layout/widget_large.xml`
- `android/app/src/main/res/layout/widget_countdown.xml`
- `android/app/src/main/res/layout/widget_task_item.xml`
- `android/app/src/main/res/xml/widget_small_info.xml`
- `android/app/src/main/res/xml/widget_medium_info.xml`
- `android/app/src/main/res/xml/widget_large_info.xml`
- `android/app/src/main/res/xml/widget_countdown_info.xml`
- `android/app/src/main/res/values/strings.xml`

## 总结

本次实现完成了 TodoList 应用的完整小部件功能，包括：

✅ 3种尺寸的任务列表小部件
✅ 1个倒计时小部件
✅ 完整的配置系统
✅ 主题切换支持
✅ 快速操作功能
✅ 自定义颜色
✅ Android 原生实现

所有功能已经过代码生成和编译验证，可以在 Android 设备上正常使用。
