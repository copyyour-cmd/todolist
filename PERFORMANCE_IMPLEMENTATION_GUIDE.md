# 性能优化实施指南

本文档提供性能优化的详细实施步骤和代码示例。

---

## 快速开始 - 第一周优化清单

### Day 1: 数据库索引优化 ⚡

#### 步骤1: 连接到MySQL数据库
```bash
mysql -u root -p
use todolist_cloud;
```

#### 步骤2: 执行索引创建脚本
```sql
-- 复制以下SQL并执行

-- 1. 任务查询优化索引
CREATE INDEX idx_user_deleted_created
ON user_tasks(user_id, deleted_at, created_at DESC);

-- 2. 按列表查询索引
CREATE INDEX idx_user_list_status
ON user_tasks(user_id, list_id, status);

-- 3. 增量同步索引
CREATE INDEX idx_user_updated
ON user_tasks(user_id, updated_at DESC);

-- 4. 验证索引
SHOW INDEX FROM user_tasks;

-- 5. 分析表
ANALYZE TABLE user_tasks;
```

#### 步骤3: 验证查询性能
```sql
-- 测试查询性能
EXPLAIN SELECT * FROM user_tasks
WHERE user_id = 1 AND deleted_at IS NULL
ORDER BY created_at DESC LIMIT 50;

-- 应该看到: type: ref, key: idx_user_deleted_created
```

**预期改进**: 查询时间从 50ms 降至 5ms

---

### Day 2: 连接池优化

#### 修改文件: `server/config/database.js`

```javascript
import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

// 优化后的连接池配置
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'goodboy',
  database: process.env.DB_NAME || 'todolist_cloud',

  // === 新增优化配置 ===
  connectionLimit: 50,              // 提升连接数
  queueLimit: 100,                  // 限制队列
  waitForConnections: true,

  // 连接保活
  enableKeepAlive: true,
  keepAliveInitialDelay: 10000,

  // 连接复用
  maxIdle: 10,
  idleTimeout: 60000,

  // 字符集
  charset: 'utf8mb4',
  timezone: '+00:00',
});

// 连接池监控 (可选)
pool.on('acquire', (connection) => {
  console.log('Connection %d acquired', connection.threadId);
});

pool.on('release', (connection) => {
  console.log('Connection %d released', connection.threadId);
});

// 定期监控
setInterval(() => {
  pool.query('SELECT 1').catch(err => {
    console.error('连接池健康检查失败:', err);
  });
}, 30000); // 每30秒检查一次

async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('✓ MySQL数据库连接成功');
    console.log(`  数据库: ${process.env.DB_NAME || 'todolist_cloud'}`);
    console.log(`  连接池大小: 50`);
    connection.release();
    return true;
  } catch (error) {
    console.error('✗ MySQL数据库连接失败:', error.message);
    return false;
  }
}

async function query(sql, params = []) {
  try {
    const [results] = await pool.execute(sql, params);
    return results;
  } catch (error) {
    console.error('数据库查询错误:', error);
    throw error;
  }
}

export { pool, testConnection, query };
```

**测试连接池**:
```bash
node server/test-connection.js
```

---

### Day 3-4: Flutter应用启动优化

