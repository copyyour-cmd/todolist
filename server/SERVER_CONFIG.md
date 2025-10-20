# 🌐 TodoList 云服务配置

## 📍 服务器地址

```
IP地址: 192.168.88.209
端口: 3000
完整地址: http://192.168.88.209:3000
```

## 🔐 数据库配置

```
主机: localhost
端口: 3306
用户: root
密码: goodboy
数据库: todolist_cloud
```

## 🚀 启动服务器

### Windows
```bash
cd E:\todolist\server
npm start
```

或使用批处理文件：
```bash
start-server.bat
```

### 验证服务状态
```bash
curl http://192.168.88.209:3000/health
```

## 📱 Flutter 客户端配置

在 Flutter 应用中使用以下地址连接服务器：

```dart
const String API_BASE_URL = 'http://192.168.88.209:3000';
```

## 🔑 认证 API 端点

### 用户注册
```
POST http://192.168.88.209:3000/api/auth/register

Body:
{
  "username": "yourname",
  "email": "your@email.com",
  "password": "yourpassword",
  "nickname": "昵称"
}

Response:
{
  "success": true,
  "message": "注册成功",
  "data": {
    "user": {...},
    "token": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

### 用户登录
```
POST http://192.168.88.209:3000/api/auth/login

Body:
{
  "username": "yourname",
  "password": "yourpassword",
  "deviceType": "android",
  "deviceId": "device-uuid",
  "deviceName": "PKH110"
}

Response:
{
  "success": true,
  "message": "登录成功",
  "data": {
    "user": {...},
    "token": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

### 获取当前用户信息
```
GET http://192.168.88.209:3000/api/auth/me

Headers:
Authorization: Bearer {token}

Response:
{
  "success": true,
  "data": {
    "id": 1,
    "username": "yourname",
    "email": "your@email.com",
    "nickname": "昵称",
    ...
  }
}
```

### 退出登录
```
POST http://192.168.88.209:3000/api/auth/logout

Headers:
Authorization: Bearer {token}

Response:
{
  "success": true,
  "message": "退出登录成功"
}
```

### 刷新Token
```
POST http://192.168.88.209:3000/api/auth/refresh-token

Body:
{
  "refreshToken": "eyJhbGc..."
}

Response:
{
  "success": true,
  "message": "令牌刷新成功",
  "data": {
    "token": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

## 🔧 测试命令

### 测试注册
```bash
curl -X POST http://192.168.88.209:3000/api/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"email\":\"test@example.com\",\"password\":\"test123456\"}"
```

### 测试登录
```bash
curl -X POST http://192.168.88.209:3000/api/auth/login ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"password\":\"test123456\"}"
```

## 📝 注意事项

1. **局域网访问**：确保手机和服务器在同一WiFi网络
2. **防火墙**：确保端口3000已开放
3. **MySQL服务**：确保MySQL服务正在运行
4. **初始化数据库**：首次使用需运行 `node scripts/init-database.js`

