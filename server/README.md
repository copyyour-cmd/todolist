# TodoList 云服务后端

基于 Node.js + Express + MySQL 的 TodoList 云服务后端，提供用户认证、任务云同步等功能。

## 🚀 快速开始

### 1. 环境要求

- Node.js >= 16.x
- MySQL >= 5.7
- npm 或 yarn

### 2. 安装依赖

```bash
cd server
npm install
```

### 3. 配置环境变量

复制 `.env.example` 为 `.env` 并修改配置：

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

### 4. 初始化数据库

```bash
npm run init-db
```

这将创建以下数据库表：
- `users` - 用户表
- `user_sessions` - 用户会话表
- `user_tasks` - 用户任务表（云同步）
- `sync_logs` - 同步日志表
- `password_resets` - 密码重置表

### 5. 启动服务器

**开发模式**（支持热重载）：
```bash
npm run dev
```

**生产模式**：
```bash
npm start
```

服务器将在 `http://192.168.88.209:3000` 启动

## 📡 API 端点

### 认证相关

| 方法 | 端点 | 描述 | 认证 |
|------|------|------|------|
| POST | `/api/auth/register` | 用户注册 | ❌ |
| POST | `/api/auth/login` | 用户登录 | ❌ |
| POST | `/api/auth/refresh-token` | 刷新令牌 | ❌ |
| GET | `/api/auth/me` | 获取当前用户信息 | ✅ |
| POST | `/api/auth/logout` | 退出登录 | ✅ |

### 健康检查

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/health` | 服务健康检查 |

详细 API 文档请查看 [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)

## 🗄️ 数据库设计

### users 表
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nickname VARCHAR(50),
    avatar_url VARCHAR(255),
    phone VARCHAR(20),
    status TINYINT DEFAULT 1,
    last_login_at DATETIME,
    last_login_ip VARCHAR(45),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### user_sessions 表
```sql
CREATE TABLE user_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    token VARCHAR(500) NOT NULL UNIQUE,
    refresh_token VARCHAR(500),
    device_id VARCHAR(100),
    device_name VARCHAR(100),
    device_type VARCHAR(20),
    ip_address VARCHAR(45),
    user_agent TEXT,
    expires_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_used_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

完整数据库结构请查看 [database/schema.sql](./database/schema.sql)

## 🔐 认证机制

### JWT Token 流程

1. **用户注册/登录**：获取 `token` 和 `refreshToken`
2. **访问受保护资源**：请求头添加 `Authorization: Bearer {token}`
3. **Token 刷新**：当 token 过期时，使用 `refreshToken` 获取新 token
4. **退出登录**：清除服务器端会话

### Token 配置

- **Access Token 有效期**：7天
- **Refresh Token 有效期**：30天
- **加密算法**：HS256
- **密码加密**：BCrypt (10轮加盐)

## 🧪 测试

### 使用 curl 测试

**1. 注册用户**
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

**2. 用户登录**
```bash
curl -X POST http://192.168.88.209:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'
```

**3. 获取用户信息**
```bash
curl -X GET http://192.168.88.209:3000/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 使用测试脚本

```bash
chmod +x test-api.sh
./test-api.sh
```

## 📂 项目结构

```
server/
├── config/              # 配置文件
│   └── database.js      # 数据库连接配置
├── controllers/         # 控制器
│   └── authController.js
├── middleware/          # 中间件
│   └── authMiddleware.js
├── routes/             # 路由
│   └── authRoutes.js
├── database/           # 数据库相关
│   └── schema.sql      # 数据库结构
├── scripts/            # 脚本
│   └── init-db.js      # 数据库初始化
├── .env                # 环境变量（不提交到Git）
├── .env.example        # 环境变量示例
├── package.json        # 项目配置
├── server.js           # 服务器入口
└── README.md           # 项目说明
```

## 🔧 技术栈

- **运行时**: Node.js
- **框架**: Express.js
- **数据库**: MySQL 8.0
- **认证**: JWT (jsonwebtoken)
- **密码加密**: BCrypt
- **HTTP 客户端**: Axios (用于测试)
- **日志**: Morgan
- **安全**: Helmet
- **CORS**: cors

## 📦 依赖包

### 生产依赖
```json
{
  "express": "^4.18.2",
  "mysql2": "^3.6.5",
  "bcryptjs": "^2.4.3",
  "jsonwebtoken": "^9.0.2",
  "dotenv": "^16.3.1",
  "cors": "^2.8.5",
  "express-validator": "^7.0.1",
  "morgan": "^1.10.0",
  "helmet": "^7.1.0"
}
```

### 开发依赖
```json
{
  "nodemon": "^3.0.2"
}
```

## 🛡️ 安全特性

- ✅ 密码 BCrypt 加密（10轮加盐）
- ✅ JWT Token 认证
- ✅ Helmet 安全头
- ✅ CORS 跨域保护
- ✅ SQL 注入防护（参数化查询）
- ✅ 会话过期管理
- ✅ IP 地址记录
- ✅ 设备信息跟踪

## 🚧 待开发功能

- [ ] 密码重置功能
- [ ] 邮箱验证
- [ ] 手机号绑定
- [ ] 第三方登录（微信、QQ）
- [ ] 用户资料更新
- [ ] 头像上传
- [ ] 任务云同步 CRUD
- [ ] 数据备份恢复
- [ ] 管理后台

## 📝 开发规范

### Git 提交规范
```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试
chore: 构建/工具链
```

### API 响应格式
```json
{
  "success": true/false,
  "message": "提示信息",
  "data": {},
  "error": "错误信息"
}
```

## 🐛 问题排查

### 数据库连接失败
1. 检查 MySQL 服务是否启动
2. 确认 `.env` 中的数据库配置正确
3. 确保数据库已创建：`npm run init-db`

### Token 验证失败
1. 检查 JWT_SECRET 是否正确
2. 确认 token 未过期
3. 检查请求头格式：`Authorization: Bearer {token}`

### 端口被占用
```bash
# Windows
netstat -ano | findstr :3000
taskkill /F /PID <PID>

# Linux/Mac
lsof -i :3000
kill -9 <PID>
```

## 📄 许可证

ISC

## 👥 贡献

欢迎提交 Issue 和 Pull Request！

## 📞 联系方式

如有问题，请提交 Issue 或联系开发者。