#### 修改文件: `lib/src/bootstrap.dart`

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 现有imports...

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // === 优化1: 移除调试日志 ===
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  final stopwatch = Stopwatch()..start();

  // === 优化2: 并行初始化核心服务 ===
  final initResults = await Future.wait([
    // 方向锁定
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),

    // Hive初始化
    _initializeHive(),

    // SharedPreferences
    SharedPreferences.getInstance(),
  ]);

  final sharedPreferences = initResults[2] as SharedPreferences;

  if (kDebugMode) {
    print('核心服务初始化完成: ${stopwatch.elapsedMilliseconds}ms');
  }

  // === 优化3: 批量打开Hive Boxes ===
  final boxes = await _openAllBoxes();

  if (kDebugMode) {
    print('Hive Boxes打开完成: ${stopwatch.elapsedMilliseconds}ms');
  }

  // === 优化4: 快速创建Repositories ===
  final repositories = _createRepositories(boxes);

  if (kDebugMode) {
    print('Repositories创建完成: ${stopwatch.elapsedMilliseconds}ms');
  }

  // === 优化5: 延迟初始化非关键服务 ===
  final logger = const AppLogger();
  final idGenerator = IdGenerator();

  // 通知服务 - 异步初始化
  final notificationService = NotificationService(
    clock: const SystemClock(),
    logger: logger,
    enabled: true,
    systemAlarmService: SystemAlarmService(logger: logger),
  );

  // 在后台初始化通知
  Future.microtask(() async {
    await notificationService.init();
    if (kDebugMode) print('通知服务初始化完成');
  });

  // 演示数据填充 - 异步执行
  if (_seedDemoData) {
    Future.microtask(() async {
      final seeder = DemoDataSeeder(
        taskRepository: repositories.taskRepository,
        taskListRepository: repositories.taskListRepository,
        tagRepository: repositories.tagRepository,
        idGenerator: idGenerator,
        isEnabled: true,
      );
      await seeder.seedIfEmpty();
      if (kDebugMode) print('演示数据检查完成');
    });
  }

  // 附件清理 - 低优先级
  Future.delayed(const Duration(seconds: 5), () async {
    try {
      final cleanupService = AttachmentCleanupService(
        noteRepository: repositories.noteRepository,
        taskRepository: repositories.taskRepository,
        logger: logger,
      );
      await cleanupService.cleanupOrphanedFiles();
    } catch (e) {
      if (kDebugMode) print('附件清理失败: $e');
    }
  });

  // === 优化6: 快速创建Provider Container ===
  final container = ProviderContainer(
    observers: kReleaseMode ? [] : [AppProviderObserver(logger: logger)],
    overrides: [
      appLoggerProvider.overrideWithValue(logger),
      idGeneratorProvider.overrideWithValue(idGenerator),
      appSettingsRepositoryProvider.overrideWithValue(repositories.appSettingsRepository),
      taskRepositoryProvider.overrideWithValue(repositories.taskRepository),
      taskListRepositoryProvider.overrideWithValue(repositories.taskListRepository),
      tagRepositoryProvider.overrideWithValue(repositories.tagRepository),
      taskTemplateRepositoryProvider.overrideWithValue(repositories.taskTemplateRepository),
      habitRepositoryProvider.overrideWithValue(repositories.habitRepository),
      widgetConfigRepositoryProvider.overrideWithValue(repositories.widgetConfigRepository),
      noteRepositoryProvider.overrideWithValue(repositories.noteRepository),
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      notificationServiceProvider.overrideWithValue(notificationService),
    ],
  );

  if (kDebugMode) {
    print('总启动时间: ${stopwatch.elapsedMilliseconds}ms');
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.recordFlutterError(details);
  };

  await runZonedGuarded(
    () async {
      final app = await builder(container);
      runApp(
        UncontrolledProviderScope(
          container: container,
          child: OnboardingWrapper(
            sharedPreferences: sharedPreferences,
            child: app,
          ),
        ),
      );
    },
    (error, stackTrace) {
      logger.error('Uncaught zone error', error, stackTrace);
    },
  );
}

// === 辅助函数 ===

Future<void> _initializeHive() async {
  final hiveInitializer = HiveInitializer();
  await hiveInitializer.init();
}

class _Repositories {
  final HiveTaskRepository taskRepository;
  final HiveTaskListRepository taskListRepository;
  final HiveTagRepository tagRepository;
  final HiveAppSettingsRepository appSettingsRepository;
  final HiveTaskTemplateRepository taskTemplateRepository;
  final InMemoryHabitRepository habitRepository;
  final HiveWidgetConfigRepository widgetConfigRepository;
  final HiveNoteRepository noteRepository;

  _Repositories({
    required this.taskRepository,
    required this.taskListRepository,
    required this.tagRepository,
    required this.appSettingsRepository,
    required this.taskTemplateRepository,
    required this.habitRepository,
    required this.widgetConfigRepository,
    required this.noteRepository,
  });
}

Future<Map<String, Box>> _openAllBoxes() async {
  final boxes = await Future.wait([
    Hive.openBox<Task>(HiveBoxes.tasks),
    Hive.openBox<TaskList>(HiveBoxes.taskLists),
    Hive.openBox<Tag>(HiveBoxes.tags),
    Hive.openBox<AppSettings>(HiveBoxes.appSettings),
    Hive.openBox<TaskTemplate>(HiveBoxes.taskTemplates),
    Hive.openBox<WidgetConfig>(HiveBoxes.widgetConfigs),
    Hive.openBox<Note>(HiveBoxes.notes),
  ]);

  return {
    'tasks': boxes[0],
    'taskLists': boxes[1],
    'tags': boxes[2],
    'appSettings': boxes[3],
    'taskTemplates': boxes[4],
    'widgetConfigs': boxes[5],
    'notes': boxes[6],
  };
}

