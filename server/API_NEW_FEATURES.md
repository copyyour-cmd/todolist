# 新增 API 功能文档

本文档包含最新添加的云同步、用户管理、密码重置和设备管理功能。

---

## 任务管理 API

### 1. 获取任务列表

**端点**: `GET /api/tasks`

**描述**: 获取用户的任务列表，支持分页、过滤和增量同步

**请求头**:
```
Authorization: Bearer {token}
```

**查询参数**:
- `page`: 页码（默认1）
- `limit`: 每页数量（默认100）
- `listId`: 按列表ID过滤（可选）
- `status`: 按状态过滤（可选: pending, in_progress, completed）
- `priority`: 按优先级过滤（可选: none, low, medium, high）
- `includeDeleted`: 是否包含已删除任务（默认false）
- `updatedAfter`: 增量同步时间点（ISO 8601格式）

**成功响应** (200):
```json
{
  "success": true,
  "data": {
    "tasks": [
      {
        "id": "task-uuid",
        "server_id": 1,
        "title": "完成项目文档",
        "description": "编写完整的API文档",
        "list_id": "list-001",
        "tags": ["work", "urgent"],
        "priority": "high",
        "status": "pending",
        "due_at": "2024-01-15T10:00:00Z",
        "remind_at": "2024-01-15T09:00:00Z",
        "repeat_type": "none",
        "sub_tasks": [
          {
            "id": "sub-001",
            "title": "草稿",
            "is_completed": true
          }
        ],
        "estimated_minutes": 120,
        "is_pinned": false,
        "version": 1,
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-10T00:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 100,
      "total": 50,
      "total_pages": 1
    }
  }
}
```

---

### 2. 创建任务

**端点**: `POST /api/tasks`

**请求体**:
```json
{
  "client_id": "task-uuid",
  "title": "新任务",
  "description": "任务描述",
  "list_id": "list-001",
  "tags": ["tag-001", "tag-002"],
  "priority": "high",
  "status": "pending",
  "due_at": "2024-01-15T10:00:00Z",
  "remind_at": "2024-01-15T09:00:00Z",
  "repeat_type": "daily",
  "repeat_rule": {
    "type": "daily",
    "interval": 1,
    "end_date": "2024-12-31T23:59:59Z"
  },
  "sub_tasks": [
    {
      "id": "sub-001",
      "title": "子任务1",
      "is_completed": false
    }
  ],
  "estimated_minutes": 60
}
```

**成功响应** (201):
```json
{
  "success": true,
  "message": "任务创建成功",
  "data": {
    // 完整的任务对象
  }
}
```

**错误响应**:
- `409`: 任务ID已存在（DUPLICATE_TASK_ID）

---

### 3. 更新任务

**端点**: `PUT /api/tasks/:taskId`

**描述**: 更新任务，支持版本冲突检测

**请求体**: 与创建任务相同，但所有字段都是可选的

**成功响应** (200):
```json
{
  "success": true,
  "message": "任务更新成功",
  "data": {
    // 更新后的任务对象
  }
}
```

**错误响应**:
- `404`: 任务不存在
- `409`: 版本冲突
```json
{
  "success": false,
  "message": "任务版本冲突",
  "error": "VERSION_CONFLICT",
  "data": {
    "server_version": 5,
    "client_version": 3,
    "server_task": {
      // 服务器端的任务数据
    }
  }
}
```

---

### 4. 删除任务

**端点**: `DELETE /api/tasks/:taskId`

**查询参数**:
- `permanent`: 是否永久删除（默认false，软删除）

**成功响应** (200):
```json
{
  "success": true,
  "message": "任务已删除"
}
```

---

### 5. 恢复任务

**端点**: `POST /api/tasks/:taskId/restore`

**成功响应** (200):
```json
{
  "success": true,
  "message": "任务已恢复",
  "data": {
    // 恢复后的任务对象
  }
}
```

---

### 6. 批量更新任务

**端点**: `POST /api/tasks/batch/update`

**请求体**:
```json
{
  "task_ids": ["task-001", "task-002", "task-003"],
  "updates": {
    "status": "completed",
    "priority": "low",
    "list_id": "list-new",
    "is_pinned": true
  }
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "批量更新成功",
  "data": {
    "updated_count": 3
  }
}
```

