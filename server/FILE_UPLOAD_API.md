# 文件上传功能 API 文档

## 概述

TodoList 应用支持两种类型的文件上传：
1. **用户头像上传** - 用户个人资料的头像图片
2. **任务附件上传** - 任务关联的附件文件

所有上传的文件都存储在服务器的 `uploads/` 目录下，并通过静态文件服务提供访问。

## 文件存储结构

```
server/
└── uploads/
    ├── avatars/          # 用户头像 (5MB限制)
    └── attachments/      # 任务附件 (50MB限制)
```

## API 端点

### 1. 上传用户头像

**端点**: `POST /api/user/avatar`

**认证**: 需要 JWT Token

**Content-Type**: `multipart/form-data`

**请求参数**:
- `avatar` (文件) - 头像图片文件

**支持的文件类型**:
- jpeg, jpg, png, gif, webp

**文件大小限制**: 5MB

**请求示例** (使用 curl):
```bash
curl -X POST http://192.168.88.209:3000/api/user/avatar \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "avatar=@/path/to/image.jpg"
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "头像上传成功",
  "data": {
    "avatar_url": "/uploads/avatars/avatar-123-1234567890.jpg",
    "full_url": "http://192.168.88.209:3000/uploads/avatars/avatar-123-1234567890.jpg",
    "filename": "avatar-123-1234567890.jpg",
    "size": 153842
  }
}
```

**错误响应**:
- `400 Bad Request` - 未提供文件或文件类型不支持
- `401 Unauthorized` - 未提供认证令牌
- `500 Internal Server Error` - 服务器错误

**特性**:
- 自动删除旧头像文件
- 文件名格式: `avatar-{userId}-{timestamp}-{random}.{ext}`
- 返回相对路径和完整URL

---

### 2. 上传任务附件

**端点**: `POST /api/tasks/:taskId/attachments`

**认证**: 需要 JWT Token

**Content-Type**: `multipart/form-data`

**路径参数**:
- `taskId` (string) - 任务的客户端ID

**请求参数**:
- `attachments` (文件数组) - 最多10个附件文件

**支持的文件类型**:
- 图片: jpeg, jpg, png, gif, webp
- 文档: pdf, doc, docx, xls, xlsx, txt
- 压缩: zip, rar
- 媒体: mp3, mp4, avi

**文件大小限制**: 单个文件最大 50MB

**请求示例** (使用 curl):
```bash
# 单个文件
curl -X POST http://192.168.88.209:3000/api/tasks/task123/attachments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "attachments=@/path/to/document.pdf"

# 多个文件
curl -X POST http://192.168.88.209:3000/api/tasks/task123/attachments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "attachments=@/path/to/file1.pdf" \
  -F "attachments=@/path/to/file2.jpg"
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "成功上传 2 个附件",
  "data": {
    "task_id": "task123",
    "uploaded": [
      {
        "id": "att_1234567890_abc123def",
        "name": "document.pdf",
        "filename": "document-1234567890.pdf",
        "url": "/uploads/attachments/document-1234567890.pdf",
        "full_url": "http://192.168.88.209:3000/uploads/attachments/document-1234567890.pdf",
        "size": 258432,
        "mime_type": "application/pdf",
        "uploaded_at": "2025-10-05T13:23:00.000Z"
      },
      {
        "id": "att_1234567891_xyz789ghi",
        "name": "image.jpg",
        "filename": "image-1234567891.jpg",
        "url": "/uploads/attachments/image-1234567891.jpg",
        "full_url": "http://192.168.88.209:3000/uploads/attachments/image-1234567891.jpg",
        "size": 451234,
        "mime_type": "image/jpeg",
        "uploaded_at": "2025-10-05T13:23:01.000Z"
      }
    ],
    "total_attachments": 5
  }
}
```

**错误响应**:
- `400 Bad Request` - 未提供文件或文件类型不支持
- `404 Not Found` - 任务不存在
- `401 Unauthorized` - 未提供认证令牌
- `500 Internal Server Error` - 服务器错误

