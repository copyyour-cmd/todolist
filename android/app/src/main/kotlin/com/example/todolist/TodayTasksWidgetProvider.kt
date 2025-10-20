package com.example.todolist

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

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
        private data class DemoTask(val title: String, val color: Int)

        private fun getDemoTasks(size: String): List<DemoTask> {
            val allTasks = listOf(
                DemoTask("完成项目报告", 0xFFD32F2F.toInt()),  // critical - red
                DemoTask("回复客户邮件", 0xFFF57C00.toInt()),  // high - orange
                DemoTask("准备会议资料", 0xFF1976D2.toInt()),  // medium - blue
                DemoTask("整理工作文档", 0xFF388E3C.toInt()),  // low - green
                DemoTask("预约牙医检查", 0xFF1976D2.toInt()),  // medium - blue
            )

            val maxTasks = when (size) {
                "small" -> 3
                "large" -> 5
                else -> 3  // medium
            }

            return allTasks.take(maxTasks)
        }

        private fun isDarkMode(context: Context): Boolean {
            val nightMode = context.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
            return nightMode == Configuration.UI_MODE_NIGHT_YES
        }

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            try {
                // 尝试获取小部件数据,如果失败使用默认值
                val widgetData = try {
                    HomeWidgetPlugin.getData(context)
                } catch (e: Exception) {
                    e.printStackTrace()
                    null
                }

                val tasksJson = widgetData?.getString("today_tasks", "[]") ?: "[]"
                val taskCount = widgetData?.getInt("task_count", 0) ?: 0
                val completedCount = widgetData?.getInt("completed_count", 0) ?: 0
                val configJson = widgetData?.getString("widget_config", "{}") ?: "{}"

            // Parse config
            val config = try {
                JSONObject(configJson)
            } catch (e: Exception) {
                JSONObject()
            }

            val size = config.optString("size", "medium")
            val theme = config.optString("theme", "auto")
            val backgroundColor = config.optInt("backgroundColor", 0xFFFFFFFF.toInt())
            val textColor = config.optInt("textColor", 0xFF000000.toInt())
            val showQuickAdd = config.optBoolean("showQuickAdd", true)
            val showRefresh = config.optBoolean("showRefresh", true)

            // Choose layout based on size
            val layoutId = when (size) {
                "small" -> R.layout.widget_small
                "large" -> R.layout.widget_large
                else -> R.layout.widget_medium
            }

            val views = RemoteViews(context.packageName, layoutId)

            // Detect dark mode and set appropriate colors
            val isDark = isDarkMode(context)
            val defaultBgColor = if (isDark) 0xFF1E1E1E.toInt() else 0xFFFFFFFF.toInt()
            val defaultTextColor = if (isDark) 0xFFE0E0E0.toInt() else 0xFF333333.toInt()
            val defaultSubTextColor = if (isDark) 0xFF999999.toInt() else 0xFF666666.toInt()

            // Apply theme colors (use config or defaults based on dark mode)
            val finalBgColor = if (backgroundColor == 0xFFFFFFFF.toInt()) defaultBgColor else backgroundColor
            val finalTextColor = if (textColor == 0xFF000000.toInt()) defaultTextColor else textColor

            views.setInt(R.id.widget_container, "setBackgroundColor", finalBgColor)
            views.setTextColor(R.id.widget_title, finalTextColor)
            views.setTextColor(R.id.task_count, defaultSubTextColor)

            // Set task count
            views.setTextViewText(R.id.task_count, "$taskCount 个任务")

            if (size != "small") {
                views.setTextViewText(R.id.completed_count, "已完成 $completedCount")
                views.setTextColor(R.id.completed_count, 0xFF4CAF50.toInt())
            }

            // Parse and display tasks
            try {
                val tasksArray = JSONArray(tasksJson)
                views.removeAllViews(R.id.tasks_container)

                // If no data, show demo data for preview
                val useDemo = tasksArray.length() == 0 && taskCount == 0

                if (useDemo) {
                    // Show demo data for widget picker preview
                    views.setViewVisibility(R.id.widget_empty_text, android.view.View.GONE)
                    views.setViewVisibility(R.id.tasks_container, android.view.View.VISIBLE)

                    // Update demo counts
                    views.setTextViewText(R.id.task_count, "3 个任务")
                    if (size != "small") {
                        views.setTextViewText(R.id.completed_count, "已完成 1")
                    }

                    // Create demo tasks
                    val demoTasks = getDemoTasks(size)
                    for (demoTask in demoTasks) {
                        val taskView = RemoteViews(context.packageName, R.layout.widget_task_item)
                        taskView.setTextViewText(R.id.task_title, demoTask.title)
                        taskView.setInt(R.id.priority_indicator, "setBackgroundColor", demoTask.color)

                        // Demo tasks have no click action
                        views.addView(R.id.tasks_container, taskView)
                    }
                } else if (tasksArray.length() == 0) {
                    views.setTextViewText(R.id.widget_empty_text, "暂无待办任务")
                    views.setViewVisibility(R.id.widget_empty_text, android.view.View.VISIBLE)
                    views.setViewVisibility(R.id.tasks_container, android.view.View.GONE)
                } else {
                    views.setViewVisibility(R.id.widget_empty_text, android.view.View.GONE)
                    views.setViewVisibility(R.id.tasks_container, android.view.View.VISIBLE)

                    val maxTasks = if (size == "small") 3 else if (size == "large") 10 else 5
                    for (i in 0 until minOf(tasksArray.length(), maxTasks)) {
                        val task = tasksArray.getJSONObject(i)
                        val taskId = task.getString("id")
                        val title = task.getString("title")
                        val priority = task.getString("priority")
                        val isOverdue = task.optBoolean("isOverdue", false)

                        val taskView = RemoteViews(context.packageName, R.layout.widget_task_item)
                        taskView.setTextViewText(R.id.task_title, title)

                        // Set priority color
                        val priorityColor = when (priority) {
                            "critical" -> 0xFFD32F2F.toInt()
                            "high" -> 0xFFF57C00.toInt()
                            "medium" -> 0xFF1976D2.toInt()
                            "low" -> 0xFF388E3C.toInt()
                            else -> 0xFF757575.toInt()
                        }
                        taskView.setInt(R.id.priority_indicator, "setBackgroundColor", priorityColor)

                        // Set click intent for task
                        val taskIntent = Intent(context, MainActivity::class.java)
                        taskIntent.data = Uri.parse("todolist://task/$taskId")
                        taskIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                        val taskPendingIntent = PendingIntent.getActivity(
                            context,
                            taskId.hashCode(),
                            taskIntent,
                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                        )
                        taskView.setOnClickPendingIntent(R.id.task_item_container, taskPendingIntent)

                        views.addView(R.id.tasks_container, taskView)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

            // Set widget container click intent
            val intent = Intent(context, MainActivity::class.java)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            // Set add button click intent (if visible and exists in layout)
            if (showQuickAdd && size != "small") {
                try {
                    views.setViewVisibility(R.id.widget_add_button, android.view.View.VISIBLE)
                    val addTaskIntent = Intent(context, MainActivity::class.java)
                    addTaskIntent.data = Uri.parse("todolist://add_task")
                    addTaskIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                    val addTaskPendingIntent = PendingIntent.getActivity(
                        context,
                        1,
                        addTaskIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    views.setOnClickPendingIntent(R.id.widget_add_button, addTaskPendingIntent)
                } catch (e: Exception) {
                    // Add button doesn't exist in this layout
                    e.printStackTrace()
                }
            }

            // Set refresh button click intent (if visible)
            if (showRefresh) {
                try {
                    views.setViewVisibility(R.id.widget_refresh_button, android.view.View.VISIBLE)
                    val refreshIntent = Intent(context, MainActivity::class.java)
                    refreshIntent.data = Uri.parse("todolist://refresh_widget")
                    refreshIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                    val refreshPendingIntent = PendingIntent.getActivity(
                        context,
                        2,
                        refreshIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    views.setOnClickPendingIntent(R.id.widget_refresh_button, refreshPendingIntent)
                } catch (e: Exception) {
                    // Refresh button doesn't exist in this layout or another error occurred
                    e.printStackTrace()
                }
            }

                appWidgetManager.updateAppWidget(appWidgetId, views)
            } catch (e: Exception) {
                e.printStackTrace()
                // 如果出错,创建一个基本的错误提示视图
                val errorViews = RemoteViews(context.packageName, R.layout.widget_small)
                errorViews.setInt(R.id.widget_container, "setBackgroundColor", 0xFFFFFFFF.toInt())
                errorViews.setTextViewText(R.id.widget_title, "待办清单")
                errorViews.setTextViewText(R.id.task_count, "点击打开应用")
                errorViews.setViewVisibility(R.id.widget_empty_text, android.view.View.GONE)
                errorViews.setViewVisibility(R.id.tasks_container, android.view.View.GONE)

                // Set click intent
                val intent = Intent(context, MainActivity::class.java)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                errorViews.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                appWidgetManager.updateAppWidget(appWidgetId, errorViews)
            }
        }
    }
}