---

## 同步 API

### 1. 批量同步

**端点**: `POST /api/sync`

**描述**: 双向同步任务、列表、标签数据

**请求体**:
```json
{
  "device_id": "device-uuid",
  "last_sync_at": "2024-01-01T00:00:00Z",
  "tasks": [
    {
      "id": "task-001",
      "title": "本地任务",
      "version": 1,
      // ... 其他字段
    }
  ],
  "deleted_task_ids": ["task-to-delete"],
  "lists": [
    {
      "id": "list-001",
      "name": "工作",
      "color": "#FF5722"
    }
  ],
  "deleted_list_ids": [],
  "tags": [
    {
      "id": "tag-001",
      "name": "重要",
      "color": "#F44336"
    }
  ],
  "deleted_tag_ids": []
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "同步成功",
  "data": {
    "uploaded_tasks": 5,
    "downloaded_tasks": [
      // 服务器端新增或更新的任务
    ],
    "conflicts": [
      {
        "type": "task",
        "client_id": "task-001",
        "conflict_type": "version",
        "server_version": 3,
        "client_version": 1,
        "server_data": { /* ... */ },
        "client_data": { /* ... */ }
      }
    ],
    "uploaded_lists": 2,
    "downloaded_lists": [ /* ... */ ],
    "uploaded_tags": 1,
    "downloaded_tags": [ /* ... */ ],
    "sync_at": "2024-01-10T12:00:00Z"
  }
}
```

---

### 2. 获取同步状态

**端点**: `GET /api/sync/status`

**成功响应** (200):
```json
{
  "success": true,
  "data": {
    "last_sync": "2024-01-10T12:00:00Z",
    "sync_history": [
      {
        "id": 1,
        "user_id": 1,
        "device_id": "device-001",
        "sync_type": "full",
        "records_count": 25,
        "status": "success",
        "sync_at": "2024-01-10T12:00:00Z"
      }
    ],
    "pending_sync_count": 0
  }
}
```

---

### 3. 强制全量同步

**端点**: `GET /api/sync/full`

**描述**: 获取服务器上的所有数据（不上传本地数据）

**成功响应** (200):
```json
{
  "success": true,
  "message": "全量同步数据获取成功",
  "data": {
    "tasks": [ /* 所有任务 */ ],
    "lists": [ /* 所有列表 */ ],
    "tags": [ /* 所有标签 */ ],
    "sync_at": "2024-01-10T12:00:00Z"
  }
}
```

---

## 用户管理 API

### 1. 获取用户资料

**端点**: `GET /api/user/profile`

**成功响应** (200):
```json
{
  "success": true,
  "data": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "nickname": "测试用户",
    "avatar_url": "/uploads/avatars/1.jpg",
    "phone": "13800138000",
    "status": 1,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-10T00:00:00Z"
  }
}
```

---

### 2. 更新用户资料

**端点**: `PUT /api/user/profile`

**请求体**:
```json
{
  "nickname": "新昵称",
  "email": "newemail@example.com",
  "phone": "13900139000"
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "资料更新成功",
  "data": {
    // 更新后的用户信息
  }
}
```

**错误响应**:
- `400`: 邮箱或手机号已被使用

---

### 3. 修改密码

**端点**: `POST /api/user/change-password`

**请求体**:
```json
{
  "old_password": "oldpass123",
  "new_password": "newpass456"
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "密码修改成功"
}
```

**错误响应**:
- `401`: 旧密码不正确
- `400`: 新密码长度不足

---

### 4. 删除账户

**端点**: `DELETE /api/user/account`

**请求体**:
```json
{
  "password": "userpassword"
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "账户已删除"
}
```

---

## 密码重置 API

### 1. 请求密码重置

**端点**: `POST /api/password/reset-request`

**描述**: 生成重置令牌（实际应该发送邮件）

**请求体**:
```json
{
  "email": "user@example.com"
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "重置链接已发送到您的邮箱",
  "resetToken": "abc123..."  // 仅开发环境返回
}
```

---

