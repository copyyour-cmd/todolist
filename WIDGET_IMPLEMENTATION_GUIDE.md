# 桌面小组件实现指南

## 📱 功能概述

本文档详细说明如何实现TodoList应用的桌面小组件增强功能。

### 支持的小组件类型

1. **今日任务小组件** (TodayTasksWidget)
   - 小尺寸 (2x2): 显示任务数量和完成进度
   - 中尺寸 (4x2): 显示前3个任务列表
   - 大尺寸 (4x4): 显示完整任务列表（最多10个）

2. **专注统计小组件** (FocusStatsWidget)
   - 显示今日/本周/总计专注时长
   - 显示连续专注天数
   - 提供快速启动专注模式按钮

3. **灵感速记小组件** (QuickIdeaWidget)
   - 显示最近灵感
   - 快速添加新灵感
   - 显示灵感统计

## 🏗️ 架构设计

### Flutter 层 (Dart)

#### 1. 数据模型

文件: `lib/src/domain/entities/widget_data.dart`

```dart
/// 小组件类型
enum WidgetType {
  todayTasks,
  focusStats,
  quickIdea,
}

/// 今日任务小组件数据
class TodayTasksWidgetData {
  final int totalTasks;
  final int completedTasks;
  final List<TaskWidgetItem> tasks;

  int get pendingTasks => totalTasks - completedTasks;
  double get completionRate => totalTasks > 0 ? completedTasks / totalTasks : 0.0;
}

/// 任务小组件项目
class TaskWidgetItem {
  final String id;
  final String title;
  final bool isCompleted;
  final String? priority;
  final DateTime? dueAt;
}
```

#### 2. 小组件服务

文件: `lib/src/features/widgets/application/widget_service.dart`

主要方法：
- `updateAllWidgets()`: 更新所有小组件
- `updateTodayTasksWidget()`: 更新今日任务小组件
- `updateFocusStatsWidget()`: 更新专注统计小组件
- `updateQuickIdeaWidget()`: 更新灵感小组件
- `handleWidgetClick(String? action)`: 处理小组件点击事件

#### 3. 数据同步

使用 `home_widget` 包提供的API：

```dart
// 保存数据
await HomeWidget.saveWidgetData('total_tasks', 10);
await HomeWidget.saveWidgetData('completed_tasks', 5);

// 更新小组件
await HomeWidget.updateWidget(
  androidName: 'TodayTasksWidgetProvider',
  iOSName: 'TodayTasksWidget',
);
```

### Android 层 (Kotlin)

#### 1. 文件结构

```
android/app/src/main/
├── AndroidManifest.xml
├── kotlin/com/example/todolist/
│   └── widgets/
│       ├── TodayTasksWidgetProvider.kt
│       ├── FocusStatsWidgetProvider.kt
│       └── QuickIdeaWidgetProvider.kt
└── res/
    ├── layout/
    │   ├── widget_today_tasks_small.xml
    │   ├── widget_today_tasks_medium.xml
    │   ├── widget_today_tasks_large.xml
    │   ├── widget_focus_stats.xml
    │   └── widget_quick_idea.xml
    └── xml/
        ├── widget_today_tasks_small_info.xml
        ├── widget_today_tasks_medium_info.xml
        └── widget_today_tasks_large_info.xml
```

#### 2. Widget Provider 示例

文件: `android/app/src/main/kotlin/.../TodayTasksWidgetProvider.kt`

```kotlin
class TodayTasksWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val totalTasks = widgetData.getInt("total_tasks", 0)
        val completedTasks = widgetData.getInt("completed_tasks", 0)
        val tasksJson = widgetData.getString("tasks_json", "[]")

        val remoteViews = RemoteViews(
            context.packageName,
            R.layout.widget_today_tasks_medium
        )

        // 更新UI
        remoteViews.setTextViewText(
            R.id.widget_total_tasks,
            totalTasks.toString()
        )
        remoteViews.setTextViewText(
            R.id.widget_completed_tasks,
            completedTasks.toString()
        )

        // 设置进度条
        val progress = if (totalTasks > 0) {
            (completedTasks * 100) / totalTasks
        } else 0
        remoteViews.setProgressBar(
            R.id.widget_progress,
            100,
            progress,
            false
        )

        // 设置点击事件
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            context, 0, intent, PendingIntent.FLAG_IMMUTABLE
        )
        remoteViews.setOnClickPendingIntent(
            R.id.widget_container,
            pendingIntent
        )

        appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
    }
}
```

