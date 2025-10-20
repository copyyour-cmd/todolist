# TodoList 项目数据库架构分析报告

## 执行摘要

本报告对TodoList项目的数据库设计和数据层架构进行了全面评估。该项目采用混合数据库架构：
- **客户端**：Hive (NoSQL键值存储) - Flutter应用本地存储
- **服务端**：MySQL (关系型数据库) - 云同步和多设备支持

**总体评分：7.2/10**

### 优势
- 客户端使用Hive实现快速离线访问
- 服务端采用MySQL确保数据一致性和关系完整性
- 实现了基本的版本冲突检测机制
- 良好的实体设计（使用Freezed确保不可变性）

### 主要问题
- 数据库模式不一致（客户端vs服务端字段映射混乱）
- 缺少复合索引和查询优化
- 没有数据库迁移版本控制系统
- 同步机制过于简单，缺少增量同步和冲突解决策略
- 缺少数据完整性约束和级联删除规则
- JSON字段存储导致查询性能问题

---

## 1. 技术选型评估

### 1.1 客户端数据库：Hive

**选型合理性：8/10**

#### 优势
- 纯Dart实现，跨平台兼容性好
- 高性能键值存储，适合移动端
- 类型安全的适配器系统
- 无需原生依赖，打包体积小

#### 劣势
- 不支持复杂查询（无SQL）
- 缺少关系数据库的ACID特性
- 难以实现复杂的数据关系查询
- 全表扫描性能在大数据量时下降

#### 建议
```dart
// 当前问题：在内存中过滤，性能差
final tasks = _box.values.where((task) {
  final due = task.dueAt;
  if (due == null) return false;
  if (start != null && due.isBefore(start)) return false;
  if (end != null && due.isAfter(end)) return false;
  return true;
}).toList();

// 建议：使用LazyBox + 索引优化
// 或考虑迁移到 Isar (更强大的NoSQL替代方案)
```

**替代方案建议**：
- **Isar**：Dart原生数据库，支持复杂查询、全文搜索、多索引
- **Drift (Moor)**：SQLite包装器，支持类型安全查询和迁移
- **ObjectBox**：高性能对象数据库，支持关系和查询

### 1.2 服务端数据库：MySQL

**选型合理性：7/10**

#### 优势
- 成熟稳定的关系型数据库
- 良好的ACID支持
- 丰富的生态系统和工具
- utf8mb4字符集支持多语言

#### 劣势
- 过度使用JSON字段（失去关系型优势）
- 连接池配置过小（connectionLimit: 10）
- 缺少读写分离和主从复制配置
- 没有使用外键级联删除

#### 建议
```javascript
// 当前配置
const pool = mysql.createPool({
  connectionLimit: 10, // 太小！
  waitForConnections: true,
  queueLimit: 0
});

// 建议配置
const pool = mysql.createPool({
  connectionLimit: 50, // 根据并发量调整
  waitForConnections: true,
  queueLimit: 100, // 防止无限队列
  connectTimeout: 10000,
  acquireTimeout: 10000,
  timeout: 60000,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0
});
```

---

## 2. 数据模型设计分析

### 2.1 客户端实体设计（Hive + Freezed）

**评分：8.5/10**

#### 优势
```dart
@HiveType(typeId: 0, adapterName: 'TaskAdapter')
@freezed
class Task with _$Task {
  const factory Task({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(3) required String listId,
    // ... 其他字段
  }) = _Task;
}
```

- 使用Freezed确保不可变性和类型安全
- 合理的字段设计，包含时间戳和版本号
- 支持JSON序列化/反序列化
- 枚举类型使用HiveType注解

#### 问题
1. **HiveField编号不连续**：`@HiveField(0)`, `@HiveField(1)`, 然后跳到`@HiveField(3)`
   - 风险：未来添加字段时容易冲突

2. **嵌套对象存储**：SubTask、Attachment等嵌套在Task内
   ```dart
   @HiveField(9) @Default(<SubTask>[]) List<SubTask> subtasks,
   @HiveField(10) @Default(<Attachment>[]) List<Attachment> attachments,
   ```
   - 问题：无法独立查询或更新子任务
   - 建议：使用关系引用而非嵌套

3. **缺少软删除标记**：没有`deletedAt`字段
   - 影响：无法实现垃圾桶功能
   - 云同步时无法区分删除操作

### 2.2 服务端数据库Schema

**评分：6/10**

#### 核心表结构问题

##### 1. user_tasks表（严重问题）

```sql
CREATE TABLE IF NOT EXISTS user_tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    client_id VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    notes TEXT,
    list_id VARCHAR(100), -- 问题：类型不一致！
    priority VARCHAR(20) DEFAULT 'none',
    status VARCHAR(20) DEFAULT 'pending',
    due_at DATETIME,
    remind_at DATETIME,
    completed_at DATETIME,
    deleted_at DATETIME,
    version INT DEFAULT 1,
    -- ... 其他字段
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_client_id (user_id, client_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_due_at (due_at),
    INDEX idx_deleted_at (deleted_at)
);
```

**问题清单**：

1. **过度使用JSON字段**
```sql
tags JSON,
repeat_rule JSON,
sub_tasks JSON,
attachments JSON,
smart_reminders JSON,
focus_sessions JSON,
location_reminder JSON
```
   - 问题：无法有效查询JSON内部数据
   - 无法建立外键关系
   - 难以维护数据一致性
   - 查询性能差

2. **缺少外键约束**
```sql
list_id VARCHAR(100), -- 应该引用 user_lists.id
template_id VARCHAR(100), -- 应该引用模板表
```

3. **字段类型不一致**
```sql
-- 客户端
String listId; // UUID格式

-- 服务端
list_id VARCHAR(100) -- 应该INT或保持VARCHAR但加外键
```

4. **索引不足**
```sql
-- 缺少复合索引
INDEX idx_user_status (user_id, status),
INDEX idx_user_list (user_id, list_id),
INDEX idx_user_due (user_id, due_at),
INDEX idx_user_deleted (user_id, deleted_at)
```

##### 2. user_lists表

```sql
CREATE TABLE IF NOT EXISTS user_lists (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    client_id VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    color_hex VARCHAR(10),
    sort_order INT DEFAULT 0,
    is_default TINYINT DEFAULT 0,
    deleted_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_client_id (user_id, client_id),
    INDEX idx_user_id (user_id)
);
```