### 2. 验证重置令牌

**端点**: `POST /api/password/verify-token`

**请求体**:
```json
{
  "token": "reset-token-here"
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "令牌有效"
}
```

**错误响应**:
- `400`: 令牌无效或已过期

---

### 3. 重置密码

**端点**: `POST /api/password/reset`

**请求体**:
```json
{
  "token": "reset-token-here",
  "new_password": "newpass123"
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "密码重置成功"
}
```

**说明**: 重置成功后，该用户的所有会话将被清除，需要重新登录。

---

## 设备管理 API

### 1. 获取设备列表

**端点**: `GET /api/devices`

**成功响应** (200):
```json
{
  "success": true,
  "data": {
    "devices": [
      {
        "id": 1,
        "device_id": "device-001",
        "device_name": "iPhone 13",
        "device_type": "ios",
        "ip_address": "192.168.1.100",
        "user_agent": "Mozilla/5.0...",
        "created_at": "2024-01-01T00:00:00Z",
        "last_used_at": "2024-01-10T12:00:00Z",
        "is_active": true,
        "is_current": false
      }
    ],
    "total": 3,
    "active_count": 2
  }
}
```

---

### 2. 登出指定设备

**端点**: `DELETE /api/devices/:deviceId`

**成功响应** (200):
```json
{
  "success": true,
  "message": "设备已登出"
}
```

---

### 3. 登出所有其他设备

**端点**: `POST /api/devices/logout-others`

**成功响应** (200):
```json
{
  "success": true,
  "message": "已登出所有其他设备",
  "data": {
    "logged_out_count": 2
  }
}
```

---

### 4. 更新设备名称

**端点**: `PUT /api/devices/:deviceId/name`

**请求体**:
```json
{
  "device_name": "我的新手机"
}
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "设备名称已更新"
}
```

---

## 错误码说明

所有 API 遵循统一的错误响应格式：

```json
{
  "success": false,
  "message": "错误描述",
  "error": "ERROR_CODE"  // 可选
}
```

### 常见错误码

| 状态码 | 说明 |
|--------|------|
| 400 | 请求参数错误 |
| 401 | 未授权（未登录或令牌过期） |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 409 | 数据冲突（如版本冲突、ID重复） |
| 500 | 服务器内部错误 |

### 特殊错误码

- `VERSION_CONFLICT`: 任务版本冲突
- `DUPLICATE_TASK_ID`: 任务ID重复
- `TIMEOUT`: 连接超时
- `CONNECTION_ERROR`: 网络连接失败

---

## 最佳实践

### 1. 增量同步
```javascript
// 保存最后同步时间
localStorage.setItem('last_sync', '2024-01-10T12:00:00Z');

// 下次同步时使用
fetch('/api/tasks?updatedAfter=' + lastSync);
```

### 2. 冲突处理
```javascript
// 策略1: 最新写入优先
if (conflict.server_version > conflict.client_version) {
  // 使用服务器数据
  useServerData(conflict.server_data);
}

// 策略2: 让用户选择
showConflictDialog(conflict);
```

### 3. 离线支持
```javascript
// 检测网络状态
if (navigator.onLine) {
  await syncData();
} else {
  // 保存到离线队列
  offlineQueue.push(operation);
}
```

---

## 性能优化建议

1. **使用增量同步**: 传递 `updatedAfter` 参数只获取变更数据
2. **批量操作**: 使用批量更新接口而非逐个更新
3. **启用压缩**: 备份时启用压缩减少传输大小
4. **合理分页**: 任务列表使用适当的 limit（建议20-100）
5. **缓存用户信息**: 用户资料不常变化，可缓存减少请求

---

## 版本历史

### v1.0.0 (2024-01-10)
- ✅ 完整的任务云同步系统
- ✅ 用户资料管理
- ✅ 密码重置功能
- ✅ 设备管理功能
- ✅ 版本冲突检测
- ✅ 数据备份恢复

---

更多信息请参考：
- `API_DOCUMENTATION.md` - 基础 API 文档
- `DEVELOPMENT_SUMMARY.md` - 功能总结
- `DEPLOYMENT_GUIDE.md` - 部署指南
