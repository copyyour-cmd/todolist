# 安全配置指南

## 环境变量安全配置

### 快速设置

1. **复制示例文件**
   ```bash
   cp server/.env.example server/.env
   ```

2. **生成强密钥**
   ```bash
   # JWT密钥（Linux/Mac）
   openssl rand -base64 32

   # 备份加密密钥
   openssl rand -base64 32

   # Windows PowerShell替代方案
   [Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))
   ```

3. **配置真实环境变量**
   编辑 `server/.env` 文件，替换所有占位符为真实值

### 必须修改的配置项

#### 高危配置（必须修改）
- `DB_PASSWORD`: 使用强密码（至少16字符，包含大小写、数字、特殊字符）
- `JWT_SECRET`: 最少32字符的随机密钥
- `BACKUP_ENCRYPTION_KEY`: 最少32字符的随机密钥

#### 重要配置（根据环境修改）
- `DB_HOST`: 生产环境使用实际数据库地址
- `DB_USER`: 使用专用应用账户，避免使用root
- `HOST`: 生产环境配置为实际服务器IP或域名

### 数据库安全最佳实践

1. **创建专用数据库用户**
   ```sql
   -- 创建应用专用用户
   CREATE USER 'todolist_app'@'localhost' IDENTIFIED BY 'your_strong_password';

   -- 授予最小权限
   GRANT SELECT, INSERT, UPDATE, DELETE ON todolist_cloud.* TO 'todolist_app'@'localhost';

   -- 刷新权限
   FLUSH PRIVILEGES;
   ```

2. **避免使用root账户**
   - 生产环境禁止使用root
   - 使用最小权限原则

3. **密码强度要求**
   - 最少16字符
   - 包含大小写字母
   - 包含数字和特殊字符
   - 避免使用字典词汇

## 安全检查清单

### 部署前检查

- [ ] `.env` 文件未提交到Git
- [ ] `.env.example` 不包含真实凭证
- [ ] `.gitignore` 包含 `.env` 配置
- [ ] 数据库密码符合强度要求
- [ ] JWT密钥至少32字符
- [ ] 使用专用数据库用户（非root）
- [ ] 生产环境 `NODE_ENV=production`
- [ ] 所有密钥已更换为生产密钥

### 定期安全审计

- [ ] 每季度轮换数据库密码
- [ ] 每季度轮换JWT密钥（需要用户重新登录）
- [ ] 检查异常登录活动
- [ ] 审计数据库访问日志
- [ ] 更新依赖包到最新安全版本

## 文件权限配置

### Linux/Mac
```bash
# 限制.env文件权限（仅所有者可读写）
chmod 600 server/.env

# 确保.env.example可读（用于团队参考）
chmod 644 server/.env.example
```

### Windows
```powershell
# 限制.env文件访问
icacls server\.env /inheritance:r /grant:r "%USERNAME%:(R,W)"
```

## Git历史清理（如已提交敏感信息）

**警告**：以下操作会重写Git历史，需要团队协调

### 方案1：使用git-filter-repo（推荐）
```bash
# 安装git-filter-repo
pip install git-filter-repo

# 移除敏感文件
git filter-repo --path server/.env --invert-paths

# 强制推送（谨慎使用）
git push origin --force --all
```

### 方案2：使用BFG Repo-Cleaner
```bash
# 下载BFG: https://rtyley.github.io/bfg-repo-cleaner/

# 删除文件
java -jar bfg.jar --delete-files .env

# 清理
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 强制推送
git push origin --force --all
```

### 泄露后的应急响应

1. **立即轮换所有凭证**
   - 更改数据库密码
   - 生成新的JWT密钥
   - 更新所有API密钥

2. **检查异常访问**
   - 审计数据库访问日志
   - 检查异常登录活动
   - 监控系统资源使用

3. **通知相关方**
   - 通知团队成员
   - 必要时通知用户
   - 记录事件日志

## 环境隔离

### 开发环境
```bash
# server/.env.development
DB_HOST=localhost
DB_USER=dev_user
NODE_ENV=development
```

### 生产环境
```bash
# server/.env.production（永不提交）
DB_HOST=prod-db.example.com
DB_USER=prod_user
NODE_ENV=production
```

### 使用环境变量
```bash
# 加载特定环境
NODE_ENV=production node server.js
```

## 密钥管理建议

### 小型项目
- 使用 `.env` 文件（本地开发）
- 生产环境使用环境变量或密钥管理服务

### 企业级项目
- HashiCorp Vault
- AWS Secrets Manager
- Azure Key Vault
- Google Cloud Secret Manager

## 监控和告警

### 建议监控项
- 失败的数据库连接尝试
- 异常的JWT验证失败
- 文件上传异常活动
- 数据库查询性能异常

### 日志安全
```javascript
// 错误示例 - 不要记录敏感信息
console.log('DB Password:', process.env.DB_PASSWORD); // 危险！

// 正确示例 - 记录脱敏信息
console.log('Database connection status: connected');
```

## 合规要求

### GDPR/数据保护
- 加密存储敏感用户数据
- 定期备份并加密
- 实施数据保留政策

### 访问控制
- 最小权限原则
- 定期审计访问日志
- 使用强认证机制

## 联系方式

如发现安全问题，请立即联系：
- 安全团队邮箱：security@example.com
- 紧急热线：+86-xxx-xxxx-xxxx

---

**最后更新**: 2025-10-20
**文档版本**: 1.0