**特性**:
- 支持批量上传（最多10个文件）
- 附件与任务关联，存储在任务的 `attachments` JSON 字段
- 文件名自动清理特殊字符
- 文件名格式: `{cleanName}-{timestamp}-{random}.{ext}`
- 返回附件唯一ID、原始文件名、存储文件名、URL等信息
- 如果任务不存在，自动删除已上传的文件

---

### 3. 删除任务附件

**端点**: `DELETE /api/tasks/:taskId/attachments/:attachmentId`

**认证**: 需要 JWT Token

**路径参数**:
- `taskId` (string) - 任务的客户端ID
- `attachmentId` (string) - 附件的唯一ID

**请求示例** (使用 curl):
```bash
curl -X DELETE http://192.168.88.209:3000/api/tasks/task123/attachments/att_1234567890_abc123def \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**成功响应** (200):
```json
{
  "success": true,
  "message": "附件已删除",
  "data": {
    "task_id": "task123",
    "deleted_attachment_id": "att_1234567890_abc123def",
    "remaining_attachments": 4
  }
}
```

**错误响应**:
- `404 Not Found` - 任务或附件不存在
- `401 Unauthorized` - 未提供认证令牌
- `500 Internal Server Error` - 服务器错误

**特性**:
- 从任务的附件列表中移除附件记录
- 删除服务器上的物理文件
- 自动更新任务版本号

---

### 4. 下载文件

**端点**: `GET /uploads/{type}/{filename}`

**认证**: 不需要（静态文件服务）

**路径参数**:
- `type` - 文件类型 (`avatars` 或 `attachments`)
- `filename` - 文件名

**请求示例**:
```bash
# 下载头像
curl -O http://192.168.88.209:3000/uploads/avatars/avatar-123-1234567890.jpg

# 下载附件
curl -O http://192.168.88.209:3000/uploads/attachments/document-1234567890.pdf
```

**响应**: 文件数据流

**错误响应**:
- `404 Not Found` - 文件不存在

---

## 文件命名规则

### 头像文件名格式
```
avatar-{userId}-{timestamp}-{random}.{extension}
```
示例: `avatar-123-1697345678901-987654321.jpg`

### 附件文件名格式
```
{cleanedBasename}-{timestamp}-{random}.{extension}
```
示例: `my_document-1697345678901-987654321.pdf`

**文件名清理规则**:
- 保留: 英文字母、数字、中文字符
- 替换为下划线: 所有其他字符（空格、特殊符号等）

---

## 错误处理

### Multer 错误

**文件过大** (`LIMIT_FILE_SIZE`):
```json
{
  "success": false,
  "message": "文件太大",
  "error": "LIMIT_FILE_SIZE"
}
```

**文件类型不支持**:
```json
{
  "success": false,
  "message": "只允许上传图片文件 (jpeg, jpg, png, gif, webp)"
}
```

或

```json
{
  "success": false,
  "message": "不支持的文件类型"
}
```

### 通用错误

**未提供文件**:
```json
{
  "success": false,
  "message": "请上传头像文件"
}
```

**任务不存在**:
```json
{
  "success": false,
  "message": "任务不存在"
}
```

**附件不存在**:
```json
{
  "success": false,
  "message": "附件不存在"
}
```

---

## 使用场景示例

### 场景 1: 用户更新头像

1. 用户选择图片文件
2. 前端发送 POST 请求到 `/api/user/avatar`，携带 JWT Token
3. 服务器验证用户身份
4. 服务器检查旧头像并删除
5. 保存新头像文件
6. 更新数据库中的 `avatar_url` 字段
7. 返回新头像的 URL
8. 前端更新UI显示新头像

### 场景 2: 为任务添加附件

1. 用户为任务选择1个或多个附件文件
2. 前端发送 POST 请求到 `/api/tasks/{taskId}/attachments`
3. 服务器验证用户身份和任务所有权
4. 保存所有附件文件
5. 生成附件元数据（ID、URL、大小等）
6. 合并到任务的附件列表
7. 更新任务版本号
8. 返回上传的附件信息
9. 前端显示附件列表

### 场景 3: 删除任务附件

1. 用户点击删除附件按钮
2. 前端发送 DELETE 请求到 `/api/tasks/{taskId}/attachments/{attachmentId}`
3. 服务器验证用户身份和任务所有权
4. 从任务的附件列表中移除该附件
5. 删除服务器上的物理文件
6. 更新任务版本号
7. 返回剩余附件数量
8. 前端更新UI移除已删除的附件

---

## 安全考虑

1. **文件类型验证**:
   - 检查文件扩展名和 MIME 类型
   - 防止上传恶意脚本文件

2. **文件大小限制**:
   - 头像: 5MB
   - 附件: 50MB
   - 防止服务器存储耗尽

3. **身份验证**:
   - 所有上传接口都需要 JWT Token
   - 确保只有授权用户可以上传文件

4. **所有权验证**:
   - 验证用户只能操作自己的任务附件
   - 使用 `req.user.id` 和 `userId` 进行权限检查

5. **文件名安全**:
   - 生成唯一文件名，包含时间戳和随机数
   - 清理原始文件名中的特殊字符
   - 防止文件名冲突和路径遍历攻击

6. **错误处理**:
   - 上传失败时自动删除已上传的文件
   - 防止垃圾文件累积

---

## 数据库集成

### 用户表 (users)
```sql
avatar_url VARCHAR(500)  -- 存储头像相对路径
```

示例值: `/uploads/avatars/avatar-123-1234567890.jpg`

### 任务表 (user_tasks)
```sql
attachments JSON  -- 存储附件数组
```

示例值:
```json
[
  {
    "id": "att_1234567890_abc123def",
    "name": "document.pdf",
    "filename": "document-1234567890.pdf",
    "url": "/uploads/attachments/document-1234567890.pdf",
    "full_url": "http://192.168.88.209:3000/uploads/attachments/document-1234567890.pdf",
    "size": 258432,
    "mime_type": "application/pdf",
    "uploaded_at": "2025-10-05T13:23:00.000Z"
  }
]
```

---

## Flutter 集成示例

### 上传头像

```dart
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