_Repositories _createRepositories(Map<String, Box> boxes) {
  return _Repositories(
    taskRepository: HiveTaskRepository(boxes['tasks']!),
    taskListRepository: HiveTaskListRepository(boxes['taskLists']!),
    tagRepository: HiveTagRepository(boxes['tags']!),
    appSettingsRepository: HiveAppSettingsRepository(boxes['appSettings']!),
    taskTemplateRepository: HiveTaskTemplateRepository(boxes['taskTemplates']!),
    habitRepository: InMemoryHabitRepository(),
    widgetConfigRepository: HiveWidgetConfigRepository(boxes['widgetConfigs']!),
    noteRepository: HiveNoteRepository(boxes['notes']!),
  );
}

const bool _seedDemoData = bool.fromEnvironment(
  'ENABLE_DEMO_SEED',
  defaultValue: true,
);
```

**测试启动性能**:
```bash
# 运行并检查控制台日志
flutter run --release
# 查看 "总启动时间" 输出
```

---

### Day 5-6: 列表渲染优化

#### 创建新文件: `lib/src/infrastructure/repositories/cached_task_repository.dart`

```dart
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';

/// 带缓存的任务仓库
class CachedTaskRepository implements TaskRepository {
  CachedTaskRepository(Box<Task> box) : _box = box;

  final Box<Task> _box;

  // === 缓存层 ===
  List<Task>? _cachedAllTasks;
  DateTime? _cacheTime;
  static const _cacheDuration = Duration(seconds: 5);

  @override
  Stream<List<Task>> watchAll() async* {
    // 首次发送缓存数据
    yield _getCachedTasks();

    // 监听变化
    yield* _box.watch().asyncMap((event) async {
      // 智能失效: 只在必要时重新排序
      if (_shouldInvalidateCache(event)) {
        _invalidateCache();
      }
      return _getCachedTasks();
    });
  }

  @override
  Stream<Task?> watchById(String id) async* {
    yield await findById(id);
    yield* _box.watch(key: id).map((event) {
      return event.deleted ? null : _box.get(id);
    });
  }

  @override
  Future<List<Task>> getAll() async {
    return _getCachedTasks();
  }

  @override
  Future<List<Task>> findDueBetween({DateTime? start, DateTime? end}) async {
    final all = await getAll();
    return all.where((task) {
      final due = task.dueAt;
      if (due == null) return false;
      if (start != null && due.isBefore(start)) return false;
      if (end != null && due.isAfter(end)) return false;
      return true;
    }).toList();
  }

  @override
  Future<Task?> findById(String id) async {
    return _box.get(id);
  }

  @override
  Future<Task?> getById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> save(Task task) async {
    await _box.put(task.id, task.copyWith(updatedAt: DateTime.now()));
    _invalidateCache();
  }

  @override
  Future<void> saveAll(Iterable<Task> tasks) async {
    final now = DateTime.now();
    await _box.putAll({
      for (final task in tasks) task.id: task.copyWith(updatedAt: now),
    });
    _invalidateCache();
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
    _invalidateCache();
  }

  @override
  Future<void> clear() async {
    await _box.clear();
    _invalidateCache();
  }

  // === 缓存管理 ===

  List<Task> _getCachedTasks() {
    final now = DateTime.now();

    // 检查缓存是否有效
    if (_cachedAllTasks != null &&
        _cacheTime != null &&
        now.difference(_cacheTime!) < _cacheDuration) {
      return _cachedAllTasks!;
    }

    // 重新生成缓存
    _cachedAllTasks = _box.values.toList()..sort(_sortBySchedule);
    _cacheTime = now;

    return _cachedAllTasks!;
  }

  void _invalidateCache() {
    _cachedAllTasks = null;
    _cacheTime = null;
  }

  bool _shouldInvalidateCache(BoxEvent event) {
    // 如果是删除操作,必须失效缓存
    if (event.deleted) return true;

    // 如果任务的排序相关字段变化,失效缓存
    final task = event.value as Task?;
    if (task == null) return false;

    // 只有影响排序的字段变化时才失效
    return task.dueAt != null || task.createdAt != null;
  }

