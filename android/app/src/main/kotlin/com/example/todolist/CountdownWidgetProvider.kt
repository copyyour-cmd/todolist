package com.example.todolist

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class CountdownWidgetProvider : AppWidgetProvider() {
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
            val taskId = widgetData.getString("countdown_task_id", "")
            val taskTitle = widgetData.getString("countdown_task_title", "暂无任务")
            val countdownSeconds = widgetData.getInt("countdown_seconds", 0)
            val priority = widgetData.getString("countdown_priority", "none")

            val views = RemoteViews(context.packageName, R.layout.widget_countdown)

            // Set task title
            views.setTextViewText(R.id.countdown_task_title, taskTitle)

            // Format countdown time
            val hours = countdownSeconds / 3600
            val minutes = (countdownSeconds % 3600) / 60
            val seconds = countdownSeconds % 60
            val timeText = String.format("%02d:%02d:%02d", hours, minutes, seconds)
            views.setTextViewText(R.id.countdown_time, timeText)

            // Set countdown label based on time
            val label = when {
                countdownSeconds <= 0 -> "已逾期"
                countdownSeconds < 3600 -> "剩余不足1小时"
                countdownSeconds < 86400 -> "剩余不足1天"
                else -> "剩余时间"
            }
            views.setTextViewText(R.id.countdown_label, label)

            // Set priority color
            val priorityColor = when (priority) {
                "critical" -> 0xFFD32F2F.toInt()
                "high" -> 0xFFF57C00.toInt()
                "medium" -> 0xFF1976D2.toInt()
                "low" -> 0xFF388E3C.toInt()
                else -> 0xFF757575.toInt()
            }
            views.setInt(R.id.priority_indicator, "setBackgroundColor", priorityColor)

            // Set time color based on urgency
            val timeColor = when {
                countdownSeconds <= 0 -> 0xFFD32F2F.toInt()
                countdownSeconds < 3600 -> 0xFFF57C00.toInt()
                countdownSeconds < 86400 -> 0xFF1976D2.toInt()
                else -> 0xFF388E3C.toInt()
            }
            views.setTextColor(R.id.countdown_time, timeColor)

            // Set click intent
            if (!taskId.isNullOrEmpty()) {
                val intent = Intent(context, MainActivity::class.java)
                intent.data = Uri.parse("todolist://task/$taskId")
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