Future<void> uploadAvatar(String token, File imageFile) async {
  final dio = Dio();

  final formData = FormData.fromMap({
    'avatar': await MultipartFile.fromFile(
      imageFile.path,
      filename: 'avatar.jpg',
      contentType: MediaType('image', 'jpeg'),
    ),
  });

  final response = await dio.post(
    'http://192.168.88.209:3000/api/user/avatar',
    data: formData,
    options: Options(
      headers: {'Authorization': 'Bearer $token'},
    ),
  );

  if (response.data['success']) {
    final avatarUrl = response.data['data']['full_url'];
    print('头像上传成功: $avatarUrl');
  }
}
```

### 上传任务附件

```dart
Future<void> uploadTaskAttachments(
  String token,
  String taskId,
  List<File> files
) async {
  final dio = Dio();

  final formData = FormData.fromMap({
    'attachments': files.map((file) async {
      return await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );
    }).toList(),
  });

  final response = await dio.post(
    'http://192.168.88.209:3000/api/tasks/$taskId/attachments',
    data: formData,
    options: Options(
      headers: {'Authorization': 'Bearer $token'},
    ),
  );

  if (response.data['success']) {
    final uploaded = response.data['data']['uploaded'];
    print('成功上传 ${uploaded.length} 个附件');
  }
}
```

### 删除任务附件

```dart
Future<void> deleteTaskAttachment(
  String token,
  String taskId,
  String attachmentId
) async {
  final dio = Dio();

  final response = await dio.delete(
    'http://192.168.88.209:3000/api/tasks/$taskId/attachments/$attachmentId',
    options: Options(
      headers: {'Authorization': 'Bearer $token'},
    ),
  );

  if (response.data['success']) {
    print('附件已删除');
  }
}
```

---

## 总结

文件上传功能已完全集成到 TodoList API 中，包括：

✅ **头像上传** - 用户可以上传和更新个人头像
✅ **任务附件上传** - 支持多文件上传（最多10个）
✅ **附件删除** - 删除任务附件并清理物理文件
✅ **静态文件服务** - 通过 `/uploads` 路径访问上传的文件
✅ **安全验证** - 文件类型、大小、身份验证
✅ **错误处理** - 完善的错误处理和文件清理机制

当前 API 端点总数: **51个**（47个 + 2个附件 + 2个已有的头像删除）

文件上传功能为应用提供了完整的文件管理能力！
