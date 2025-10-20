package com.example.todolist

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray

class TodoListWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val tasksJson = widgetData.getString("widget_tasks", "[]")
        val taskCount = widgetData.getInt("widget_task_count", 0)

        val views = RemoteViews(context.packageName, R.layout.todo_list_widget)

        // 设置标题
        views.setTextViewText(R.id.widget_title, "今日待办 ($taskCount)")

        // 解析任务列表
        try {
            val tasksArray = JSONArray(tasksJson)

            // 清空现有任务视图
            views.removeAllViews(R.id.widget_tasks_container)

            if (tasksArray.length() == 0) {
                views.setTextViewText(R.id.widget_empty_text, "暂无待办任务")
                views.setViewVisibility(R.id.widget_empty_text, android.view.View.VISIBLE)
                views.setViewVisibility(R.id.widget_tasks_container, android.view.View.GONE)
            } else {
                views.setViewVisibility(R.id.widget_empty_text, android.view.View.GONE)
                views.setViewVisibility(R.id.widget_tasks_container, android.view.View.VISIBLE)

                for (i in 0 until minOf(tasksArray.length(), 5)) {
                    val task = tasksArray.getJSONObject(i)
                    val title = task.getString("title")
                    val priority = task.getString("priority")

                    val taskView = RemoteViews(context.packageName, R.layout.widget_task_item)
                    taskView.setTextViewText(R.id.task_title, title)

                    // 根据优先级设置颜色
                    val priorityColor = when (priority) {
                        "urgent" -> android.graphics.Color.parseColor("#D32F2F")
                        "high" -> android.graphics.Color.parseColor("#F57C00")
                        "medium" -> android.graphics.Color.parseColor("#1976D2")
                        else -> android.graphics.Color.parseColor("#757575")
                    }
                    taskView.setInt(R.id.priority_indicator, "setBackgroundColor", priorityColor)

                    views.addView(R.id.widget_tasks_container, taskView)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        // 设置点击事件 - 打开应用
        val intent = Intent(context, MainActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        val pendingIntent = android.app.PendingIntent.getActivity(
            context,
            0,
            intent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

        // 设置添加任务按钮点击事件
        val addTaskIntent = Intent(context, MainActivity::class.java)
        addTaskIntent.data = Uri.parse("todolist://add_task")
        addTaskIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        val addTaskPendingIntent = android.app.PendingIntent.getActivity(
            context,
            1,
            addTaskIntent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_add_button, addTaskPendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