**问题**：
- 缺少`UNIQUE KEY (user_id, name)`防止重复列表名
- 没有`CHECK`约束验证颜色格式
- `is_default`没有唯一性约束（每个用户应只有一个默认列表）

##### 3. user_sessions表

```sql
CREATE TABLE IF NOT EXISTS user_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    token VARCHAR(500) NOT NULL UNIQUE,
    refresh_token VARCHAR(500),
    device_id VARCHAR(100),
    expires_at DATETIME NOT NULL,
    -- ...
    INDEX idx_token (token(255)), -- 问题：只索引前255字符
    INDEX idx_expires_at (expires_at)
);
```

**问题**：
- Token存储在数据库（应该用Redis）
- 缺少自动清理过期会话的机制
- 没有设备数量限制

---

## 3. 索引策略分析

### 3.1 当前索引

**评分：5/10**

#### 现有索引
```sql
-- user_tasks表
INDEX idx_user_id (user_id),
INDEX idx_status (status),
INDEX idx_due_at (due_at),
INDEX idx_deleted_at (deleted_at),
INDEX idx_is_pinned (is_pinned),
INDEX idx_sort_order (sort_order)
```

#### 问题
1. **缺少复合索引**：大多数查询需要多列过滤
2. **单列索引效率低**：WHERE条件包含多个字段
3. **没有覆盖索引**：无法实现索引覆盖查询

### 3.2 建议的索引策略

```sql
-- 1. 主要查询索引（根据查询模式优化）
CREATE INDEX idx_user_status_due ON user_tasks(user_id, status, due_at);
CREATE INDEX idx_user_list_status ON user_tasks(user_id, list_id, status);
CREATE INDEX idx_user_deleted_updated ON user_tasks(user_id, deleted_at, updated_at);

-- 2. 覆盖索引（包含常用查询字段）
CREATE INDEX idx_task_list_cover ON user_tasks(
    user_id, list_id, status,
    title, priority, due_at, updated_at
);

-- 3. 全文搜索索引
CREATE FULLTEXT INDEX idx_task_search ON user_tasks(title, notes);

-- 4. 排序优化索引
CREATE INDEX idx_user_pinned_sort ON user_tasks(
    user_id, is_pinned DESC, sort_order ASC, created_at DESC
);

-- 5. 同步查询索引
CREATE INDEX idx_sync_query ON user_tasks(
    user_id, updated_at, deleted_at
);
```

### 3.3 索引使用分析

```sql
-- 当前查询（未优化）
SELECT * FROM user_tasks
WHERE user_id = ?
  AND deleted_at IS NULL
ORDER BY sort_order ASC, created_at DESC
LIMIT ? OFFSET ?;

-- 问题：使用 SELECT * 返回所有字段（包括大JSON字段）
-- EXPLAIN 结果：Using filesort（需要额外排序）

-- 优化后查询
SELECT id, client_id, title, status, priority, due_at,
       list_id, is_pinned, sort_order, updated_at
FROM user_tasks
USE INDEX (idx_user_deleted_sort)
WHERE user_id = ? AND deleted_at IS NULL
ORDER BY is_pinned DESC, sort_order ASC, created_at DESC
LIMIT ? OFFSET ?;

-- 使用覆盖索引，避免回表查询
```

---

## 4. 数据完整性约束

### 4.1 当前约束

**评分：4/10**

```sql
-- 仅有的约束
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
UNIQUE KEY uk_user_client_id (user_id, client_id)
```

### 4.2 缺失的约束

```sql
-- 1. CHECK约束（MySQL 8.0+支持）
ALTER TABLE user_tasks
ADD CONSTRAINT chk_priority
CHECK (priority IN ('none', 'low', 'medium', 'high', 'critical'));

ALTER TABLE user_tasks
ADD CONSTRAINT chk_status
CHECK (status IN ('pending', 'inProgress', 'completed', 'cancelled', 'archived'));

ALTER TABLE user_tasks
ADD CONSTRAINT chk_dates
CHECK (completed_at IS NULL OR completed_at >= created_at);

-- 2. 外键约束
ALTER TABLE user_tasks
ADD CONSTRAINT fk_list_id
FOREIGN KEY (list_id) REFERENCES user_lists(client_id)
ON DELETE SET NULL ON UPDATE CASCADE;

-- 3. 唯一性约束
ALTER TABLE user_lists
ADD CONSTRAINT uk_user_name UNIQUE (user_id, name);

ALTER TABLE user_lists
ADD CONSTRAINT uk_user_default
UNIQUE (user_id, is_default)
WHERE is_default = 1; -- MySQL不支持部分唯一索引

-- 4. NOT NULL约束
ALTER TABLE user_tasks MODIFY title VARCHAR(255) NOT NULL;
ALTER TABLE user_tasks MODIFY status VARCHAR(20) NOT NULL DEFAULT 'pending';
```

### 4.3 数据验证问题

```javascript
// 服务端验证不足
export async function createTask(req, res) {
  const taskData = req.body;

  // 缺少验证：
  // 1. title长度检查
  // 2. priority/status枚举验证
  // 3. due_at日期合法性
  // 4. list_id存在性验证

  await query(
    `INSERT INTO user_tasks (user_id, client_id, title, ...)
     VALUES (?, ?, ?, ...)`,
    [userId, taskData.client_id, taskData.title, ...]
  );
}

// 建议：使用express-validator
import { body, validationResult } from 'express-validator';

const taskValidation = [
  body('title').trim().notEmpty().isLength({ max: 255 }),
  body('priority').isIn(['none', 'low', 'medium', 'high', 'critical']),
  body('status').isIn(['pending', 'inProgress', 'completed', 'cancelled']),
  body('due_at').optional().isISO8601(),
  body('list_id').custom(async (value, { req }) => {
    const list = await query(
      'SELECT 1 FROM user_lists WHERE client_id = ? AND user_id = ?',
      [value, req.userId]
    );
    if (list.length === 0) throw new Error('List not found');
  })
];
```

---

## 5. 查询优化分析

### 5.1 N+1查询问题

