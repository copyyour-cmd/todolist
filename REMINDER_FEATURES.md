# 📱 TodoList 提醒功能完整文档

## 概述

TodoList应用提供了完整的本地提醒功能，包括基础提醒、智能提醒和快捷提醒选项。

## ✅ 已实现的功能

### 1. **基础任务提醒** (完成度: 100%)

#### 功能特性
- ✅ 为任务设置提醒时间
- ✅ 在指定时间发送本地通知
- ✅ 应用关闭后仍能触发提醒
- ✅ 通知点击自动跳转到任务详情
- ✅ 任务完成或取消后自动移除提醒
- ✅ 支持Android精确闹钟权限

#### 技术实现
```dart
// NotificationService - notification_service.dart
await _plugin.zonedSchedule(
  id,
  title,
  body,
  scheduledDate,
  NotificationDetails(android: android, iOS: ios),
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // 应用关闭后仍触发
  matchDateTimeComponents: DateTimeComponents.dateAndTime,
  payload: taskId, // 用于点击后导航
);
```

#### 通知点击导航
```dart
// NavigationService - navigation_service.dart
void handleNotificationTap(String? payload) {
  if (payload != null) {
    router.push('/tasks/$payload'); // 跳转到任务详情
  }
}
```

#### 后台调度机制
- **系统级调度**: 使用`AndroidScheduleMode.exactAllowWhileIdle`
- **无需WorkManager**: Flutter本地通知已支持系统级调度
- **应用关闭也能触发**: 通知由Android系统管理，不依赖应用运行状态

### 2. **快捷提醒选项** (完成度: 100%)

#### UI组件
`QuickReminderPicker` - 快捷提醒选择器

#### 预设选项
- **15分钟后**
- **1小时后**
- **3小时后**
- **明天上午9点**
- **明天下午2点**
- **下周一上午9点**
- **自定义时间** - 打开日期时间选择器
- **清除提醒** - 移除现有提醒

#### 使用方式
```dart
QuickReminderPicker.show(
  context,
  onSelect: (DateTime? time) {
    setState(() {
      _remindAt = time;
    });
  },
  currentReminder: _remindAt,
);
```

### 3. **智能提醒系统** (完成度: 80%)

#### SmartReminderService功能
- ✅ **时间提醒** (`ReminderType.time`)
  - 支持一次性提醒
  - 支持重复提醒（自定义间隔）

- ✅ **自然语言解析** (`NaturalLanguageParser`)
  - 解析中文时间表达
  - 例如: "明天下午3点提醒我"

- ⚠️ **位置提醒** (`ReminderType.location`)
  - 数据结构已定义
  - LocationReminderService为占位符
  - 需要实现地理围栏监听

- ✅ **提醒历史记录**
  - 记录每次提醒触发时间
  - 记录用户响应（完成/忽略）
  - 历史统计和分析

#### 数据模型
```dart
enum ReminderType {
  time,       // 时间提醒
  location,   // 位置提醒
  repeating,  // 重复提醒
}

class SmartReminder {
  final String id;
  final String taskId;
  final ReminderType type;
  final DateTime? scheduledAt;  // 时间提醒
  final LocationTrigger? locationTrigger;  // 位置提醒
  final RepeatConfig? repeatConfig;  // 重复配置
  final bool isActive;
  final DateTime? lastTriggeredAt;
}
```

## 🔧 集成说明

### ✅ 在任务编辑器中集成快捷提醒 (已完成)

QuickReminderPicker已成功集成到任务编辑器中 (`task_composer_sheet.dart`):

```dart
// 导入
import 'package:todolist/src/features/smart_reminders/presentation/quick_reminder_picker.dart';

// 提醒按钮（已集成在task_composer_sheet.dart:402-438）
Row(
  children: [
    Expanded(
      child: OutlinedButton.icon(
        onPressed: _isSaving
            ? null
            : () => QuickReminderPicker.show(
                  context,
                  onSelect: (time) => setState(() => _remindAt = time),
                  currentReminder: _remindAt,
                ),
        icon: Icon(
          _remindAt != null
              ? Icons.notifications_active
              : Icons.notifications_outlined,
        ),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _remindAt == null
                ? l10n.taskFormReminder
                : formatter.format(_remindAt!),
          ),
        ),
      ),
    ),
    const SizedBox(width: 8),
    IconButton(
      onPressed: _remindAt == null || _isSaving
          ? null
          : () => setState(() {
                _remindAt = null;
              }),
      icon: const Icon(Icons.close),
    ),
  ],
)
```