#### 3. Widget 布局示例 (2x2 小尺寸)

文件: `res/layout/widget_today_tasks_small.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:padding="8dp"
    android:background="@drawable/widget_background">

    <TextView
        android:id="@+id/widget_title"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="今日任务"
        android:textSize="14sp"
        android:textStyle="bold"
        android:textColor="#FFFFFF" />

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_centerInParent="true"
        android:orientation="vertical"
        android:gravity="center">

        <TextView
            android:id="@+id/widget_task_count"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="5"
            android:textSize="32sp"
            android:textStyle="bold"
            android:textColor="#FFFFFF" />

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="个待办"
            android:textSize="12sp"
            android:textColor="#CCFFFFFF" />

        <ProgressBar
            android:id="@+id/widget_progress"
            style="?android:attr/progressBarStyleHorizontal"
            android:layout_width="match_parent"
            android:layout_height="4dp"
            android:layout_marginTop="8dp"
            android:progressTint="#4CAF50"
            android:max="100" />
    </LinearLayout>

    <TextView
        android:id="@+id/widget_update_time"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_alignParentBottom="true"
        android:text="刚刚更新"
        android:textSize="10sp"
        android:textColor="#99FFFFFF" />
</RelativeLayout>
```

#### 4. Widget 布局示例 (4x2 中尺寸)

文件: `res/layout/widget_today_tasks_medium.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="12dp"
    android:background="@drawable/widget_background">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal">

        <TextView
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:text="今日任务"
            android:textSize="16sp"
            android:textStyle="bold"
            android:textColor="#FFFFFF" />

        <TextView
            android:id="@+id/widget_completion_rate"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="50%"
            android:textSize="14sp"
            android:textColor="#4CAF50" />
    </LinearLayout>

    <ListView
        android:id="@+id/widget_task_list"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1"
        android:layout_marginTop="8dp"
        android:divider="@android:color/transparent"
        android:dividerHeight="4dp" />

    <ProgressBar
        android:id="@+id/widget_progress"
        style="?android:attr/progressBarStyleHorizontal"
        android:layout_width="match_parent"
        android:layout_height="4dp"
        android:layout_marginTop="8dp"
        android:progressTint="#4CAF50"
        android:max="100" />
</LinearLayout>
```

#### 5. Widget 配置文件

文件: `res/xml/widget_today_tasks_medium_info.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="250dp"
    android:minHeight="110dp"
    android:updatePeriodMillis="1800000"
    android:initialLayout="@layout/widget_today_tasks_medium"
    android:resizeMode="horizontal|vertical"
    android:widgetCategory="home_screen"
    android:previewImage="@drawable/widget_preview_medium"
    android:description="@string/widget_today_tasks_description" />
```

#### 6. AndroidManifest.xml 注册

```xml
<receiver
    android:name=".widgets.TodayTasksWidgetProvider"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
        <action android:name="com.example.todolist.COMPLETE_TASK" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/widget_today_tasks_medium_info" />
</receiver>
```

## 🎨 深色模式支持

### 1. 自动检测系统主题

```kotlin
private fun isDarkMode(context: Context): Boolean {
    val nightMode = context.resources.configuration.uiMode and
        Configuration.UI_MODE_NIGHT_MASK
    return nightMode == Configuration.UI_MODE_NIGHT_YES
}
```

### 2. 创建深色主题布局

创建 `res/layout-night/` 目录，放置深色版本的布局文件。

或者在代码中动态设置：

```kotlin
if (isDarkMode(context)) {
    remoteViews.setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_background_dark
    )
    remoteViews.setTextColor(R.id.widget_title, 0xFFFFFFFF.toInt())
} else {
    remoteViews.setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_background_light
    )
    remoteViews.setTextColor(R.id.widget_title, 0xFF000000.toInt())
}
```

## ⚡ 快速完成任务功能

### 1. Flutter 端发送完成任务请求

```dart
Future<void> completeTaskFromWidget(String taskId) async {
  // 发送广播通知原生层
  await HomeWidget.saveWidgetData('action', 'complete_task');
  await HomeWidget.saveWidgetData('task_id', taskId);
  await HomeWidget.updateWidget(
    androidName: 'TodayTasksWidgetProvider',
  );
}
```

