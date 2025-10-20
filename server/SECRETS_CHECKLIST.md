# 密钥安全检查清单

## 当前状态检查

### 已修复的安全问题
✅ `.env.example` 已移除真实密码
✅ `.gitignore` 已配置保护 `.env` 文件
✅ 添加了安全配置注释和示例

### 需要立即执行的操作

#### 1. 更换数据库密码（高优先级）
**当前风险**：数据库密码 `goodboy` 过于简单

**执行步骤**：
```sql
-- 连接到MySQL
mysql -u root -p

-- 更改root密码（如果必须使用root）
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_strong_password_here';

-- 推荐：创建专用应用用户
CREATE USER 'todolist_app'@'localhost' IDENTIFIED BY 'Strong@Pass123!@#$%';
GRANT SELECT, INSERT, UPDATE, DELETE ON todolist_cloud.* TO 'todolist_app'@'localhost';
FLUSH PRIVILEGES;
```

**更新配置**：
```bash
# 编辑 server/.env
DB_USER=todolist_app
DB_PASSWORD=Strong@Pass123!@#$%
```

#### 2. 生成强JWT密钥（高优先级）

**当前风险**：JWT密钥可预测

**生成新密钥**：
```bash
# Linux/Mac
openssl rand -base64 48

# Windows PowerShell
[Convert]::ToBase64String((1..48 | ForEach-Object { Get-Random -Maximum 256 }))

# Node.js
node -e "console.log(require('crypto').randomBytes(48).toString('base64'))"
```

**更新配置**：
```bash
# 编辑 server/.env
JWT_SECRET=<生成的随机密钥>
```

#### 3. 生成备份加密密钥（中优先级）

```bash
# 生成新的备份加密密钥
openssl rand -base64 32
```

**更新配置**：
```bash
# 编辑 server/.env
BACKUP_ENCRYPTION_KEY=<生成的随机密钥>
```

#### 4. 限制文件访问权限（中优先级）

**Linux/Mac**：
```bash
chmod 600 server/.env
chmod 700 server/uploads
```

**Windows PowerShell**（以管理员身份运行）：
```powershell
# 限制.env文件访问
icacls server\.env /inheritance:r /grant:r "$env:USERNAME:(R,W)"

# 限制uploads目录
icacls server\uploads /inheritance:r /grant:r "$env:USERNAME:(F)"
```

#### 5. 网络安全配置（中优先级）

**当前配置审查**：
- `HOST=192.168.88.209` - 内网IP已从.env.example移除 ✅
- `DB_HOST=192.168.88.207` - 内网IP已从.env.example移除 ✅

**生产环境建议**：
```bash
# 开发环境
HOST=localhost
DB_HOST=localhost

# 生产环境
HOST=0.0.0.0  # 或具体域名
DB_HOST=<内部数据库地址>  # 使用VPC内部地址
```

## 安全配置验证

### 自动化检查脚本