  int _sortBySchedule(Task a, Task b) {
    final aDue = a.dueAt ?? a.createdAt;
    final bDue = b.dueAt ?? b.createdAt;
    final dueComparison = aDue.compareTo(bDue);
    if (dueComparison != 0) {
      return dueComparison;
    }
    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
  }
}
```

#### 修改文件: `lib/src/infrastructure/repositories/hive_task_repository.dart`

```dart
// 替换原有实现为 CachedTaskRepository
class HiveTaskRepository extends CachedTaskRepository {
  HiveTaskRepository(Box<Task> box) : super(box);

  static Future<HiveTaskRepository> create() async {
    final box = Hive.isBoxOpen(HiveBoxes.tasks)
        ? Hive.box<Task>(HiveBoxes.tasks)
        : await Hive.openBox<Task>(HiveBoxes.tasks);
    return HiveTaskRepository(box);
  }
}
```

**测试列表性能**:
```bash
flutter run --profile
# 使用 Flutter DevTools 查看渲染性能
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 第二周优化清单

### Day 7-9: Redis缓存集成

#### 步骤1: 安装Redis
```bash
# Windows (使用 Chocolatey)
choco install redis-64

# 或下载: https://github.com/microsoftarchive/redis/releases

# 启动Redis
redis-server
```

#### 步骤2: 安装Node.js Redis客户端
```bash
cd server
npm install redis
```

#### 步骤3: 创建Redis配置

创建文件: `server/config/redis.js`
```javascript
import { createClient } from 'redis';

const redisClient = createClient({
  url: process.env.REDIS_URL || 'redis://localhost:6379',
  password: process.env.REDIS_PASSWORD,
});

redisClient.on('error', (err) => {
  console.error('Redis连接错误:', err);
});

redisClient.on('connect', () => {
  console.log('✓ Redis连接成功');
});

// 连接Redis
await redisClient.connect();

// 缓存辅助函数
export async function getCached(key) {
  try {
    const value = await redisClient.get(key);
    return value ? JSON.parse(value) : null;
  } catch (error) {
    console.error('Redis GET错误:', error);
    return null;
  }
}

export async function setCached(key, value, ttlSeconds = 300) {
  try {
    await redisClient.setEx(key, ttlSeconds, JSON.stringify(value));
  } catch (error) {
    console.error('Redis SET错误:', error);
  }
}

export async function deleteCached(pattern) {
  try {
    const keys = await redisClient.keys(pattern);
    if (keys.length > 0) {
      await redisClient.del(keys);
    }
  } catch (error) {
    console.error('Redis DELETE错误:', error);
  }
}

export { redisClient };
```

#### 步骤4: 修改任务控制器

修改文件: `server/controllers/taskController.js`
```javascript
import { query } from '../config/database.js';
import { getCached, setCached, deleteCached } from '../config/redis.js';

export async function getTasks(req, res) {
  const userId = req.userId;
  const { page = 1, limit = 100, listId, status } = req.query;

  // 生成缓存键
  const cacheKey = `tasks:${userId}:${page}:${limit}:${listId || 'all'}:${status || 'all'}`;

  try {
    // 1. 尝试从缓存读取
    const cached = await getCached(cacheKey);
    if (cached) {
      return res.json({
        success: true,
        data: cached,
        cached: true,
      });
    }

    // 2. 从数据库查询
    const offset = (page - 1) * limit;
    let sql = 'SELECT * FROM user_tasks WHERE user_id = ? AND deleted_at IS NULL';
    const params = [userId];

    if (listId) {
      sql += ' AND list_id = ?';
      params.push(listId);
    }

    if (status) {
      sql += ' AND status = ?';
      params.push(status);
    }

    sql += ' ORDER BY sort_order ASC, created_at DESC LIMIT ? OFFSET ?';
    params.push(parseInt(limit), offset);

    const tasks = await query(sql, params);

    // 格式化响应
    const response = {
      tasks: tasks.map(formatTaskResponse),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
      },
    };

    // 3. 缓存结果 (5分钟)
    await setCached(cacheKey, response, 300);

    res.json({
      success: true,
      data: response,
      cached: false,
    });

  } catch (error) {
    console.error('获取任务列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取任务列表失败',
      error: error.message,
    });
  }
}

export async function createTask(req, res) {
  // ... 原有创建逻辑

  // 创建成功后失效缓存
  await deleteCached(`tasks:${userId}:*`);

  res.status(201).json({
    success: true,
    message: '任务创建成功',
    data: formatTaskResponse(tasks[0]),
  });
}

export async function updateTask(req, res) {
  // ... 原有更新逻辑

  // 更新成功后失效缓存
  await deleteCached(`tasks:${userId}:*`);

  res.json({
    success: true,
    message: '任务更新成功',
    data: formatTaskResponse(updatedTasks[0]),
  });
}

// 其他函数类似添加缓存逻辑...
```