### 2. Android 端处理完成任务

```kotlin
class TaskCompletionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val taskId = intent.getStringExtra("task_id") ?: return

        // 发送到Flutter层处理
        val flutterIntent = Intent(context, MainActivity::class.java).apply {
            action = "COMPLETE_TASK"
            putExtra("task_id", taskId)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        context.startActivity(flutterIntent)
    }
}
```

### 3. 任务项布局（可点击完成）

```xml
<LinearLayout
    android:id="@+id/task_item"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="horizontal"
    android:padding="4dp">

    <CheckBox
        android:id="@+id/task_checkbox"
        android:layout_width="24dp"
        android:layout_height="24dp"
        android:clickable="true" />

    <TextView
        android:id="@+id/task_title"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:layout_marginStart="8dp"
        android:textSize="14sp"
        android:textColor="#FFFFFF" />
</LinearLayout>
```

设置点击事件：

```kotlin
val checkboxIntent = Intent(context, TaskCompletionReceiver::class.java).apply {
    action = "com.example.todolist.COMPLETE_TASK"
    putExtra("task_id", taskId)
}
val checkboxPendingIntent = PendingIntent.getBroadcast(
    context,
    taskId.hashCode(),
    checkboxIntent,
    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
)
remoteViews.setOnClickPendingIntent(R.id.task_checkbox, checkboxPendingIntent)
```

## 🔄 定时更新策略

### 1. 在Application中初始化

```kotlin
class TodoListApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        // 设置定时更新
        val workRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(
            30, TimeUnit.MINUTES
        ).build()

        WorkManager.getInstance(this)
            .enqueueUniquePeriodicWork(
                "widget_update",
                ExistingPeriodicWorkPolicy.KEEP,
                workRequest
            )
    }
}
```

### 2. Worker实现

```kotlin
class WidgetUpdateWorker(
    context: Context,
    params: WorkerParameters
) : Worker(context, params) {

    override fun doWork(): Result {
        return try {
            val appWidgetManager = AppWidgetManager.getInstance(applicationContext)

            // 更新所有Today Tasks小组件
            val componentName = ComponentName(
                applicationContext,
                TodayTasksWidgetProvider::class.java
            )
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

            val intent = Intent(applicationContext, TodayTasksWidgetProvider::class.java)
            intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
            applicationContext.sendBroadcast(intent)

            Result.success()
        } catch (e: Exception) {
            Result.failure()
        }
    }
}
```

## 📊 使用示例

### 在应用中更新小组件

```dart
// 在任务列表变化时
class TaskListProvider extends StateNotifier<List<Task>> {
  final WidgetService _widgetService;

  Future<void> addTask(Task task) async {
    state = [...state, task];

    // 更新小组件
    await _widgetService.updateTodayTasksWidget();
  }

  Future<void> completeTask(String taskId) async {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(status: TaskStatus.completed)
        else
          task
    ];

    // 更新小组件
    await _widgetService.updateTodayTasksWidget();
  }
}
```

### 在专注模式结束时更新

```dart
class FocusTimerService {
  final WidgetService _widgetService;

  Future<void> completeSession(FocusSession session) async {
    await _repository.save(session);

    // 更新专注统计小组件
    await _widgetService.updateFocusStatsWidget();
  }
}
```

## 🎯 实现优先级

1. ✅ **已完成**: Flutter数据层和服务层
2. ⚠️ **需要实现**: Android原生小组件代码
3. ⚠️ **需要实现**: iOS原生小组件代码（WidgetKit）

## 📝 注意事项

1. **性能优化**: 小组件更新频率不要太高，建议30分钟一次
2. **数据同步**: 使用SharedPreferences确保数据一致性
3. **错误处理**: 小组件代码要有完善的异常处理
4. **电池优化**: 避免频繁唤醒应用
5. **尺寸适配**: 不同设备屏幕尺寸要做好适配

## 🔗 相关资源

- [home_widget文档](https://pub.dev/packages/home_widget)
- [Android App Widgets指南](https://developer.android.com/guide/topics/appwidgets)
- [iOS WidgetKit文档](https://developer.apple.com/documentation/widgetkit)
