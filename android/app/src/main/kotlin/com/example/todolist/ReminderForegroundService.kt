package com.example.todolist

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

/**
 * 前台服务 - 保持应用提醒功能持续运行
 * 即使应用在后台也能确保任务提醒正常工作
 */
class ReminderForegroundService : Service() {

    companion object {
        private const val CHANNEL_ID = "reminder_service_channel"
        private const val CHANNEL_NAME = "任务提醒服务"
        private const val NOTIFICATION_ID = 999999

        fun startService(context: Context) {
            val intent = Intent(context, ReminderForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stopService(context: Context) {
            val intent = Intent(context, ReminderForegroundService::class.java)
            context.stopService(intent)
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // 创建通知
        val notification = createNotification()

        // 启动前台服务
        startForeground(NOTIFICATION_ID, notification)

        // START_STICKY: 服务被杀死后自动重启
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_LOW // 低重要性,不打扰用户
            ).apply {
                description = "保持任务提醒功能运行"
                setShowBadge(false)
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        // 点击通知打开应用
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("任务提醒保护中")
            .setContentText("Dog10 正在后台监听您的任务提醒")
            .setSmallIcon(android.R.drawable.ic_menu_agenda) // 使用系统图标
            .setContentIntent(pendingIntent)
            .setOngoing(true) // 不可滑动删除
            .setPriority(NotificationCompat.PRIORITY_LOW) // 低优先级
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
    }
}
