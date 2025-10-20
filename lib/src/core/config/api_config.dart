/// API配置
class ApiConfig {
  /// 云服务器基础URL
  static const String baseUrl = 'http://43.156.6.206:3000';

  /// API版本
  static const String apiVersion = 'v1';

  /// API端点
  static const String authPath = '/api/auth';
  static const String backupPath = '/api/backup';

  /// 认证相关端点
  static const String registerEndpoint = '$authPath/register';
  static const String loginEndpoint = '$authPath/login';
  static const String logoutEndpoint = '$authPath/logout';
  static const String refreshTokenEndpoint = '$authPath/refresh-token';
  static const String getMeEndpoint = '$authPath/me';

  /// 备份相关端点
  static const String createBackupEndpoint = '$backupPath/create';
  static const String restoreBackupEndpoint = '$backupPath/restore'; // + /{backupId}
  static const String backupListEndpoint = '$backupPath/list';
  static const String backupDetailEndpoint = backupPath; // + /{backupId}
  static const String deleteBackupEndpoint = backupPath; // + /{backupId}
  static const String backupHistoryEndpoint = '$backupPath/history/list';

  /// 任务相关端点
  static const String tasksPath = '/api/tasks';
  static const String getTasksEndpoint = tasksPath;
  static const String createTaskEndpoint = tasksPath;
  static const String updateTaskEndpoint = tasksPath; // + /{taskId}
  static const String deleteTaskEndpoint = tasksPath; // + /{taskId}
  static const String batchUpdateTasksEndpoint = '$tasksPath/batch/update';

  /// 同步相关端点
  static const String syncPath = '/api/sync';
  static const String syncDataEndpoint = syncPath;
  static const String syncStatusEndpoint = '$syncPath/status';
  static const String fullSyncEndpoint = '$syncPath/full';

  /// 用户相关端点
  static const String userPath = '/api/user';
  static const String profileEndpoint = '$userPath/profile';
  static const String changePasswordEndpoint = '$userPath/change-password';
  static const String uploadAvatarEndpoint = '$userPath/avatar';
  static const String deleteAccountEndpoint = '$userPath/account';

  /// 密码重置端点
  static const String passwordPath = '/api/password';
  static const String resetRequestEndpoint = '$passwordPath/reset-request';
  static const String verifyTokenEndpoint = '$passwordPath/verify-token';
  static const String resetPasswordEndpoint = '$passwordPath/reset';

  /// 设备管理端点
  static const String devicesPath = '/api/devices';
  static const String getDevicesEndpoint = devicesPath;
  static const String logoutDeviceEndpoint = devicesPath; // + /{deviceId}
  static const String logoutOthersEndpoint = '$devicesPath/logout-others';

  /// 请求超时配置（秒）
  static const int connectTimeout = 30;
  static const int receiveTimeout = 60;
  static const int sendTimeout = 60;

  /// 备份上传超时（秒）- 备份可能较大，需要更长的超时时间
  static const int backupUploadTimeout = 180;

  /// 获取完整URL
  static String getUrl(String endpoint) => '$baseUrl$endpoint';

  /// 获取备份详情URL
  static String getBackupDetailUrl(int backupId) => '$baseUrl$backupPath/$backupId';

  /// 获取备份恢复URL
  static String getRestoreBackupUrl(int backupId) => '$baseUrl$backupPath/restore/$backupId';

  /// 获取备份删除URL
  static String getDeleteBackupUrl(int backupId) => '$baseUrl$backupPath/$backupId';
}