```javascript
// 当前代码：N+1问题
export async function getTasks(req, res) {
  const tasks = await query(
    'SELECT * FROM user_tasks WHERE user_id = ?',
    [userId]
  );

  // 问题：每个任务单独查询关联数据
  for (const task of tasks) {
    if (task.list_id) {
      task.list = await query(
        'SELECT * FROM user_lists WHERE client_id = ?',
        [task.list_id]
      );
    }
  }

  return tasks;
}

// 优化：使用JOIN一次查询
export async function getTasks(req, res) {
  const tasks = await query(`
    SELECT
      t.*,
      l.name as list_name,
      l.color_hex as list_color
    FROM user_tasks t
    LEFT JOIN user_lists l ON t.list_id = l.client_id AND t.user_id = l.user_id
    WHERE t.user_id = ? AND t.deleted_at IS NULL
    ORDER BY t.is_pinned DESC, t.sort_order ASC
    LIMIT ? OFFSET ?
  `, [userId, limit, offset]);

  return tasks;
}
```

### 5.2 批量操作优化

```javascript
// 当前：循环插入
for (const task of tasks) {
  await query(
    'INSERT INTO user_tasks (...) VALUES (...)',
    [...]
  );
}

// 优化：批量插入
const values = tasks.map(task => [
  userId, task.id, task.title, task.notes,
  task.listId, task.priority, task.status
]);

await query(
  `INSERT INTO user_tasks
   (user_id, client_id, title, notes, list_id, priority, status)
   VALUES ?
   ON DUPLICATE KEY UPDATE
   title = VALUES(title),
   notes = VALUES(notes),
   updated_at = CURRENT_TIMESTAMP`,
  [values]
);
```

### 5.3 JSON字段查询问题

```javascript
// 当前：无法有效查询JSON字段
SELECT * FROM user_tasks
WHERE JSON_CONTAINS(tags, '"work"'); -- 慢！

// 建议：规范化设计
CREATE TABLE task_tags (
  id INT PRIMARY KEY AUTO_INCREMENT,
  task_id INT NOT NULL,
  tag_id INT NOT NULL,
  FOREIGN KEY (task_id) REFERENCES user_tasks(id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES user_tags(id) ON DELETE CASCADE,
  UNIQUE KEY (task_id, tag_id),
  INDEX idx_tag_id (tag_id)
);

-- 高效查询
SELECT t.*
FROM user_tasks t
JOIN task_tags tt ON t.id = tt.task_id
JOIN user_tags tag ON tt.tag_id = tag.id
WHERE tag.name = 'work' AND t.user_id = ?;
```

---

## 6. 同步机制分析

### 6.1 当前同步策略

**评分：5/10**

```javascript
// 全量上传
export async function uploadAll(req, res) {
  const { tasks, lists, tags, ideas, settings } = req.body;

  // 问题1：没有事务保护
  // 问题2：循环插入效率低
  // 问题3：没有冲突解决机制

  for (const task of tasks) {
    await query(
      `INSERT INTO user_tasks (...) VALUES (...)
       ON DUPLICATE KEY UPDATE ...`
    );
  }
}

// 全量下载
export async function downloadAll(req, res) {
  // 问题：返回所有数据，没有分页
  // 问题：没有增量同步支持
  const tasks = await query(
    'SELECT * FROM user_tasks WHERE user_id = ?'
  );
  res.json({ tasks });
}
```

### 6.2 问题分析

1. **缺少增量同步**
   - 每次全量同步浪费带宽
   - 客户端需要对比所有数据

2. **版本冲突处理简单**
```javascript
// 当前：简单版本号比较
if (taskData.version && taskData.version < existingTask.version) {
  return res.status(409).json({ error: 'VERSION_CONFLICT' });
}

// 问题：
// - 没有三路合并（three-way merge）
// - 无法处理字段级冲突
// - 用户只能选择覆盖或放弃
```

3. **缺少冲突解决策略**
   - Last-Write-Wins (LWW)：最后写入获胜
   - Manual Resolution：手动解决
   - Automatic Merge：自动合并

### 6.3 建议的同步架构

```javascript
// 1. 增量同步
export async function syncIncremental(req, res) {
  const { lastSyncTimestamp, changes } = req.body;

  // 上传客户端变更
  const conflicts = [];
  for (const change of changes) {
    const existing = await query(
      'SELECT * FROM user_tasks WHERE client_id = ? AND user_id = ?',
      [change.id, userId]
    );

    if (existing.length > 0) {
      const serverTask = existing[0];

      // 检测冲突
      if (serverTask.updated_at > lastSyncTimestamp) {
        conflicts.push({
          clientVersion: change,
          serverVersion: serverTask,
          conflictFields: detectConflicts(change, serverTask)
        });
        continue;
      }
    }

    // 应用变更
    await applyChange(change);
  }

  // 下载服务端变更
  const serverChanges = await query(
    'SELECT * FROM user_tasks WHERE user_id = ? AND updated_at > ?',
    [userId, lastSyncTimestamp]
  );

  res.json({
    serverChanges,
    conflicts,
    newSyncTimestamp: new Date()
  });
}

// 2. 操作日志表（实现操作级同步）
CREATE TABLE sync_operations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  entity_type VARCHAR(50) NOT NULL, -- 'task', 'list', 'tag'
  entity_id VARCHAR(100) NOT NULL,
  operation VARCHAR(20) NOT NULL, -- 'create', 'update', 'delete'
  changes JSON, -- 具体变更的字段
  device_id VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_created (user_id, created_at),
  INDEX idx_entity (entity_type, entity_id)
);

// 3. 基于CRDTs的冲突自动解决
// Conflict-free Replicated Data Types
```

---

## 7. 数据访问层设计

### 7.1 客户端Repository模式

**评分：8/10**

```dart
// 好的设计：清晰的接口
abstract class TaskRepository {
  Future<List<Task>> getAll();
  Future<Task?> findById(String id);
  Future<void> save(Task task);
  Future<void> delete(String id);
  Stream<List<Task>> watchAll();
}

// 实现类：Hive
class HiveTaskRepository implements TaskRepository {
  final Box<Task> _box;

  @override
  Stream<List<Task>> watchAll() async* {
    yield _sortedTasks();
    yield* _box.watch().map((_) => _sortedTasks());
  }

  // 问题：所有查询都在内存中过滤
  List<Task> _sortedTasks() =>
    _box.values.toList()..sort(_sortBySchedule);
}
```

#### 问题
1. **性能问题**：所有过滤在内存中执行
2. **缺少分页**：大数据量时内存占用高
3. **缺少缓存策略**：每次都重新排序

