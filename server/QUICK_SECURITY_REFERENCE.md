# 快速安全参考卡

## 立即执行（5分钟安全加固）

### 1. 生成强密钥

```bash
# 生成JWT密钥（Windows PowerShell）
[Convert]::ToBase64String((1..48 | ForEach-Object { Get-Random -Maximum 256 }))

# 生成备份加密密钥
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))
```

### 2. 创建数据库专用用户

```sql
-- 登录MySQL
mysql -u root -p

-- 创建应用用户
CREATE USER 'todolist_app'@'localhost' IDENTIFIED BY 'Strong@Pass123!Change#Me';

-- 授予最小权限
GRANT SELECT, INSERT, UPDATE, DELETE ON todolist_cloud.* TO 'todolist_app'@'localhost';

-- 刷新权限
FLUSH PRIVILEGES;

-- 退出
EXIT;
```

### 3. 更新 .env 文件

编辑 `server/.env`：

```bash
# 数据库配置 - 使用新用户
DB_USER=todolist_app
DB_PASSWORD=Strong@Pass123!Change#Me

# JWT密钥 - 使用生成的密钥
JWT_SECRET=<步骤1生成的密钥>

# 备份加密密钥
BACKUP_ENCRYPTION_KEY=<步骤1生成的密钥>
```

### 4. 运行安全检查

```bash
cd E:\todolist
node server/scripts/security-check.js
```

## 日常安全检查表

### 每次部署前
- [ ] 运行 `node server/scripts/security-check.js`
- [ ] 确认 `.env` 未添加到Git
- [ ] 验证环境变量配置正确

### 每周
- [ ] 检查应用日志异常
- [ ] 审查数据库访问记录
- [ ] 更新依赖包

### 每季度
- [ ] 轮换数据库密码
- [ ] 审计用户权限
- [ ] 安全培训回顾

### 每年
- [ ] 轮换所有密钥
- [ ] 安全审计
- [ ] 渗透测试

## 常用命令速查

### 文件权限（Linux/Mac）
```bash
# 限制.env文件权限
chmod 600 server/.env

# 限制uploads目录
chmod 700 server/uploads
```

### Git安全
```bash
# 检查是否包含敏感文件
git status --ignored

# 验证.gitignore生效
git check-ignore server/.env

# 搜索敏感关键词
git log -S "password" --all
```

### 数据库安全
```bash
# 查看当前用户
mysql -u root -p -e "SELECT user, host FROM mysql.user;"

# 查看用户权限
mysql -u root -p -e "SHOW GRANTS FOR 'todolist_app'@'localhost';"

# 修改用户密码
mysql -u root -p -e "ALTER USER 'todolist_app'@'localhost' IDENTIFIED BY 'new_password';"
```

## 密码强度要求

### 最低要求
- 长度：至少12字符
- 包含：大写字母
- 包含：小写字母
- 包含：数字
- 避免：常见词汇（password、admin、123456等）

### 推荐强度
- 长度：16+字符
- 包含：特殊字符 (!@#$%^&*等)
- 使用：密码管理器生成
- 不包含：个人信息、字典词汇

## 应急响应流程

### 如果怀疑密钥泄露

**立即执行**：
```bash
# 1. 停止服务（如需要）
# pm2 stop all

# 2. 生成新密钥
[Convert]::ToBase64String((1..48 | ForEach-Object { Get-Random -Maximum 256 }))

# 3. 更新.env文件
# 编辑 server/.env

# 4. 重启服务
# pm2 restart all

# 5. 检查日志
# tail -f logs/error.log
```

**后续行动**：
1. 审计访问日志
2. 通知团队
3. 更新文档
4. 事后分析

## 监控指标

### 需要关注的异常
- 短时间内大量失败的登录尝试
- 异常时间段的数据库访问
- 大量数据导出操作
- 权限提升尝试
- 异常文件上传

### 设置告警
```javascript
// 示例：登录失败次数监控
const MAX_FAILED_ATTEMPTS = 5;
const TIME_WINDOW = 15 * 60 * 1000; // 15分钟

if (failedAttempts > MAX_FAILED_ATTEMPTS) {
  // 发送告警
  sendSecurityAlert({
    type: 'suspicious_login',
    ip: req.ip,
    timestamp: new Date()
  });
}
```

## 配置文件模板

### 开发环境 (.env.development)
```bash
DB_HOST=localhost
DB_PORT=3306
DB_USER=dev_user
DB_PASSWORD=dev_password
DB_NAME=todolist_dev

JWT_SECRET=dev-secret-key-not-for-production
NODE_ENV=development
```

### 生产环境 (.env.production)
```bash
DB_HOST=prod-db.internal
DB_PORT=3306
DB_USER=todolist_prod_app
DB_PASSWORD=<strong-password>
DB_NAME=todolist_prod

JWT_SECRET=<strong-random-key>
NODE_ENV=production
```

## 依赖安全

### 检查已知漏洞
```bash
# npm审计
npm audit

# 修复可自动修复的漏洞
npm audit fix

# 查看详细报告
npm audit --json
```

### 定期更新
```bash
# 检查过时的包
npm outdated

# 更新所有包到最新版本（谨慎使用）
# npm update

# 更新特定包
npm install package-name@latest
```

## 备份策略

### 自动化备份
```bash
# 每日备份脚本示例
mysqldump -u todolist_app -p todolist_cloud | \
  openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:$BACKUP_ENCRYPTION_KEY > \
  backup-$(date +%Y%m%d).sql.enc
```

### 备份验证
- 定期测试恢复流程
- 验证备份完整性
- 存储在多个位置
- 加密敏感备份

## 合规清单

### GDPR/数据保护
- [ ] 用户数据加密存储
- [ ] 实施数据保留策略
- [ ] 提供数据导出功能
- [ ] 实施数据删除机制

### 访问控制
- [ ] 最小权限原则
- [ ] 定期权限审计
- [ ] 多因素认证（如适用）
- [ ] 会话超时设置

### 日志和审计
- [ ] 记录所有访问
- [ ] 保护日志完整性
- [ ] 定期审查日志
- [ ] 保留审计轨迹

## 工具推荐

### 密钥生成
- **OpenSSL**: `openssl rand -base64 32`
- **密码管理器**: 1Password, Bitwarden, KeePass
- **在线工具**: random.org (仅用于测试，生产环境禁用)

### 安全扫描
- **npm audit**: 内置依赖检查
- **Snyk**: 持续安全监控
- **OWASP Dependency-Check**: 依赖漏洞检查

### 监控和日志
- **Winston**: Node.js日志库
- **Morgan**: HTTP请求日志
- **PM2**: 进程管理和监控

## 联系方式

### 安全问题报告
- 邮箱：security@example.com
- 紧急热线：+86-xxx-xxxx-xxxx

### 资源链接
- 详细安全指南：`SECURITY.md`
- 密钥检查清单：`server/SECRETS_CHECKLIST.md`
- Git历史清理：`GIT_HISTORY_CLEANUP.md`

---

**打印此页作为快速参考**

**最后更新**: 2025-10-20
