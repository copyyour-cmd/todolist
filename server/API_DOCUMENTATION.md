# TodoList 云服务 API 文档

## 基础信息

- **Base URL**: `http://192.168.88.209:3000`
- **API 版本**: v1
- **认证方式**: JWT Bearer Token

## 认证流程

1. 用户注册或登录获取 `token` 和 `refreshToken`
2. 在需要认证的接口请求头中添加: `Authorization: Bearer {token}`
3. Token 过期时使用 `refreshToken` 刷新获取新 token
4. 退出登录时调用 logout 接口清除会话

---

## API 端点

### 1. 用户注册

**端点**: `POST /api/auth/register`

**描述**: 注册新用户账号

**请求体**:
```json
{
  "username": "testuser",          // 必填，3-20个字符，字母数字下划线
  "email": "test@example.com",     // 必填，有效的邮箱地址
  "password": "password123",        // 必填，至少6个字符
  "nickname": "测试用户",           // 可选，昵称
  "deviceType": "android"          // 可选，设备类型
}
```

**成功响应** (201):
```json
{
  "success": true,
  "message": "注册成功",
  "data": {
    "user": {
      "id": 1,
      "username": "testuser",
      "email": "test@example.com",
      "nickname": "测试用户",
      "avatar_url": null,
      "created_at": "2024-01-01T00:00:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**错误响应**:
- `400`: 参数错误（用户名已存在、邮箱已注册、格式不正确等）
- `500`: 服务器错误

---

### 2. 用户登录

**端点**: `POST /api/auth/login`

**描述**: 用户登录获取认证令牌

**请求体**:
```json
{
  "username": "testuser",          // 必填，用户名或邮箱
  "password": "password123",        // 必填
  "deviceType": "android",         // 可选，设备类型: ios, android, web
  "deviceId": "device-uuid",       // 可选，设备唯一ID
  "deviceName": "Xiaomi 12"        // 可选，设备名称
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "登录成功",
  "data": {
    "user": {
      "id": 1,
      "username": "testuser",
      "email": "test@example.com",
      "nickname": "测试用户",
      "avatar_url": null,
      "phone": null,
      "status": 1,
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z",
      "last_login_at": "2024-01-01T00:00:00.000Z",
      "last_login_ip": "192.168.1.100"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**错误响应**:
- `401`: 用户名或密码错误
- `403`: 账户已被禁用
- `500`: 服务器错误

---

### 3. 获取当前用户信息

**端点**: `GET /api/auth/me`

**描述**: 获取当前登录用户的详细信息

**请求头**:
```
Authorization: Bearer {token}
```

**成功响应** (200):
```json
{
  "success": true,
  "data": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "nickname": "测试用户",
    "avatar_url": null,
    "phone": null,
    "status": 1,
    "created_at": "2024-01-01T00:00:00.000Z",
    "last_login_at": "2024-01-01T00:00:00.000Z"
  }
}
```

**错误响应**:
- `401`: 未提供令牌或令牌已过期
- `403`: 无效的令牌
- `404`: 用户不存在
- `500`: 服务器错误

---

### 4. 刷新令牌

**端点**: `POST /api/auth/refresh-token`

**描述**: 使用刷新令牌获取新的访问令牌

**请求体**:
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "令牌刷新成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**错误响应**:
- `400`: 无效的刷新令牌
- `401`: 刷新令牌已过期或会话不存在
- `500`: 服务器错误

---

### 5. 退出登录

**端点**: `POST /api/auth/logout`

**描述**: 退出登录，清除用户会话

**请求头**:
```
Authorization: Bearer {token}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "退出登录成功"
}
```

**错误响应**:
- `500`: 服务器错误

---

## 错误码说明

| 状态码 | 说明 |
|--------|------|
| 200 | 请求成功 |
| 201 | 创建成功 |
| 400 | 请求参数错误 |
| 401 | 未授权（未登录或令牌过期） |
| 403 | 禁止访问（令牌无效或账户被禁用） |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

---

## 认证令牌说明

### Access Token (访问令牌)
- **有效期**: 7天
- **用途**: 访问需要认证的 API
- **使用方式**: 请求头 `Authorization: Bearer {token}`

### Refresh Token (刷新令牌)
- **有效期**: 30天
- **用途**: 获取新的访问令牌
- **使用方式**: 调用 `/api/auth/refresh-token` 接口

---

## 数据库表结构

### users (用户表)
- `id`: 用户ID (主键)
- `username`: 用户名 (唯一)
- `email`: 邮箱 (唯一)
- `password_hash`: 密码哈希
- `nickname`: 昵称
- `avatar_url`: 头像URL
- `phone`: 手机号
- `status`: 状态 (0-禁用, 1-正常)
- `last_login_at`: 最后登录时间
- `last_login_ip`: 最后登录IP
- `created_at`: 创建时间
- `updated_at`: 更新时间

### user_sessions (用户会话表)
- `id`: 会话ID (主键)
- `user_id`: 用户ID (外键)
- `token`: JWT Token
- `refresh_token`: 刷新Token
- `device_id`: 设备ID
- `device_name`: 设备名称
- `device_type`: 设备类型
- `ip_address`: IP地址
- `user_agent`: User Agent
- `expires_at`: 过期时间
- `created_at`: 创建时间
- `last_used_at`: 最后使用时间

---

## 使用示例

### 使用 curl 测试

#### 1. 注册用户
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

#### 2. 用户登录
```bash
curl -X POST http://192.168.88.209:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123",
    "deviceType": "android"
  }'
```

#### 3. 获取用户信息
```bash
curl -X GET http://192.168.88.209:3000/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

#### 4. 刷新令牌
```bash
curl -X POST http://192.168.88.209:3000/api/auth/refresh-token \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "YOUR_REFRESH_TOKEN_HERE"
  }'
```

#### 5. 退出登录
```bash
curl -X POST http://192.168.88.209:3000/api/auth/logout \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 安全建议

1. **HTTPS**: 生产环境必须使用 HTTPS
2. **密码策略**: 密码至少8个字符，包含大小写字母和数字
3. **Token 存储**: 客户端应安全存储 token，避免 XSS 攻击
4. **刷新策略**: Token 过期前主动刷新，避免用户感知
5. **会话管理**: 定期清理过期会话
6. **日志审计**: 记录敏感操作日志

---

## 启动服务器

### 初始化数据库
```bash
cd server
npm run init-db
```

### 启动开发服务器
```bash
cd server
npm run dev
```

### 启动生产服务器
```bash
cd server
npm start
```

---

## 环境变量配置

在 `server/.env` 文件中配置:

```env
PORT=3000
HOST=192.168.88.209
DB_HOST=192.168.88.207
DB_PORT=3306
DB_USER=root
DB_PASSWORD=goodboy
DB_NAME=todolist_cloud
JWT_SECRET=todolist-secret-key-2024-please-change-in-production
JWT_EXPIRES_IN=7d
REFRESH_TOKEN_EXPIRES_IN=30d
BACKUP_ENCRYPTION_KEY=backup-encryption-key-2024-change-in-production
```

---

## 备份与恢复 API

### 6. 创建数据备份

**端点**: `POST /api/backup/create`

**描述**: 创建用户所有数据的完整备份

**请求头**:
```
Authorization: Bearer {token}
```

**请求体**:
```json
{
  "backupName": "我的备份_2024",       // 可选，备份名称
  "backupType": "full",               // 可选，备份类型: full-完整备份, incremental-增量备份
  "deviceId": "device-uuid",          // 可选，设备ID
  "deviceName": "Xiaomi 12",          // 可选，设备名称
  "deviceType": "android",            // 可选，设备类型: ios, android, web
  "appVersion": "1.0.0",              // 可选，应用版本
  "enableCompression": true,          // 可选，是否启用压缩（默认false）
  "enableEncryption": false           // 可选，是否启用加密（默认false）
}
```

**成功响应** (201):
```json
{
  "success": true,
  "message": "备份创建成功",
  "data": {
    "backup_id": 1,
    "backup_name": "我的备份_2024",
    "backup_size": 1024000,
    "items_count": 150,
    "is_compressed": true,
    "is_encrypted": false,
    "created_at": "2024-01-01T00:00:00.000Z"
  }
}
```

**错误响应**:
- `401`: 未授权
- `500`: 服务器错误

---

### 7. 恢复数据备份

**端点**: `POST /api/backup/restore/:backupId`

**描述**: 从指定备份恢复用户数据

**请求头**:
```
Authorization: Bearer {token}
```

**请求体**:
```json
{
  "deviceId": "device-uuid",          // 可选，设备ID
  "mergeMode": "replace"              // 可选，恢复模式: replace-替换现有数据, merge-合并数据（默认replace）
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "数据恢复成功",
  "data": {
    "restored_count": 150,
    "backup_name": "我的备份_2024",
    "backup_date": "2024-01-01T00:00:00.000Z",
    "merge_mode": "replace"
  }
}
```

**错误响应**:
- `400`: 备份数据已损坏
- `401`: 未授权
- `404`: 备份不存在
- `500`: 服务器错误

---

### 8. 获取备份列表

**端点**: `GET /api/backup/list`

**描述**: 获取用户的所有备份记录

**请求头**:
```
Authorization: Bearer {token}
```

**查询参数**:
- `page`: 页码（默认1）
- `limit`: 每页数量（默认20）
- `backupType`: 备份类型过滤（可选: full, incremental）

**成功响应** (200):
```json
{
  "success": true,
  "data": {
    "backups": [
      {
        "id": 1,
        "backup_name": "我的备份_2024",
        "backup_type": "full",
        "backup_size": 1024000,
        "backup_size_mb": "0.98",
        "device_id": "device-uuid",
        "device_name": "Xiaomi 12",
        "device_type": "android",
        "app_version": "1.0.0",
        "data_hash": "abc123...",
        "is_encrypted": false,
        "is_compressed": true,
        "backup_status": "completed",
        "created_at": "2024-01-01T00:00:00.000Z",
        "updated_at": "2024-01-01T00:00:00.000Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 10,
      "total_pages": 1
    }
  }
}
```

---

### 9. 获取备份详情

**端点**: `GET /api/backup/:backupId`

**描述**: 获取指定备份的详细信息

**请求头**:
```
Authorization: Bearer {token}
```

**成功响应** (200):
```json
{
  "success": true,
  "data": {
    "id": 1,
    "backup_name": "我的备份_2024",
    "backup_type": "full",
    "backup_size": 1024000,
    "backup_size_mb": "0.98",
    "device_id": "device-uuid",
    "device_name": "Xiaomi 12",
    "device_type": "android",
    "app_version": "1.0.0",
    "data_hash": "abc123...",
    "is_encrypted": false,
    "is_compressed": true,
    "backup_status": "completed",
    "error_message": null,
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-01T00:00:00.000Z"
  }
}
```

**错误响应**:
- `401`: 未授权
- `404`: 备份不存在
- `500`: 服务器错误

---

### 10. 删除备份

**端点**: `DELETE /api/backup/:backupId`

**描述**: 删除指定的备份记录

**请求头**:
```
Authorization: Bearer {token}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "备份删除成功"
}
```

**错误响应**:
- `401`: 未授权
- `404`: 备份不存在
- `500`: 服务器错误

---

### 11. 获取备份历史

**端点**: `GET /api/backup/history/list`

**描述**: 获取用户的备份/恢复操作历史记录

**请求头**:
```
Authorization: Bearer {token}
```

**查询参数**:
- `page`: 页码（默认1）
- `limit`: 每页数量（默认20）
- `operationType`: 操作类型过滤（可选: backup, restore）

**成功响应** (200):
```json
{
  "success": true,
  "data": {
    "history": [
      {
        "id": 1,
        "backup_id": 1,
        "operation_type": "backup",
        "status": "success",
        "items_count": 150,
        "error_message": null,
        "device_id": "device-uuid",
        "ip_address": "192.168.1.100",
        "created_at": "2024-01-01T00:00:00.000Z",
        "backup_name": "我的备份_2024"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 5,
      "total_pages": 1
    }
  }
}
```

---

## 数据备份说明

### 备份内容

备份包含以下所有用户数据：
- **任务（Tasks）**: 所有任务记录，包括标题、描述、完成状态、优先级、截止日期等
- **列表（Lists）**: 所有任务列表，包括名称、图标、颜色、排序等
- **标签（Tags）**: 所有标签，包括名称、颜色等
- **设置（Settings）**: 应用设置数据（JSON格式）

### 备份类型

- **完整备份（full）**: 备份所有数据
- **增量备份（incremental）**: 仅备份自上次备份后发生变化的数据（待实现）

### 备份特性

- **压缩**: 支持 gzip 压缩，可大幅减小备份大小
- **加密**: 支持 AES-256 加密保护敏感数据
- **校验**: 使用 SHA-256 哈希值验证数据完整性
- **设备追踪**: 记录备份创建的设备信息
- **历史记录**: 完整的备份/恢复操作审计日志

### 恢复模式

- **替换模式（replace）**: 清空现有数据，完全恢复备份数据
- **合并模式（merge）**: 保留现有数据，合并备份数据（相同ID则更新）

---

## 后续开发计划

- [ ] 密码重置功能
- [ ] 邮箱验证
- [ ] 手机号绑定
- [ ] 第三方登录（微信、QQ等）
- [ ] 用户资料更新
- [ ] 头像上传
- [ ] 任务云同步接口
- [x] 数据备份恢复
- [ ] 增量备份优化