#### 建议
```dart
// 使用LazyBox优化
class OptimizedHiveTaskRepository implements TaskRepository {
  final LazyBox<Task> _box;
  final Map<String, Task> _cache = {};

  @override
  Future<List<Task>> getAll({
    int? limit,
    int? offset,
    TaskFilter? filter,
  }) async {
    // 实现分页和过滤
    final keys = _box.keys.skip(offset ?? 0).take(limit ?? 100);
    final tasks = await Future.wait(
      keys.map((key) => _getFromCacheOrBox(key))
    );

    return tasks.where((t) => filter?.matches(t) ?? true).toList();
  }

  Future<Task> _getFromCacheOrBox(String key) async {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }
    final task = await _box.get(key);
    if (task != null) _cache[key] = task;
    return task!;
  }
}
```

### 7.2 服务端数据访问层

**评分：6/10**

```javascript
// 当前：直接在Controller中写SQL
export async function getTasks(req, res) {
  const tasks = await query(
    'SELECT * FROM user_tasks WHERE user_id = ?',
    [userId]
  );
  res.json({ tasks });
}

// 问题：
// 1. 业务逻辑和数据访问混合
// 2. 难以测试
// 3. SQL字符串散落各处
// 4. 缺少数据访问抽象层
```

#### 建议：引入Repository层

```javascript
// models/TaskRepository.js
class TaskRepository {
  async findByUserId(userId, options = {}) {
    const {
      page = 1,
      limit = 100,
      listId,
      status,
      includeDeleted = false,
      updatedAfter
    } = options;

    let sql = this._buildBaseQuery();
    const params = [userId];

    sql = this._applyFilters(sql, params, {
      listId, status, includeDeleted, updatedAfter
    });

    sql = this._applyPagination(sql, params, { page, limit });

    return await query(sql, params);
  }

  async create(userId, taskData) {
    return await query(
      this._buildInsertQuery(),
      this._buildInsertParams(userId, taskData)
    );
  }

  async update(userId, taskId, updates) {
    // 乐观锁实现
    const result = await query(
      `UPDATE user_tasks
       SET ${this._buildUpdateFields(updates)},
           version = version + 1,
           updated_at = CURRENT_TIMESTAMP
       WHERE client_id = ?
         AND user_id = ?
         AND version = ?`,
      [...this._buildUpdateParams(updates), taskId, userId, updates.version]
    );

    if (result.affectedRows === 0) {
      throw new OptimisticLockError('Task was modified by another process');
    }

    return result;
  }

  _buildBaseQuery() {
    return `
      SELECT t.*,
             l.name as list_name,
             l.color_hex as list_color
      FROM user_tasks t
      LEFT JOIN user_lists l ON t.list_id = l.client_id
      WHERE t.user_id = ?
    `;
  }
}

// controllers/taskController.js
import TaskRepository from '../models/TaskRepository.js';

const taskRepo = new TaskRepository();

export async function getTasks(req, res) {
  try {
    const tasks = await taskRepo.findByUserId(req.userId, req.query);
    res.json({ success: true, data: tasks });
  } catch (error) {
    handleError(res, error);
  }
}
```

---

## 8. 可扩展性和性能考虑

### 8.1 当前架构的扩展性

**评分：5/10**

#### 限制因素

1. **单体MySQL架构**
   - 无读写分离
   - 无主从复制
   - 无分库分表

2. **连接池配置**
```javascript
connectionLimit: 10 // 太小，支持不了高并发
```

3. **缺少缓存层**
   - 频繁查询数据库
   - 没有Redis缓存
   - 没有查询结果缓存

4. **文件上传限制**
```javascript
limit: '50mb' // 单次上传限制
UPLOAD_DIR: './uploads' // 本地存储，难以扩展
```

### 8.2 性能优化建议

#### 1. 引入多层缓存架构

```javascript
// cache/CacheManager.js
import Redis from 'ioredis';

class CacheManager {
  constructor() {
    this.redis = new Redis({
      host: process.env.REDIS_HOST,
      port: process.env.REDIS_PORT,
      password: process.env.REDIS_PASSWORD,
      db: 0,
      retryStrategy: (times) => Math.min(times * 50, 2000)
    });
  }

  // L1: 应用内存缓存
  // L2: Redis缓存
  // L3: 数据库

  async get(key, fetchFn) {
    // 尝试从Redis获取
    const cached = await this.redis.get(key);
    if (cached) {
      return JSON.parse(cached);
    }

    // 从数据库获取并缓存
    const data = await fetchFn();
    await this.redis.setex(key, 3600, JSON.stringify(data));
    return data;
  }

  async invalidate(pattern) {
    const keys = await this.redis.keys(pattern);
    if (keys.length > 0) {
      await this.redis.del(...keys);
    }
  }
}

// 使用示例
const cache = new CacheManager();

export async function getTasks(req, res) {
  const cacheKey = `tasks:${req.userId}:${JSON.stringify(req.query)}`;

  const tasks = await cache.get(cacheKey, async () => {
    return await taskRepo.findByUserId(req.userId, req.query);
  });

  res.json({ success: true, data: tasks });
}

// 更新时失效缓存
export async function updateTask(req, res) {
  await taskRepo.update(req.userId, req.params.taskId, req.body);

  // 失效相关缓存
  await cache.invalidate(`tasks:${req.userId}:*`);

  res.json({ success: true });
}
```

#### 2. 数据库读写分离

```javascript
// config/database.js
import mysql from 'mysql2/promise';

// 主库（写）
const masterPool = mysql.createPool({
  host: process.env.DB_MASTER_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  connectionLimit: 20
});

// 从库（读）
const slavePool = mysql.createPool({
  host: process.env.DB_SLAVE_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  connectionLimit: 50
});

export async function query(sql, params, useSlavefor = 'read') {
  const pool = useSlave ? slavePool : masterPool;
  const [results] = await pool.execute(sql, params);
  return results;
}
```

#### 3. 分库分表策略

```javascript
// 按用户ID分片
function getShardKey(userId) {
  return userId % 10; // 10个分片
}

function getShardedTableName(tableName, userId) {
  const shard = getShardKey(userId);
  return `${tableName}_${shard}`;
}

// 使用示例
const tableName = getShardedTableName('user_tasks', userId);
const tasks = await query(
  `SELECT * FROM ${tableName} WHERE user_id = ?`,
  [userId]
);
```

