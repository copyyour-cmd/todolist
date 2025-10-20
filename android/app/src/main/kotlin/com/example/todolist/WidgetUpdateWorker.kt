package com.example.todolist

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import androidx.work.Worker
import androidx.work.WorkerParameters

/**
 * Worker for periodic widget updates
 * Updates widgets in the background to ensure they stay fresh
 */
class WidgetUpdateWorker(
    private val context: Context,
    params: WorkerParameters
) : Worker(context, params) {

    override fun doWork(): Result {
        return try {
            val appWidgetManager = AppWidgetManager.getInstance(context)

            // Update TodayTasks widgets (all sizes)
            updateWidgets(context, appWidgetManager, TodayTasksWidgetSmall::class.java)
            updateWidgets(context, appWidgetManager, TodayTasksWidgetMedium::class.java)
            updateWidgets(context, appWidgetManager, TodayTasksWidgetLarge::class.java)

            // Update Countdown widgets
            updateWidgets(context, appWidgetManager, CountdownWidgetProvider::class.java)

            Result.success()
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure()
        }
    }

    private fun updateWidgets(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetClass: Class<*>
    ) {
        try {
            val componentName = ComponentName(context, widgetClass)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

            if (appWidgetIds.isNotEmpty()) {
                val intent = Intent(context, widgetClass)
                intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
                context.sendBroadcast(intent)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