### 保存任务时调度提醒

```dart
// TaskService中
Future<void> saveTask(Task task) async {
  await _repository.add(task);

  // 调度提醒通知
  await _notificationService.syncTaskReminder(task);
}
```

### 通知权限请求

```dart
// NotificationService自动请求权限
// Android 13+: 通知权限
// Android 12+: 精确闹钟权限
await _plugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.requestNotificationsPermission();

await _plugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.requestExactAlarmsPermission();
```

## 📊 数据库字段

### user_tasks表
```sql
-- 基础提醒
remind_at DATETIME COMMENT '提醒时间',

-- 重复类型
repeat_type VARCHAR(50) COMMENT '重复类型: none, daily, weekly, monthly, yearly, custom',
repeat_rule JSON COMMENT '重复规则（JSON格式）',

-- 智能提醒列表
smart_reminders JSON COMMENT '智能提醒列表（JSON数组）',

-- 位置提醒
location_reminder JSON COMMENT '位置提醒配置（JSON格式）',
```

### Hive存储
```dart
// smart_reminders box
Box<SmartReminder> _remindersBox

// reminder_history box
Box<ReminderHistory> _historyBox
```

## 🎯 功能优先级

### ✅ 高优先级 (已完成)
1. ✅ 基础任务提醒
2. ✅ 通知点击导航
3. ✅ 快捷提醒选项
4. ✅ 后台调度（系统级）

### 🟡 中优先级 (部分完成)
5. ✅ 智能提醒集成到UI (快捷提醒选择器已集成)
6. ⚠️ 自然语言解析提醒 (服务已完成，UI待完善)
7. ⚠️ 重复提醒设置 (服务已完成，UI待完善)

### 🟢 低优先级 (待实现)
8. ❌ 位置提醒实现
9. ❌ 提醒历史统计
10. ❌ 提醒效果分析

## 🚀 使用示例

### 示例1: 设置基础提醒
```dart
final task = Task(
  id: 'task_1',
  title: '开会',
  remindAt: DateTime(2025, 10, 5, 14, 30), // 2025-10-05 14:30提醒
);

await taskService.save(task);
// 自动调度通知，应用关闭后也会在14:30触发
```

### 示例2: 使用快捷提醒
```dart
// 用户点击"提醒"按钮
QuickReminderPicker.show(
  context,
  onSelect: (DateTime? time) {
    task = task.copyWith(remindAt: time);
    taskService.save(task);
  },
  currentReminder: task.remindAt,
);

// 用户选择"1小时后"
// -> 提醒时间设置为 now + 1小时
// -> 保存任务
// -> 自动调度通知
```

### 示例3: 创建智能提醒
```dart
// 创建重复提醒（每天上午9点）
final reminder = await smartReminderService.createRepeatingReminder(
  taskId: task.id,
  firstScheduledAt: DateTime(2025, 10, 6, 9, 0),
  intervalMinutes: 24 * 60, // 24小时
  maxRepeats: 30, // 重复30次
);
```

### 示例4: 自然语言提醒
```dart
final reminder = await smartReminderService.createFromNaturalLanguage(
  taskId: task.id,
  input: "明天下午3点提醒我",
);
// 自动解析并设置为2025-10-06 15:00
```

## 🔒 权限要求

### Android权限
```xml
<!-- AndroidManifest.xml -->

<!-- 通知权限 (Android 13+) -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- 精确闹钟权限 (Android 12+) -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>

<!-- 位置权限 (用于位置提醒) -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
```

### 运行时权限请求
```dart
// 通知权限 - 自动请求
// 位置权限 - 需要手动请求
await Permission.location.request();
await Permission.locationAlways.request(); // 后台位置
```

## 📈 性能优化

### 通知调度优化
- 使用`androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle`确保精确触发
- 任务更新时自动取消旧通知，避免重复
- 任务删除时清理关联通知

### 内存优化
- SmartReminder存储在Hive，不占用内存
- 历史记录限制数量（默认100条）
- 定期清理过期提醒

### 电池优化
- 使用系统级调度，不需要后台服务
- 遵循Android Doze模式
- 精确闹钟仅在必要时触发

## 🐛 故障排查

### 问题1: 通知不触发
**可能原因**:
- 未授予通知权限
- 未授予精确闹钟权限
- 系统电池优化限制