#### 4. CDN + 对象存储

```javascript
// 将文件上传到云存储
import AWS from 'aws-sdk';

const s3 = new AWS.S3({
  accessKeyId: process.env.AWS_ACCESS_KEY,
  secretAccessKey: process.env.AWS_SECRET_KEY,
  region: process.env.AWS_REGION
});

export async function uploadAttachment(file) {
  const key = `attachments/${Date.now()}_${file.originalname}`;

  await s3.putObject({
    Bucket: process.env.S3_BUCKET,
    Key: key,
    Body: file.buffer,
    ContentType: file.mimetype,
    ACL: 'public-read'
  }).promise();

  return {
    url: `https://cdn.example.com/${key}`,
    key
  };
}
```

### 8.3 监控和性能指标

```javascript
// middleware/performanceMonitor.js
import { performance } from 'perf_hooks';

export function performanceMonitor(req, res, next) {
  const start = performance.now();

  res.on('finish', () => {
    const duration = performance.now() - start;

    // 记录慢查询
    if (duration > 1000) {
      console.warn(`Slow request: ${req.method} ${req.path} - ${duration}ms`);
    }

    // 发送到监控系统（如Prometheus）
    metrics.httpRequestDuration.observe({
      method: req.method,
      route: req.route?.path,
      status: res.statusCode
    }, duration / 1000);
  });

  next();
}
```

---

## 9. 数据迁移策略

### 9.1 当前问题

**评分：3/10**

- 没有版本控制的迁移系统
- 手动执行SQL脚本
- 无回滚机制
- 无迁移历史记录

### 9.2 建议：引入迁移框架

#### 使用Knex.js进行迁移管理

```bash
npm install knex --save
npx knex init
```

```javascript
// knexfile.js
module.exports = {
  development: {
    client: 'mysql2',
    connection: {
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME
    },
    migrations: {
      directory: './migrations',
      tableName: 'knex_migrations'
    }
  }
};

// migrations/20241017_create_tasks_table.js
exports.up = function(knex) {
  return knex.schema.createTable('user_tasks', (table) => {
    table.increments('id').primary();
    table.integer('user_id').notNullable().references('id').inTable('users').onDelete('CASCADE');
    table.string('client_id', 100).notNullable();
    table.string('title', 255).notNullable();
    table.text('notes');
    table.integer('list_id').references('id').inTable('user_lists').onDelete('SET NULL');
    table.enum('priority', ['none', 'low', 'medium', 'high', 'critical']).defaultTo('none');
    table.enum('status', ['pending', 'inProgress', 'completed', 'cancelled', 'archived']).defaultTo('pending');
    table.datetime('due_at');
    table.datetime('remind_at');
    table.datetime('completed_at');
    table.datetime('deleted_at');
    table.integer('version').defaultTo(1);
    table.timestamps(true, true);

    table.unique(['user_id', 'client_id']);
    table.index(['user_id', 'status']);
    table.index(['user_id', 'deleted_at', 'updated_at']);
  });
};

exports.down = function(knex) {
  return knex.schema.dropTable('user_tasks');
};

// 执行迁移
// npx knex migrate:latest
// npx knex migrate:rollback
```

### 9.3 客户端数据迁移

```dart
// lib/src/infrastructure/hive/migrations.dart
class HiveMigrationManager {
  static const int currentVersion = 2;

  static Future<void> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    final currentDbVersion = prefs.getInt('db_version') ?? 0;

    if (currentDbVersion < currentVersion) {
      for (int version = currentDbVersion + 1;
           version <= currentVersion;
           version++) {
        await _runMigration(version);
      }
      await prefs.setInt('db_version', currentVersion);
    }
  }

  static Future<void> _runMigration(int version) async {
    switch (version) {
      case 1:
        await _migrateToV1();
        break;
      case 2:
        await _migrateToV2();
        break;
    }
  }

  // 迁移：添加deletedAt字段
  static Future<void> _migrateToV1() async {
    final taskBox = await Hive.openBox<Task>('tasks');
    final tasks = taskBox.values.toList();

    // 为所有任务添加新字段（使用copyWith）
    for (final task in tasks) {
      await taskBox.put(
        task.id,
        task.copyWith(deletedAt: null)
      );
    }
  }

  // 迁移：分离子任务表
  static Future<void> _migrateToV2() async {
    // 将嵌套的子任务提取到独立表
    final taskBox = await Hive.openBox<Task>('tasks');
    final subtaskBox = await Hive.openBox<SubTask>('subtasks');

    for (final task in taskBox.values) {
      if (task.subtasks.isNotEmpty) {
        for (final subtask in task.subtasks) {
          await subtaskBox.put(subtask.id, subtask);
        }

        // 更新任务，只保留子任务ID引用
        await taskBox.put(
          task.id,
          task.copyWith(
            subtaskIds: task.subtasks.map((s) => s.id).toList(),
            subtasks: [] // 清空嵌套数据
          )
        );
      }
    }
  }
}
```

---

## 10. 安全性问题

### 10.1 SQL注入防护

**评分：8/10**

当前使用参数化查询，良好：

```javascript
// 安全：参数化查询
await query(
  'SELECT * FROM user_tasks WHERE user_id = ?',
  [userId]
);

// 危险：字符串拼接（未发现）
// const sql = `SELECT * FROM user_tasks WHERE user_id = ${userId}`;
```

### 10.2 身份认证问题

```javascript
// middleware/auth.js
export async function authenticate(req, res, next) {
  const token = req.headers.authorization?.replace('Bearer ', '');

  // 问题1：Token存储在数据库而非Redis
  // 问题2：每次请求都查询数据库
  const sessions = await query(
    'SELECT * FROM user_sessions WHERE token = ? AND expires_at > NOW()',
    [token]
  );

  if (sessions.length === 0) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  req.userId = sessions[0].user_id;
  next();
}

// 建议：使用Redis缓存Token
export async function authenticate(req, res, next) {
  const token = req.headers.authorization?.replace('Bearer ', '');

  // 从Redis获取用户ID
  const userId = await redis.get(`session:${token}`);

  if (!userId) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  req.userId = parseInt(userId);
  next();
}
```

### 10.3 数据加密

```sql
-- 敏感数据加密
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  password_hash VARCHAR(255) NOT NULL, -- bcrypt加密
  phone_encrypted VARBINARY(255), -- AES加密
  encryption_key_id INT, -- 密钥轮换
  -- ...
);

