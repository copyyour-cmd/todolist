# TodoList 部署和测试指南

## 🚀 快速启动

### 1. 服务器端部署

#### 环境准备
```bash
# 确保已安装
- Node.js >= 16.x
- MySQL >= 8.0
- npm 或 yarn
```

#### 数据库初始化
```bash
# 1. 创建基础表结构
cd server
npm run init-db

# 2. 添加扩展字段（任务表优化）
mysql -u root -pgoodboy todolist_cloud < database/alter_user_tasks.sql

# 3. 创建备份相关表
mysql -u root -pgoodboy todolist_cloud < database/backup_schema.sql

# 4. 验证表结构
mysql -u root -pgoodboy -e "USE todolist_cloud; SHOW TABLES;"
```

#### 启动服务器
```bash
# 开发模式（支持热重载）
npm run dev

# 生产模式
npm start
```

服务器将在 `http://192.168.88.209:3000` 启动

### 2. Flutter 客户端部署

#### 安装依赖
```bash
cd E:/todolist
flutter pub get
```

#### 运行代码生成
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 运行应用
```bash
# Android
flutter run -d android

# Windows
flutter run -d windows

# iOS
flutter run -d ios
```

---

## 🧪 API 测试

### 1. 测试认证流程

#### 注册用户
```bash
curl -X POST http://192.168.88.209:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123",
    "nickname": "测试用户"
  }'
```

#### 用户登录
```bash
curl -X POST http://192.168.88.209:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123",
    "deviceType": "android",
    "deviceName": "Test Device"
  }'
```

保存返回的 `token` 用于后续请求。

### 2. 测试任务管理

#### 创建任务
```bash
curl -X POST http://192.168.88.209:3000/api/tasks \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "client_id": "task-001",
    "title": "测试任务",
    "description": "这是一个测试任务",
    "priority": "high",
    "status": "pending"
  }'
```

#### 获取任务列表
```bash
curl -X GET "http://192.168.88.209:3000/api/tasks?page=1&limit=20" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

#### 更新任务
```bash
curl -X PUT http://192.168.88.209:3000/api/tasks/task-001 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "更新后的任务",
    "status": "completed"
  }'
```

### 3. 测试同步功能

```bash
curl -X POST http://192.168.88.209:3000/api/sync \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "device_id": "device-001",
    "tasks": [],
    "deleted_task_ids": [],
    "lists": [],
    "deleted_list_ids": [],
    "tags": [],
    "deleted_tag_ids": []
  }'
```

### 4. 测试备份功能

#### 创建备份
```bash
curl -X POST http://192.168.88.209:3000/api/backup/create \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "backupName": "测试备份",
    "enableCompression": true,
    "enableEncryption": false
  }'
```

#### 获取备份列表
```bash
curl -X GET "http://192.168.88.209:3000/api/backup/list?page=1&limit=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 5. 测试用户资料管理

```bash
curl -X PUT http://192.168.88.209:3000/api/user/profile \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "nickname": "新昵称",
    "phone": "13800138000"
  }'
```

### 6. 测试设备管理

```bash
# 获取设备列表
curl -X GET http://192.168.88.209:3000/api/devices \
  -H "Authorization: Bearer YOUR_TOKEN"

# 登出其他设备
curl -X POST http://192.168.88.209:3000/api/devices/logout-others \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 📱 Flutter 客户端使用

### 1. 初始化网络服务

```dart
// 创建 HTTP 客户端
final client = DioClient();

// 创建认证服务
final authService = AuthService(client);

// 创建同步服务
final syncService = SyncService(client);
```

### 2. 用户登录

```dart
try {
  final user = await authService.login(
    username: 'testuser',
    password: 'password123',
    deviceType: 'android',
    deviceId: 'unique-device-id',
    deviceName: 'My Phone',
  );

  print('登录成功: ${user.username}');
} on HttpException catch (e) {
  print('登录失败: ${e.message}');
}
```

### 3. 同步数据

```dart
try {
  final result = await syncService.syncData(
    tasks: localTasks,
    deletedTaskIds: deletedIds,
    lists: localLists,
    deletedListIds: [],
    tags: localTags,
    deletedTagIds: [],
    deviceId: 'device-id',
  );

  print('上传任务: ${result.uploadedTasks}');
  print('下载任务: ${result.downloadedTasks}');
  print('冲突数: ${result.conflicts}');
} catch (e) {
  print('同步失败: $e');
}
```

### 4. 检查网络状态

```dart
final isOnline = await syncService.isNetworkAvailable();
if (isOnline) {
  // 执行同步
}
```

---

## 🔧 故障排查

### 数据库连接失败
```bash
# 检查 MySQL 服务状态
# Windows
net start MySQL80