创建 `server/scripts/security-check.js`：
```javascript
const fs = require('fs');
const path = require('path');

console.log('🔒 环境变量安全检查\n');

const envPath = path.join(__dirname, '..', '.env');
const envExamplePath = path.join(__dirname, '..', '.env.example');

// 检查.env文件是否存在
if (!fs.existsSync(envPath)) {
  console.error('❌ .env 文件不存在');
  console.log('   执行: cp server/.env.example server/.env');
  process.exit(1);
}

// 检查.env.example是否包含敏感信息
const exampleContent = fs.readFileSync(envExamplePath, 'utf8');
const dangerousPatterns = [
  { pattern: /DB_PASSWORD=(?!your_|<|xxx)[a-zA-Z0-9]+/, message: '数据库密码' },
  { pattern: /JWT_SECRET=(?!your_|<|xxx)[a-zA-Z0-9-]+/, message: 'JWT密钥' },
  { pattern: /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/, message: '真实IP地址' },
];

let hasIssues = false;
dangerousPatterns.forEach(({ pattern, message }) => {
  if (pattern.test(exampleContent)) {
    console.error(`❌ .env.example 包含真实 ${message}`);
    hasIssues = true;
  }
});

// 检查.env配置强度
require('dotenv').config({ path: envPath });

const checks = [
  {
    name: 'JWT_SECRET长度',
    test: () => process.env.JWT_SECRET && process.env.JWT_SECRET.length >= 32,
    message: 'JWT密钥至少需要32字符'
  },
  {
    name: '数据库密码强度',
    test: () => {
      const pwd = process.env.DB_PASSWORD;
      return pwd && pwd.length >= 12 && /[A-Z]/.test(pwd) && /[a-z]/.test(pwd) && /[0-9]/.test(pwd);
    },
    message: '数据库密码需要至少12字符，包含大小写字母和数字'
  },
  {
    name: '避免使用root用户',
    test: () => process.env.DB_USER !== 'root',
    message: '生产环境不应使用root数据库用户'
  },
  {
    name: 'NODE_ENV配置',
    test: () => ['development', 'production', 'test'].includes(process.env.NODE_ENV),
    message: 'NODE_ENV应为development、production或test'
  }
];

checks.forEach(({ name, test, message }) => {
  if (test()) {
    console.log(`✅ ${name}`);
  } else {
    console.error(`❌ ${name}: ${message}`);
    hasIssues = true;
  }
});

if (!hasIssues) {
  console.log('\n✅ 所有安全检查通过！');
  process.exit(0);
} else {
  console.log('\n⚠️  发现安全问题，请立即修复！');
  process.exit(1);
}
```

**运行检查**：
```bash
node server/scripts/security-check.js
```

### 集成到CI/CD

在 `package.json` 添加：
```json
{
  "scripts": {
    "prestart": "node server/scripts/security-check.js",
    "security-check": "node server/scripts/security-check.js"
  }
}
```

## 密钥轮换计划

### 定期轮换时间表

| 密钥类型 | 轮换频率 | 影响范围 |
|---------|---------|---------|
| 数据库密码 | 每季度 | 需要重启服务 |
| JWT密钥 | 每半年 | 用户需重新登录 |
| 备份加密密钥 | 每年 | 需重新加密旧备份 |
| API密钥（如有） | 每季度 | 第三方服务 |

### 轮换流程

1. **准备阶段**
   - 生成新密钥
   - 通知团队成员
   - 准备回滚方案

2. **执行阶段**
   - 更新配置文件
   - 重启服务
   - 验证功能正常

3. **验证阶段**
   - 测试关键功能
   - 检查错误日志
   - 监控系统状态

4. **清理阶段**
   - 安全删除旧密钥
   - 更新文档
   - 记录轮换日志

## 应急响应流程

### 如果密钥已泄露

**立即执行（0-1小时）**：
1. 轮换所有泄露的密钥
2. 检查系统日志，寻找异常访问
3. 通知安全团队

**短期措施（1-24小时）**：
1. 强制所有用户重新登录（如JWT泄露）
2. 审计数据库访问记录
3. 检查数据完整性

**长期措施（1-7天）**：
1. 实施额外监控
2. 审查安全策略
3. 进行安全培训
4. 更新安全文档

## 合规清单

### 数据保护要求
- [ ] 敏感数据加密存储
- [ ] 传输层使用HTTPS/TLS
- [ ] 定期备份并加密
- [ ] 访问日志完整

### 访问控制
- [ ] 最小权限原则
- [ ] 强密码策略
- [ ] 多因素认证（如适用）
- [ ] 定期权限审计

### 审计和监控
- [ ] 登录尝试日志
- [ ] 数据访问日志
- [ ] 系统变更日志
- [ ] 异常行为告警

---

**检查日期**: 2025-10-20
**下次检查**: 2026-01-20
**负责人**: DevSecOps团队