-- 使用MySQL内置加密函数
INSERT INTO users (email, phone_encrypted)
VALUES (?, AES_ENCRYPT(?, @encryption_key));

SELECT email, AES_DECRYPT(phone_encrypted, @encryption_key) as phone
FROM users WHERE id = ?;
```

---

## 11. 推荐的规范化数据库Schema

### 11.1 完整的规范化设计

```sql
-- ==========================================
-- 用户相关表
-- ==========================================

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE, -- 客户端UUID
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  nickname VARCHAR(50),
  avatar_url VARCHAR(500),
  phone VARCHAR(20),
  status ENUM('active', 'disabled', 'suspended') DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_login_at DATETIME,
  deleted_at DATETIME,
  INDEX idx_username (username),
  INDEX idx_email (email),
  INDEX idx_status (status),
  INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 列表表
-- ==========================================

CREATE TABLE lists (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  user_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  color VARCHAR(7) NOT NULL, -- #RRGGBB
  icon VARCHAR(50),
  sort_order INT NOT NULL DEFAULT 0,
  is_default BOOLEAN NOT NULL DEFAULT FALSE,
  is_archived BOOLEAN NOT NULL DEFAULT FALSE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  version INT NOT NULL DEFAULT 1,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY uk_user_uuid (user_id, uuid),
  UNIQUE KEY uk_user_name (user_id, name) WHERE deleted_at IS NULL,
  INDEX idx_user_id (user_id),
  INDEX idx_sort_order (sort_order),
  CHECK (color REGEXP '^#[0-9A-Fa-f]{6}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 确保每个用户只有一个默认列表
CREATE UNIQUE INDEX uk_user_default
ON lists (user_id, is_default)
WHERE is_default = TRUE AND deleted_at IS NULL;

-- ==========================================
-- 标签表
-- ==========================================

CREATE TABLE tags (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  user_id INT NOT NULL,
  name VARCHAR(50) NOT NULL,
  color VARCHAR(7) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY uk_user_uuid (user_id, uuid),
  UNIQUE KEY uk_user_name (user_id, name) WHERE deleted_at IS NULL,
  INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 任务表（核心表）
-- ==========================================

CREATE TABLE tasks (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  user_id INT NOT NULL,
  list_id INT NOT NULL,
  title VARCHAR(500) NOT NULL,
  notes TEXT,
  priority ENUM('none', 'low', 'medium', 'high', 'critical') NOT NULL DEFAULT 'none',
  status ENUM('pending', 'in_progress', 'completed', 'cancelled', 'archived') NOT NULL DEFAULT 'pending',
  due_at DATETIME,
  remind_at DATETIME,
  completed_at DATETIME,
  estimated_minutes INT,
  actual_minutes INT DEFAULT 0,
  sort_order INT NOT NULL DEFAULT 0,
  is_pinned BOOLEAN NOT NULL DEFAULT FALSE,
  is_starred BOOLEAN NOT NULL DEFAULT FALSE,
  color VARCHAR(7),
  parent_task_id INT, -- 子任务关系
  template_id INT, -- 来源模板
  recurrence_rule_id INT, -- 重复规则
  parent_recurring_task_id INT, -- 重复任务的父任务
  recurrence_count INT DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  version INT NOT NULL DEFAULT 1,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (list_id) REFERENCES lists(id) ON DELETE RESTRICT,
  FOREIGN KEY (parent_task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  FOREIGN KEY (recurrence_rule_id) REFERENCES recurrence_rules(id) ON DELETE SET NULL,
  UNIQUE KEY uk_user_uuid (user_id, uuid),
  INDEX idx_user_list (user_id, list_id),
  INDEX idx_user_status (user_id, status),
  INDEX idx_user_due (user_id, due_at),
  INDEX idx_user_deleted_updated (user_id, deleted_at, updated_at),
  INDEX idx_pinned_sort (user_id, is_pinned DESC, sort_order ASC),
  INDEX idx_parent (parent_task_id),
  FULLTEXT INDEX idx_search (title, notes),
  CHECK (completed_at IS NULL OR completed_at >= created_at),
  CHECK (due_at IS NULL OR remind_at IS NULL OR remind_at <= due_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 任务-标签关联表（多对多）
-- ==========================================

CREATE TABLE task_tags (
  task_id INT NOT NULL,
  tag_id INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (task_id, tag_id),
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
  INDEX idx_tag_id (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 子任务表
-- ==========================================

CREATE TABLE subtasks (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  task_id INT NOT NULL,
  title VARCHAR(500) NOT NULL,
  is_completed BOOLEAN NOT NULL DEFAULT FALSE,
  sort_order INT NOT NULL DEFAULT 0,
  completed_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  INDEX idx_task_id (task_id),
  INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 附件表
-- ==========================================

CREATE TABLE attachments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  task_id INT NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_size BIGINT NOT NULL, -- bytes
  mime_type VARCHAR(100) NOT NULL,
  attachment_type ENUM('file', 'image', 'audio', 'video', 'document') NOT NULL,
  thumbnail_path VARCHAR(500),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  INDEX idx_task_id (task_id),
  INDEX idx_type (attachment_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 重复规则表
-- ==========================================

CREATE TABLE recurrence_rules (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  frequency ENUM('daily', 'weekly', 'monthly', 'yearly') NOT NULL,
  interval INT NOT NULL DEFAULT 1, -- 每N个频率单位
  count INT, -- 重复次数（NULL表示无限）
  until_date DATETIME, -- 结束日期
  by_weekday SET('MON','TUE','WED','THU','FRI','SAT','SUN'), -- 星期几
  by_monthday SET('1','2',...,'31'), -- 月份的第几天
  by_month SET('1','2',...,'12'), -- 月份
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_uuid (uuid),
  CHECK (count IS NULL OR count > 0),
  CHECK (until_date IS NULL OR count IS NULL) -- count和until_date只能设置一个
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 智能提醒表
-- ==========================================

CREATE TABLE smart_reminders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  task_id INT NOT NULL,
  reminder_type ENUM('location', 'weather', 'traffic', 'context') NOT NULL,
  trigger_condition JSON NOT NULL, -- 触发条件配置
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  last_triggered_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  UNIQUE KEY uk_uuid (uuid),
  INDEX idx_task_id (task_id),
  INDEX idx_type_active (reminder_type, is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 专注会话表
-- ==========================================

CREATE TABLE focus_sessions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  user_id INT NOT NULL,
  task_id INT,
  duration_minutes INT NOT NULL,
  started_at DATETIME NOT NULL,
  ended_at DATETIME,
  interruptions INT DEFAULT 0,
  notes TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE SET NULL,
  UNIQUE KEY uk_uuid (uuid),
  INDEX idx_user_id (user_id),
  INDEX idx_task_id (task_id),
  INDEX idx_started_at (started_at),
  CHECK (ended_at IS NULL OR ended_at > started_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 笔记表
-- ==========================================

CREATE TABLE notes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  uuid VARCHAR(36) NOT NULL UNIQUE,
  user_id INT NOT NULL,
  title VARCHAR(500) NOT NULL,
  content MEDIUMTEXT NOT NULL, -- Markdown格式
  category ENUM('general','work','personal','study','project','meeting','journal','reference') DEFAULT 'general',
  folder_path VARCHAR(500), -- 文件夹层级路径
  is_pinned BOOLEAN NOT NULL DEFAULT FALSE,
  is_favorite BOOLEAN NOT NULL DEFAULT FALSE,
  is_archived BOOLEAN NOT NULL DEFAULT FALSE,
  cover_image_url VARCHAR(500),
  word_count INT,
  reading_time_minutes INT,
  view_count INT DEFAULT 0,
  last_viewed_at DATETIME,
  ocr_text TEXT, -- OCR识别文本用于搜索
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  version INT NOT NULL DEFAULT 1,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY uk_user_uuid (user_id, uuid),
  INDEX idx_user_category (user_id, category),
  INDEX idx_user_pinned (user_id, is_pinned),
  INDEX idx_folder (folder_path),
  FULLTEXT INDEX idx_search (title, content, ocr_text)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 笔记-标签关联表
-- ==========================================

CREATE TABLE note_tags (
  note_id INT NOT NULL,
  tag_id INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (note_id, tag_id),
  FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
  INDEX idx_tag_id (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 笔记-任务关联表
-- ==========================================

CREATE TABLE note_tasks (
  note_id INT NOT NULL,
  task_id INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (note_id, task_id),
  FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  INDEX idx_task_id (task_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 同步操作日志表
-- ==========================================

CREATE TABLE sync_operations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  device_id VARCHAR(100) NOT NULL,
  entity_type VARCHAR(50) NOT NULL, -- 'task', 'list', 'tag', 'note'
  entity_uuid VARCHAR(36) NOT NULL,
  operation ENUM('create', 'update', 'delete') NOT NULL,
  changes JSON, -- 字段级变更详情
  conflict_resolution VARCHAR(50), -- 'auto_merge', 'client_wins', 'server_wins'
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_device_created (user_id, device_id, created_at),
  INDEX idx_entity (entity_type, entity_uuid),
  INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci PARTITION BY RANGE (YEAR(created_at)) (
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION p2025 VALUES LESS THAN (2026),
  PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- ==========================================
-- 游戏化：成就表
-- ==========================================

CREATE TABLE achievements (
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  icon VARCHAR(100),
  points INT NOT NULL DEFAULT 0,
  tier ENUM('bronze', 'silver', 'gold', 'platinum') DEFAULT 'bronze',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_achievements (
  user_id INT NOT NULL,
  achievement_id INT NOT NULL,
  progress INT NOT NULL DEFAULT 0,
  unlocked_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, achievement_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE,
  INDEX idx_unlocked_at (unlocked_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 视图：用户任务统计
-- ==========================================

CREATE VIEW v_user_task_stats AS
SELECT
  user_id,
  COUNT(*) as total_tasks,
  SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_tasks,
  SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_tasks,
  SUM(CASE WHEN status = 'in_progress' THEN 1 ELSE 0 END) as in_progress_tasks,
  SUM(CASE WHEN due_at < NOW() AND status != 'completed' THEN 1 ELSE 0 END) as overdue_tasks,
  SUM(CASE WHEN is_pinned = TRUE THEN 1 ELSE 0 END) as pinned_tasks,
  AVG(CASE WHEN estimated_minutes > 0 AND actual_minutes > 0
      THEN ABS(actual_minutes - estimated_minutes) / estimated_minutes
      ELSE NULL END) as avg_estimation_error,
  MAX(updated_at) as last_updated_at
FROM tasks
WHERE deleted_at IS NULL
GROUP BY user_id;

-- ==========================================
-- 存储过程：清理过期数据
-- ==========================================

DELIMITER $$

CREATE PROCEDURE sp_cleanup_expired_data()
BEGIN
  DECLARE deleted_count INT DEFAULT 0;

  -- 清理30天前软删除的任务
  DELETE FROM tasks
  WHERE deleted_at IS NOT NULL
    AND deleted_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
  SET deleted_count = ROW_COUNT();

  -- 清理90天前的同步日志
  DELETE FROM sync_operations
  WHERE created_at < DATE_SUB(NOW(), INTERVAL 90 DAY);

  -- 清理过期会话
  DELETE FROM user_sessions
  WHERE expires_at < NOW();

  -- 记录清理日志
  INSERT INTO system_logs (event_type, message, created_at)
  VALUES ('cleanup', CONCAT('Cleaned up ', deleted_count, ' deleted tasks'), NOW());
END$$

DELIMITER ;

-- 定时任务（需要在MySQL Event Scheduler中配置）
CREATE EVENT IF NOT EXISTS evt_cleanup_expired_data
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO CALL sp_cleanup_expired_data();

-- 启用事件调度器
SET GLOBAL event_scheduler = ON;
```

### 11.2 优化查询示例

```sql
-- 1. 高效获取用户的任务列表（含列表和标签信息）
SELECT
  t.uuid,
  t.title,
  t.notes,
  t.priority,
  t.status,
  t.due_at,
  t.is_pinned,
  t.sort_order,
  l.name as list_name,
  l.color as list_color,
  GROUP_CONCAT(tag.name) as tags,
  (SELECT COUNT(*) FROM subtasks st WHERE st.task_id = t.id) as subtask_count,
  (SELECT COUNT(*) FROM subtasks st WHERE st.task_id = t.id AND st.is_completed = TRUE) as completed_subtask_count
FROM tasks t
INNER JOIN lists l ON t.list_id = l.id
LEFT JOIN task_tags tt ON t.id = tt.task_id
LEFT JOIN tags tag ON tt.tag_id = tag.id
WHERE t.user_id = ?
  AND t.deleted_at IS NULL
  AND l.deleted_at IS NULL
GROUP BY t.id
ORDER BY t.is_pinned DESC, t.sort_order ASC, t.created_at DESC
LIMIT ? OFFSET ?;

-- 2. 增量同步查询
SELECT
  t.uuid,
  t.title,
  -- ... 其他字段
  t.updated_at,
  t.deleted_at,
  'task' as entity_type
FROM tasks t
WHERE t.user_id = ? AND t.updated_at > ?

UNION ALL

SELECT
  l.uuid,
  l.name,
  -- ... 其他字段
  l.updated_at,
  l.deleted_at,
  'list' as entity_type
FROM lists l
WHERE l.user_id = ? AND l.updated_at > ?

UNION ALL

SELECT
  tag.uuid,
  tag.name,
  -- ... 其他字段
  tag.updated_at,
  tag.deleted_at,
  'tag' as entity_type
FROM tags tag
WHERE tag.user_id = ? AND tag.updated_at > ?

ORDER BY updated_at ASC;

-- 3. 搜索任务（全文搜索）
SELECT
  t.*,
  MATCH(t.title, t.notes) AGAINST(? IN NATURAL LANGUAGE MODE) as relevance
FROM tasks t
WHERE t.user_id = ?
  AND t.deleted_at IS NULL
  AND MATCH(t.title, t.notes) AGAINST(? IN NATURAL LANGUAGE MODE)
ORDER BY relevance DESC, t.updated_at DESC
LIMIT 20;

-- 4. 获取用户统计数据
SELECT
  stats.*,
  (SELECT COUNT(*) FROM focus_sessions WHERE user_id = ? AND started_at >= CURDATE()) as today_focus_sessions,
  (SELECT SUM(duration_minutes) FROM focus_sessions WHERE user_id = ? AND started_at >= CURDATE()) as today_focus_minutes
FROM v_user_task_stats stats
WHERE stats.user_id = ?;
```

---

## 12. 总体评分和优先级建议

### 12.1 评分总结

| 评估维度 | 评分 | 说明 |
|---------|------|------|
| 技术选型 | 7.5/10 | Hive和MySQL组合合理，但MySQL配置需优化 |
| 数据模型设计 | 6.5/10 | 客户端设计好，服务端过度使用JSON字段 |
| 索引策略 | 5/10 | 缺少复合索引和覆盖索引 |
| 数据完整性 | 4/10 | 缺少外键、CHECK约束 |
| 查询性能 | 5.5/10 | 存在N+1问题，无缓存层 |
| 同步机制 | 5/10 | 全量同步效率低，冲突解决简单 |
| 数据访问层 | 7/10 | 客户端Repository模式好，服务端缺少抽象 |
| 可扩展性 | 5/10 | 单体架构，无读写分离，连接池小 |
| 迁移策略 | 3/10 | 无版本控制迁移系统 |
| 安全性 | 7/10 | 参数化查询良好，但Token管理需改进 |
| **总体评分** | **5.9/10** | 基础功能可用，但需大量优化 |

### 12.2 优先级修复建议

#### 🔴 P0 - 严重问题（立即修复）

1. **添加数据库迁移系统**
   - 使用Knex.js或类似工具
   - 建立版本控制
   - 工作量：3-5天

2. **修复user_tasks表设计**
   - 规范化JSON字段（提取子任务、附件、标签到独立表）
   - 添加外键约束
   - 添加复合索引
   - 工作量：5-7天

3. **实现增量同步**
   - 基于timestamp的增量同步
   - 添加sync_operations表
   - 工作量：3-5天

#### 🟡 P1 - 重要问题（1-2周内修复）

4. **优化索引策略**
   - 添加复合索引
   - 添加覆盖索引
   - 工作量：2-3天

5. **引入Redis缓存**
   - Session管理
   - 查询结果缓存
   - 工作量：3-5天

6. **改进连接池配置**
   - 增大连接池
   - 添加超时配置
   - 工作量：1天

7. **实现Repository层**
   - 抽象数据访问
   - 改善代码结构
   - 工作量：5-7天

#### 🟢 P2 - 改进建议（1个月内完成）

8. **实现读写分离**
   - 配置主从数据库
   - 读写路由
   - 工作量：5-7天

9. **优化同步冲突解决**
   - 字段级冲突检测
   - 自动合并策略
   - 工作量：7-10天

10. **添加数据完整性约束**
    - CHECK约束
    - 唯一性约束
    - 工作量：2-3天

11. **实现全文搜索**
    - MySQL FULLTEXT索引
    - 或集成Elasticsearch
    - 工作量：3-5天

#### 🔵 P3 - 长期优化（3个月内）

12. **考虑更换客户端数据库**
    - 评估Isar或Drift
    - 支持复杂查询
    - 工作量：10-15天

13. **实现分库分表**
    - 按用户分片
    - 工作量：15-20天

14. **迁移到云存储**
    - S3/阿里云OSS
    - CDN加速
    - 工作量：5-7天

15. **监控和性能分析**
    - APM集成
    - 慢查询分析
    - 工作量：3-5天

---

## 13. 结论

TodoList项目的数据库架构在基础功能上是可用的，但存在多个需要改进的领域：

### 优势
- 客户端Hive实现了良好的离线访问体验
- 使用Freezed确保实体不可变性，代码质量好
- 基本的版本控制机制已实现

### 关键问题
- 服务端数据库设计过度依赖JSON字段，失去关系型数据库优势
- 缺少完整的索引策略，查询性能有待提升
- 同步机制过于简单，需要实现增量同步和更好的冲突解决
- 缺少数据库迁移版本控制系统
- 连接池配置和缓存策略需要优化

### 建议
1. **短期**：修复P0级别问题，特别是迁移系统和表设计
2. **中期**：优化性能和扩展性（索引、缓存、读写分离）
3. **长期**：考虑架构升级（分库分表、客户端数据库升级）

实施这些改进后，预计整体评分可以从当前的 **5.9/10** 提升到 **8.5/10**。

---

**报告生成时间**：2025-10-17
**分析范围**：客户端(Flutter/Hive) + 服务端(Node.js/MySQL)
**代码库路径**：E:\todolist