# 检查数据库配置
mysql -u root -pgoodboy -e "SHOW DATABASES;"

# 验证 todolist_cloud 数据库
mysql -u root -pgoodboy -e "USE todolist_cloud; SHOW TABLES;"
```

### Token 验证失败
```bash
# 检查环境变量
cat server/.env | grep JWT_SECRET

# 验证 Token
curl -X GET http://192.168.88.209:3000/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 端口被占用
```bash
# Windows
netstat -ano | findstr :3000
taskkill /F /PID <PID>

# Linux/Mac
lsof -i :3000
kill -9 <PID>
```

### 同步冲突处理
```dart
// 方式1: 使用服务器数据
final serverData = await syncService.forceFullSync();

// 方式2: 处理冲突列表
if (result.conflicts > 0) {
  for (var conflict in result.conflictDetails) {
    // 根据业务逻辑选择保留客户端或服务器数据
  }
}
```

---

## 📊 性能优化建议

### 1. 数据库索引
所有关键字段已添加索引：
- user_id（所有表）
- created_at, updated_at
- status, priority, due_at
- is_pinned, sort_order

### 2. 同步策略
```dart
// 使用增量同步
final lastSync = await syncService.getLastSyncTime();

// 仅同步变更的数据
final changedTasks = tasks.where((t) =>
  t.updatedAt.isAfter(lastSync ?? DateTime(2000))
).toList();
```

### 3. 网络优化
```dart
// 批量操作
await taskService.batchUpdate(
  taskIds: ids,
  updates: {'status': 'completed'},
);

// 压缩备份
await backupService.createBackup(
  enableCompression: true,  // 减少传输大小
);
```

---

## 🔐 安全建议

### 生产环境配置

1. **修改密钥**
```env
JWT_SECRET=your-very-long-and-random-secret-key-here
BACKUP_ENCRYPTION_KEY=another-very-long-random-key
```

2. **使用 HTTPS**
```javascript
// server.js
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('private-key.pem'),
  cert: fs.readFileSync('certificate.pem')
};

https.createServer(options, app).listen(443);
```

3. **限制 CORS**
```javascript
app.use(cors({
  origin: 'https://your-domain.com',
  credentials: true
}));
```

4. **添加速率限制**
```bash
npm install express-rate-limit
```

```javascript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分钟
  max: 100 // 限制100次请求
});

app.use('/api/', limiter);
```

---

## 📝 监控和日志

### 查看服务器日志
```bash
# 开发环境（自动输出）
npm run dev

# 生产环境（使用 PM2）
npm install -g pm2
pm2 start server.js --name todolist-api
pm2 logs todolist-api
```

### 数据库监控
```sql
-- 查看活跃连接
SHOW PROCESSLIST;

-- 查看表大小
SELECT
  table_name,
  ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'todolist_cloud'
ORDER BY (data_length + index_length) DESC;

-- 查看最近同步记录
SELECT * FROM sync_logs ORDER BY sync_at DESC LIMIT 10;
```

---

## ✅ 部署检查清单

- [ ] MySQL 服务已启动
- [ ] 所有数据库表已创建
- [ ] 环境变量已配置
- [ ] Node.js 依赖已安装
- [ ] 服务器成功启动（http://192.168.88.209:3000）
- [ ] 健康检查通过 (/health)
- [ ] Flutter 依赖已安装
- [ ] 代码生成已运行
- [ ] API 配置正确（api_config.dart）
- [ ] 至少一个测试账号已创建
- [ ] Token 刷新机制正常
- [ ] 同步功能测试通过
- [ ] 备份功能测试通过

---

## 🎉 部署完成

恭喜！您的 TodoList 云服务系统已成功部署！

### 下一步
1. 创建测试账号进行完整流程测试
2. 配置自动备份计划
3. 设置监控和告警
4. 准备生产环境部署

### 技术支持
- 查看 `DEVELOPMENT_SUMMARY.md` 了解完整功能列表
- 查看 `server/API_DOCUMENTATION.md` 了解详细 API 文档
- 查看服务器日志排查问题

祝您使用愉快！🚀