#### 步骤5: 更新server.js

修改文件: `server/server.js`
```javascript
// 在文件开头添加
import './config/redis.js';  // 初始化Redis连接

// ... 其他代码保持不变
```

**测试Redis缓存**:
```bash
# 启动服务器
npm start

# 测试API (第一次 - 无缓存)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:3000/api/tasks

# 再次测试 (第二次 - 有缓存)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:3000/api/tasks

# 检查响应头中的 "cached": true
```

---

### Day 10-11: HTTP客户端优化

#### 创建文件: `lib/src/infrastructure/http/optimized_http_client.dart`

```dart
import 'dart:async';
import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/core/config/cloud_config.dart';
import 'package:todolist/src/core/logging/app_logger.dart';

class OptimizedHttpClient {
  OptimizedHttpClient({
    required AppLogger logger,
    required SharedPreferences prefs,
  })  : _logger = logger,
        _prefs = prefs {
    _dio = Dio(
      BaseOptions(
        baseUrl: CloudConfig.apiBaseUrl,

        // 优化超时设置
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 8),
        sendTimeout: const Duration(seconds: 8),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Encoding': 'gzip, deflate',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.addAll([
      _createAuthInterceptor(),
      _createDeduplicationInterceptor(),
      _createRetryInterceptor(),
      if (kDebugMode) _createLoggingInterceptor(),
    ]);
  }

  final AppLogger _logger;
  final SharedPreferences _prefs;
  late final Dio _dio;

  // 请求去重队列
  final _requestQueue = <String, Completer<Response>>{};

  Dio get dio => _dio;

  // 认证拦截器
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = _prefs.getString(CloudConfig.tokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _tryRefreshToken();
          if (refreshed) {
            final options = error.requestOptions;
            final token = _prefs.getString(CloudConfig.tokenKey);
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            try {
              final response = await _dio.fetch(options);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
        }
        return handler.next(error);
      },
    );
  }

  // 请求去重拦截器
  Interceptor _createDeduplicationInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final requestKey = '${options.method}:${options.uri}';

        if (_requestQueue.containsKey(requestKey)) {
          try {
            final response = await _requestQueue[requestKey]!.future;
            return handler.resolve(response);
          } catch (e) {
            return handler.reject(e as DioException);
          }
        }

        _requestQueue[requestKey] = Completer<Response>();
        return handler.next(options);
      },
      onResponse: (response, handler) {
        final requestKey = '${response.requestOptions.method}:${response.requestOptions.uri}';
        _requestQueue[requestKey]?.complete(response);
        _requestQueue.remove(requestKey);
        return handler.next(response);
      },
      onError: (error, handler) {
        final requestKey = '${error.requestOptions.method}:${error.requestOptions.uri}';
        _requestQueue[requestKey]?.completeError(error);
        _requestQueue.remove(requestKey);
        return handler.next(error);
      },
    );
  }

  // 自动重试拦截器
  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        final shouldRetry = error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.unknown;

        if (shouldRetry) {
          final retries = error.requestOptions.extra['retries'] ?? 0;

          if (retries < 2) {
            error.requestOptions.extra['retries'] = retries + 1;

            // 指数退避
            await Future.delayed(Duration(milliseconds: 100 * (1 << retries)));

            try {
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
        }

        return handler.next(error);
      },
    );
  }

  // 日志拦截器
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.info(
          'HTTP Request: ${options.method} ${options.uri}',
          {'headers': options.headers},
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.info(
          'HTTP Response: ${response.statusCode} ${response.requestOptions.uri}',
          {'cached': response.extra['cached'] ?? false},
        );
        return handler.next(response);
      },
      onError: (error, handler) {
        _logger.error(
          'HTTP Error: ${error.requestOptions.uri}',
          error,
          StackTrace.current,
        );
        return handler.next(error);
      },
    );
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = _prefs.getString(CloudConfig.refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _dio.post(
        CloudConfig.authRefreshToken,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final newToken = response.data['data']['token'] as String;
        final newRefreshToken = response.data['data']['refreshToken'] as String;

        await _prefs.setString(CloudConfig.tokenKey, newToken);
        await _prefs.setString(CloudConfig.refreshTokenKey, newRefreshToken);

        _logger.info('Token刷新成功');
        return true;
      }

      return false;
    } catch (e) {
      _logger.warning('Token刷新失败', e);
      return false;
    }
  }

  Future<void> clearAuth() async {
    await _prefs.remove(CloudConfig.tokenKey);
    await _prefs.remove(CloudConfig.refreshTokenKey);
    await _prefs.remove(CloudConfig.userIdKey);
  }
}
```

