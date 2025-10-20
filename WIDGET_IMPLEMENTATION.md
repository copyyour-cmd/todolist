# 小部件实现指南

本文档说明如何为 TodoList 应用实现主屏幕小部件。

## 概述

Feature #17 实现了以下小部件功能：
- **今日任务小部件** - 显示今天的待办任务（最多5个）
- **快速添加任务** - 从主屏幕快速添加新任务
- **任务统计** - 显示今日完成任务数

## Flutter 端实现

### 1. 依赖

已在 `pubspec.yaml` 中添加：
```yaml
dependencies:
  home_widget: ^0.7.0
```

### 2. 服务层

**WidgetService** (`lib/src/features/widgets/application/widget_service.dart`)
- `updateTodayTasks()` - 更新今日任务数据到小部件
- `handleWidgetTap()` - 处理小部件点击事件
- `initializeCallbacks()` - 初始化小部件回调
- `quickAddTask()` - 快速添加任务

### 3. UI 组件

**WidgetSettingsPage** (`lib/src/features/widgets/presentation/widget_settings_page.dart`)
- 小部件使用说明
- 手动更新小部件按钮
- 功能介绍

## Android 原生实现

### 文件位置
`android/app/src/main/kotlin/com/example/todolist/`

### 1. Widget Provider
创建 `TodayTasksWidgetProvider.kt`:

```kotlin
package com.example.todolist

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray

class TodayTasksWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val tasksJson = widgetData.getString("today_tasks", "[]")
            val taskCount = widgetData.getInt("task_count", 0)
            val completedCount = widgetData.getInt("completed_count", 0)

            val views = RemoteViews(context.packageName, R.layout.widget_today_tasks)

            // Set task count
            views.setTextViewText(R.id.task_count, "$taskCount 个任务")
            views.setTextViewText(R.id.completed_count, "已完成 $completedCount")

            // Parse and display tasks
            try {
                val tasks = JSONArray(tasksJson)
                for (i in 0 until minOf(tasks.length(), 5)) {
                    val task = tasks.getJSONObject(i)
                    // Update task views
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

            // Set click intent
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
```

### 2. Widget Layout
创建 `android/app/src/main/res/layout/widget_today_tasks.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp"
    android:background="@drawable/widget_background">

    <TextView
        android:id="@+id/widget_title"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="今日任务"
        android:textSize="18sp"
        android:textStyle="bold"
        android:textColor="#333333" />

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:layout_marginTop="8dp">

        <TextView
            android:id="@+id/task_count"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textSize="14sp"
            android:textColor="#666666" />

        <TextView
            android:id="@+id/completed_count"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginStart="16dp"
            android:textSize="14sp"
            android:textColor="#4CAF50" />
    </LinearLayout>

    <!-- Task List Container -->
    <LinearLayout
        android:id="@+id/tasks_container"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:layout_marginTop="12dp" />

</LinearLayout>
```

### 3. Widget Info
创建 `android/app/src/main/res/xml/today_tasks_widget_info.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:initialLayout="@layout/widget_today_tasks"
    android:minWidth="250dp"
    android:minHeight="180dp"
    android:previewImage="@drawable/widget_preview"
    android:resizeMode="horizontal|vertical"
    android:updatePeriodMillis="1800000"
    android:widgetCategory="home_screen"
    android:description="@string/widget_description" />
```

### 4. AndroidManifest.xml
在 `android/app/src/main/AndroidManifest.xml` 中添加：

```xml
<receiver
    android:name=".TodayTasksWidgetProvider"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/today_tasks_widget_info" />
</receiver>
```

## iOS 原生实现

### 文件位置
需要创建 Widget Extension

### 1. 添加 Widget Extension
在 Xcode 中：
1. File → New → Target
2. 选择 "Widget Extension"
3. 命名为 "TodayTasksWidget"

### 2. Widget 实现
`ios/TodayTasksWidget/TodayTasksWidget.swift`:

```swift
import WidgetKit
import SwiftUI

struct TaskEntry: TimelineEntry {
    let date: Date
    let tasks: [TaskItem]
    let taskCount: Int
    let completedCount: Int
}

struct TaskItem: Identifiable {
    let id: String
    let title: String
    let priority: String
    let dueAt: Date?
    let isOverdue: Bool
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(date: Date(), tasks: [], taskCount: 0, completedCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let entry = TaskEntry(date: Date(), tasks: [], taskCount: 0, completedCount: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Read data from UserDefaults shared with main app
        let sharedDefaults = UserDefaults(suiteName: "group.todolist.widget")
        let tasksJson = sharedDefaults?.string(forKey: "today_tasks") ?? "[]"
        let taskCount = sharedDefaults?.integer(forKey: "task_count") ?? 0
        let completedCount = sharedDefaults?.integer(forKey: "completed_count") ?? 0

        var tasks: [TaskItem] = []
        if let data = tasksJson.data(using: .utf8) {
            if let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                tasks = jsonArray.compactMap { dict in
                    guard let id = dict["id"] as? String,
                          let title = dict["title"] as? String,
                          let priority = dict["priority"] as? String else {
                        return nil
                    }
                    let isOverdue = dict["isOverdue"] as? Bool ?? false
                    return TaskItem(id: id, title: title, priority: priority,
                                   dueAt: nil, isOverdue: isOverdue)
                }
            }
        }

        let entry = TaskEntry(date: Date(), tasks: tasks,
                             taskCount: taskCount, completedCount: completedCount)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(900)))
        completion(timeline)
    }
}

struct TodayTasksWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("今日任务")
                .font(.headline)
                .foregroundColor(.primary)

            HStack {
                Text("\(entry.taskCount) 个任务")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("已完成 \(entry.completedCount)")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }

            ForEach(entry.tasks.prefix(5)) { task in
                HStack {
                    Circle()
                        .fill(task.isOverdue ? Color.red : Color.blue)
                        .frame(width: 8, height: 8)
                    Text(task.title)
                        .font(.subheadline)
                        .lineLimit(1)
                    Spacer()
                }
            }
        }
        .padding()
    }
}

@main
struct TodayTasksWidget: Widget {
    let kind: String = "TodayTasksWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodayTasksWidgetView(entry: entry)
        }
        .configurationDisplayName("今日任务")
        .description("显示今天的待办任务")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
```

## 使用方法

### 初始化
在 `main.dart` 中初始化小部件回调：

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize widget callbacks
  await WidgetService.initializeCallbacks();

  runApp(const ProviderScope(child: MyApp()));
}
```

### 更新小部件数据
当任务发生变化时：

```dart
final widgetService = ref.read(widgetServiceProvider);
final tasks = await taskRepository.getAllTasks();
await widgetService.updateTodayTasks(tasks);
```

## 注意事项

1. **Android 权限**: 无需额外权限
2. **iOS App Group**: 需要配置 App Group ID 为 `group.todolist.widget`
3. **更新频率**: Android 最快30分钟，iOS 15分钟
4. **数据大小**: 保持小部件数据在 100KB 以内
5. **测试**: 在真机上测试小部件功能

## 调试

### Android
```bash
adb shell dumpsys appwidget
```

### iOS
使用 Xcode 的 Widget Extension Scheme 进行调试

## 未来改进

- [ ] 支持多种小部件尺寸
- [ ] 添加小部件配置选项
- [ ] 实现倒计时小部件
- [ ] 支持小部件主题切换
- [ ] 添加快速操作按钮
