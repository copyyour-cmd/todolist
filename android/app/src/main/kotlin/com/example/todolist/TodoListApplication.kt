package com.example.todolist

import android.app.Application
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

/**
 * Application class for TodoList app
 * Initializes WorkManager for periodic widget updates
 */
class TodoListApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        // Initialize periodic widget updates
        initializeWidgetUpdates()
    }

    private fun initializeWidgetUpdates() {
        try {
            // Create periodic work request for widget updates (every 30 minutes)
            val workRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(
                30, TimeUnit.MINUTES
            ).build()

            // Enqueue the work with unique name to prevent duplicates
            WorkManager.getInstance(this)
                .enqueueUniquePeriodicWork(
                    "widget_update",
                    ExistingPeriodicWorkPolicy.KEEP,
                    workRequest
                )
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