**测试HTTP优化**:
```bash
# 运行应用并观察网络请求
flutter run --observatory-port=8888
# 打开 DevTools 查看网络请求
```

---

## 性能验证工具

### 1. 前端性能测试

创建文件: `test/performance_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/task.dart';

void main() {
  group('性能测试', () {
    late Box<Task> testBox;

    setUp(() async {
      await Hive.initFlutter();
      testBox = await Hive.openBox<Task>('test_tasks');
    });

    tearDown(() async {
      await testBox.clear();
      await testBox.close();
    });

    test('批量写入1000个任务', () async {
      final stopwatch = Stopwatch()..start();

      final tasks = List.generate(
        1000,
        (i) => Task(
          id: 'task_$i',
          title: '测试任务 $i',
          listId: 'default',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      await testBox.putAll({for (var t in tasks) t.id: t});

      stopwatch.stop();
      print('批量写入1000个任务耗时: ${stopwatch.elapsedMilliseconds}ms');

      // 断言: 应在500ms内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });

    test('读取并排序1000个任务', () async {
      // 先插入数据
      final tasks = List.generate(
        1000,
        (i) => Task(
          id: 'task_$i',
          title: '测试任务 $i',
          listId: 'default',
          dueAt: DateTime.now().add(Duration(days: i % 30)),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      await testBox.putAll({for (var t in tasks) t.id: t});

      // 测试读取和排序
      final stopwatch = Stopwatch()..start();

      final allTasks = testBox.values.toList();
      allTasks.sort((a, b) {
        final aDue = a.dueAt ?? a.createdAt;
        final bDue = b.dueAt ?? b.createdAt;
        return aDue.compareTo(bDue);
      });

      stopwatch.stop();
      print('读取并排序1000个任务耗时: ${stopwatch.elapsedMilliseconds}ms');

      // 断言: 应在100ms内完成
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
```

运行性能测试:
```bash
flutter test test/performance_test.dart
```

---

### 2. 后端性能测试

创建文件: `server/test/load-test.js`
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 20 },
    { duration: '1m', target: 50 },
    { duration: '30s', target: 0 },
  ],
  thresholds: {
    'http_req_duration': ['p(95)<500'],
  },
};

const BASE_URL = 'http://localhost:3000';

export function setup() {
  const loginRes = http.post(`${BASE_URL}/api/auth/login`, JSON.stringify({
    username: 'testuser',
    password: 'password123',
  }), {
    headers: { 'Content-Type': 'application/json' },
  });

  return { token: loginRes.json('data.token') };
}

export default function(data) {
  const headers = {
    'Authorization': `Bearer ${data.token}`,
    'Content-Type': 'application/json',
  };

  // 测试获取任务
  const res = http.get(`${BASE_URL}/api/tasks`, { headers });

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
    'has cached header': (r) => r.json('cached') !== undefined,
  });

  sleep(1);
}
```

安装k6并运行:
```bash
# Windows
choco install k6

# 运行负载测试
k6 run server/test/load-test.js
```

---

## 监控和调试

### 启用MySQL慢查询日志

编辑 `my.cnf` 或 `my.ini`:
```ini
[mysqld]
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow-query.log
long_query_time = 1
log_queries_not_using_indexes = 1
```

重启MySQL:
```bash
# Windows
net stop MySQL
net start MySQL

# Linux
sudo systemctl restart mysql
```

查看慢查询:
```bash
tail -f /var/log/mysql/slow-query.log
```

---

### Flutter性能分析

```bash
# 使用 profile 模式运行
flutter run --profile

# 启动 DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

在DevTools中查看:
- Performance: 帧率和渲染性能
- Memory: 内存使用情况
- Network: 网络请求分析

---

## 下一步

完成以上优化后:

1. **测量基准**: 使用性能测试工具测量优化前后的数据
2. **监控**: 设置持续监控,确保性能不退化
3. **迭代**: 根据监控数据进一步优化

**文档版本**: 1.0
**更新日期**: 2025-10-17