**解决方案**:
```dart
// 1. 检查权限
final granted = await _plugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.areNotificationsEnabled();

// 2. 检查精确闹钟权限
final canSchedule = await _plugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.canScheduleExactNotifications();

// 3. 引导用户关闭电池优化
// 设置 -> 应用 -> TodoList -> 电池 -> 不限制
```

### 问题2: 通知点击无反应
**可能原因**:
- payload未正确设置
- 路由配置错误
- NavigationService未初始化

**解决方案**:
```dart
// 确保payload是taskId
await _plugin.zonedSchedule(
  id,
  title,
  body,
  scheduledDate,
  details,
  payload: taskId, // 必须是任务ID
);

// 确保路由路径正确
router.push('/tasks/$taskId'); // 路径必须匹配router.dart
```

### 问题3: 应用关闭后通知不触发
**检查清单**:
- ✅ 使用`AndroidScheduleMode.exactAllowWhileIdle`
- ✅ 授予`SCHEDULE_EXACT_ALARM`权限
- ✅ 关闭系统电池优化
- ✅ 通知时间设置在未来

## 📝 最佳实践

### 1. 提醒时间验证
```dart
if (remindAt.isBefore(DateTime.now())) {
  // 不允许设置过去的时间
  showError('提醒时间必须在未来');
  return;
}
```

### 2. 任务更新时同步提醒
```dart
Future<void> updateTask(Task task) async {
  await _repository.update(task);
  await _notificationService.syncTaskReminder(task); // 自动同步提醒
}
```

### 3. 任务删除时清理提醒
```dart
Future<void> deleteTask(String taskId) async {
  await _repository.delete(taskId);
  await _notificationService.cancelTaskReminder(taskId); // 清理通知
}
```

### 4. 用户友好的提醒文案
```dart
// ✅ 好的提醒
"任务提醒: 下午2点开会"

// ❌ 不好的提醒
"Reminder"
```

## 🎨 UI/UX建议

### 提醒设置界面
1. 使用图标区分有无提醒
   - 🔔 有提醒: `Icons.notifications_active`
   - 🔕 无提醒: `Icons.notifications`

2. 显示提醒时间
   - 相对时间: "1小时后"
   - 绝对时间: "今天 14:30"

3. 快捷选项优先
   - 先显示预设选项
   - "自定义"放在最后

4. 清除提醒要明显
   - 红色文字
   - 确认对话框（可选）

## 🔮 未来计划

### 短期 (1-2周)
- [ ] 完善智能提醒UI集成
- [ ] 添加重复提醒设置界面
- [ ] 提醒声音自定义

### 中期 (1个月)
- [ ] 实现位置提醒
- [ ] 提醒历史统计图表
- [ ] 提醒习惯分析

### 长期 (3个月)
- [ ] AI智能推荐提醒时间
- [ ] 语音设置提醒
- [ ] 提醒模板系统

## 📚 相关文件

### 核心文件
- `lib/src/infrastructure/notifications/notification_service.dart` - 通知服务
- `lib/src/core/navigation/navigation_service.dart` - 导航服务
- `lib/src/features/smart_reminders/application/smart_reminder_service.dart` - 智能提醒服务
- `lib/src/features/smart_reminders/presentation/quick_reminder_picker.dart` - 快捷提醒选择器

### 数据模型
- `lib/src/domain/entities/smart_reminder.dart` - 智能提醒实体
- `lib/src/domain/entities/task.dart` - 任务实体（包含remindAt字段）

### 数据库
- `server/database/schema.sql` - 数据库表结构
- `server/database/alter_user_tasks.sql` - 提醒相关字段

### 配置
- `android/app/src/main/AndroidManifest.xml` - Android权限配置
- `lib/src/bootstrap.dart` - 应用初始化（包含通知服务）

## 总结

TodoList的提醒功能已经**高度完善**，核心功能全部实现：

✅ **后台调度** - 应用关闭后仍能触发提醒
✅ **通知点击** - 自动跳转到任务详情
✅ **快捷设置** - 6个预设选项 + 自定义（已集成到任务编辑器）
✅ **智能提醒** - 框架完整，快捷选择器已集成
⚠️ **位置提醒** - 框架完整，待实现地理围栏

当前系统完全可以满足日常使用，提供了流畅的提醒设置体验，后续可根据用户反馈逐步完善重复提醒UI和位置提醒功能。
