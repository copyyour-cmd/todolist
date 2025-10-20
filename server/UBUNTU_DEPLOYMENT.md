# 🐧 Ubuntu服务器部署指南

## 📋 系统要求

- Ubuntu 20.04 LTS 或更高版本
- 至少 1GB RAM
- 至少 10GB 磁盘空间
- root 或 sudo 权限

---

## 🚀 完整部署步骤

### 第1步：安装Node.js

```bash
# 更新系统包
sudo apt update && sudo apt upgrade -y

# 安装Node.js 18.x (推荐LTS版本)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 验证安装
node --version  # 应显示 v18.x.x
npm --version   # 应显示 9.x.x
```

### 第2步：安装MySQL

```bash
# 安装MySQL服务器
sudo apt install -y mysql-server

# 启动MySQL服务
sudo systemctl start mysql
sudo systemctl enable mysql

# 运行安全配置
sudo mysql_secure_installation
# 建议设置：
# - root密码: goodboy (或你自己的密码)
# - 移除匿名用户: Y
# - 禁止root远程登录: N (如果需要远程管理选N)
# - 移除测试数据库: Y
# - 重新加载权限表: Y

# 配置MySQL允许远程连接（如果需要）
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# 找到 bind-address = 127.0.0.1
# 修改为 bind-address = 0.0.0.0
# 保存并退出 (Ctrl+X, Y, Enter)

# 重启MySQL
sudo systemctl restart mysql

# 创建数据库用户（可选，更安全）
sudo mysql -u root -p
```

```sql
-- 在MySQL命令行中执行
CREATE USER 'todolist'@'%' IDENTIFIED BY 'your_strong_password';
GRANT ALL PRIVILEGES ON todolist_cloud.* TO 'todolist'@'%';
FLUSH PRIVILEGES;
EXIT;
```

### 第3步：上传服务器代码

#### 方式1：使用SCP（从Windows）
```powershell
# 在Windows上执行
scp -r E:\todolist\server username@your-ubuntu-ip:/home/username/
```

#### 方式2：使用Git
```bash
# 在Ubuntu服务器上
cd /home/username
git clone https://github.com/your-repo/todolist.git
cd todolist/server
```

#### 方式3：手动上传
使用FTP工具（如FileZilla）上传 `server` 文件夹到Ubuntu服务器

### 第4步：安装依赖

```bash
# 进入项目目录
cd /home/username/server  # 根据实际路径调整

# 安装npm依赖
npm install

# 验证package.json存在
ls -la package.json
```

### 第5步：配置环境变量

```bash
# 创建.env文件
nano .env
```

输入以下内容：
```env
# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=goodboy
DB_NAME=todolist_cloud

# JWT 配置（生产环境务必修改为强随机密钥！）
JWT_SECRET=your_super_secure_random_secret_key_change_me_in_production_2024
JWT_EXPIRES_IN=7d
REFRESH_TOKEN_EXPIRES_IN=30d

# 服务器配置
PORT=3000
HOST=0.0.0.0
NODE_ENV=production

# 文件上传配置
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=10485760
```

保存并退出 (Ctrl+X, Y, Enter)

### 第6步：初始化数据库

```bash
# 运行数据库初始化脚本
node scripts/init-database.js

# 运行云同步表初始化
node scripts/init-cloud-sync-tables.js

# 验证数据库
mysql -u root -pgoodboy
```

```sql
USE todolist_cloud;
SHOW TABLES;
-- 应该看到: users, user_sessions, user_tasks, user_lists, user_tags, 
--          user_ideas, user_settings, cloud_sync_records, cloud_snapshots等
EXIT;
```

### 第7步：配置防火墙

```bash
# 安装UFW（如果未安装）
sudo apt install -y ufw

# 允许SSH（重要！避免被锁在外面）
sudo ufw allow 22/tcp

# 允许API端口
sudo ufw allow 3000/tcp

# 允许MySQL远程连接（可选）
sudo ufw allow 3306/tcp

# 启用防火墙
sudo ufw enable

# 查看状态
sudo ufw status
```

### 第8步：使用PM2管理进程（推荐）

```bash
# 安装PM2
sudo npm install -g pm2

# 启动服务器
pm2 start server.js --name todolist-api

# 设置开机自启动
pm2 startup
pm2 save

# 查看服务状态
pm2 status

# 查看日志
pm2 logs todolist-api

# 其他PM2命令
pm2 restart todolist-api  # 重启
pm2 stop todolist-api     # 停止
pm2 delete todolist-api   # 删除
```

### 第9步：配置Nginx反向代理（可选，用于HTTPS）

```bash
# 安装Nginx
sudo apt install -y nginx

# 创建配置文件
sudo nano /etc/nginx/sites-available/todolist-api
```

输入以下配置：
```nginx
server {
    listen 80;
    server_name your-domain.com;  # 或服务器IP

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# 启用配置
sudo ln -s /etc/nginx/sites-available/todolist-api /etc/nginx/sites-enabled/

# 测试配置
sudo nginx -t

# 重启Nginx
sudo systemctl restart nginx

# 设置开机自启动
sudo systemctl enable nginx
```

### 第10步：配置SSL证书（可选，用于HTTPS）

```bash
# 安装Certbot
sudo apt install -y certbot python3-certbot-nginx

# 获取SSL证书
sudo certbot --nginx -d your-domain.com

# 证书会自动续期
```

---

## 📱 更新Flutter客户端配置

在 `lib/src/core/config/cloud_config.dart` 中修改：

```dart
class CloudConfig {
  // 修改为Ubuntu服务器的IP或域名
  static const String baseUrl = 'http://your-ubuntu-ip:3000';
  // 或使用域名
  // static const String baseUrl = 'https://your-domain.com';
  
  // ... 其他配置保持不变
}
```

重新编译Flutter应用：
```bash
flutter build apk --release
```

---

## 🧪 测试部署

### 在Ubuntu服务器上测试

```bash
# 健康检查
curl http://localhost:3000/health

# 测试注册API
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"test123456"}'

# 测试登录API
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"test123456"}'
```

### 从外部网络测试

```bash
# 健康检查（替换为你的服务器IP）
curl http://your-ubuntu-ip:3000/health

# 从手机测试
# 打开浏览器访问: http://your-ubuntu-ip:3000/health
```

---

## 📁 目录结构建议

```
/home/username/
├── todolist/
│   └── server/
│       ├── config/
│       ├── controllers/
│       ├── database/
│       ├── middleware/
│       ├── routes/
│       ├── scripts/
│       ├── uploads/
│       ├── .env           # 环境变量
│       ├── server.js      # 主程序
│       └── package.json
```

---

## 🔧 常用维护命令

### 查看服务状态
```bash
pm2 status
pm2 logs todolist-api
pm2 monit
```

### 重启服务
```bash
pm2 restart todolist-api
```

### 更新代码
```bash
cd /home/username/server
git pull  # 如果使用Git
npm install  # 更新依赖
pm2 restart todolist-api
```

### 数据库备份
```bash
# 备份数据库
mysqldump -u root -pgoodboy todolist_cloud > backup_$(date +%Y%m%d).sql

# 恢复数据库
mysql -u root -pgoodboy todolist_cloud < backup_20241006.sql
```

### 查看日志
```bash
# PM2日志
pm2 logs todolist-api --lines 100

# Nginx日志
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# 系统日志
sudo journalctl -u nginx -f
```

---

## 🔒 安全加固建议

### 1. 修改默认密码
```bash
# MySQL root密码
sudo mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_strong_password';
```

### 2. 创建专用数据库用户
```sql
CREATE USER 'todolist_app'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON todolist_cloud.* TO 'todolist_app'@'localhost';
FLUSH PRIVILEGES;
```

更新 `.env`:
```env
DB_USER=todolist_app
DB_PASSWORD=strong_password
```

### 3. 修改JWT密钥
```bash
# 生成随机密钥
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

复制生成的密钥到 `.env` 的 `JWT_SECRET`

### 4. 配置fail2ban防暴力破解
```bash
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 5. 启用HTTPS
使用前面的Certbot配置SSL证书

---

## 📊 监控和性能

### 安装监控工具
```bash
# 安装htop
sudo apt install -y htop

# 安装netdata（实时性能监控）
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
# 访问 http://your-ip:19999 查看监控面板
```

### PM2监控
```bash
# PM2 Plus监控（可选）
pm2 link [secret] [public]  # 在https://pm2.io注册获取密钥
```

---

## 🔄 自动化部署脚本

创建 `deploy.sh`:

```bash
#!/bin/bash

echo "═══════════════════════════════════════"
echo "TodoList API 部署脚本"
echo "═══════════════════════════════════════"

# 进入项目目录
cd /home/username/server

# 拉取最新代码（如果使用Git）
echo "⏳ 更新代码..."
git pull

# 安装依赖
echo "⏳ 安装依赖..."
npm install

# 初始化/更新数据库
echo "⏳ 更新数据库..."
node scripts/init-database.js
node scripts/init-cloud-sync-tables.js

# 重启服务
echo "⏳ 重启服务..."
pm2 restart todolist-api

echo "✅ 部署完成！"
pm2 status
```

```bash
# 赋予执行权限
chmod +x deploy.sh

# 运行部署
./deploy.sh
```

---

## 🌐 获取服务器IP地址

```bash
# 查看内网IP
hostname -I

# 查看外网IP
curl ifconfig.me

# 查看所有网络接口
ip addr show
```

---

## 📱 Flutter应用配置更新

### 步骤1：修改API地址

编辑 `lib/src/core/config/cloud_config.dart`:

```dart
class CloudConfig {
  // 开发环境 - 使用本机IP
  // static const String baseUrl = 'http://192.168.88.209:3000';
  
  // 生产环境 - 使用Ubuntu服务器IP或域名
  static const String baseUrl = 'http://your-ubuntu-server-ip:3000';
  // 或使用域名+HTTPS
  // static const String baseUrl = 'https://api.yourdomain.com';
  
  // ... 其他配置
}
```

### 步骤2：重新编译APK

```bash
cd E:\todolist
flutter build apk --release --no-tree-shake-icons
flutter install
```

---

## 🔍 故障排查

### 服务器无法启动

```bash
# 查看PM2日志
pm2 logs todolist-api --err

# 查看端口占用
sudo netstat -tulpn | grep 3000

# 杀死占用端口的进程
sudo kill -9 [PID]
```

### 数据库连接失败

```bash
# 检查MySQL服务状态
sudo systemctl status mysql

# 重启MySQL
sudo systemctl restart mysql

# 测试数据库连接
mysql -u root -pgoodboy -e "SHOW DATABASES;"
```

### 防火墙问题

```bash
# 检查防火墙状态
sudo ufw status

# 临时关闭防火墙测试
sudo ufw disable

# 重新开启
sudo ufw enable
```

### 查看系统日志

```bash
# 查看系统日志
sudo journalctl -xe

# 查看特定服务日志
sudo journalctl -u mysql -f
```

---

## 📦 完整迁移检查清单

- [ ] Ubuntu系统已更新
- [ ] Node.js已安装（v18+）
- [ ] MySQL已安装并运行
- [ ] 项目代码已上传
- [ ] npm依赖已安装
- [ ] .env文件已配置
- [ ] 数据库已初始化
- [ ] 防火墙已配置
- [ ] PM2已安装并配置
- [ ] 服务器已启动
- [ ] 健康检查通过
- [ ] API测试通过
- [ ] Flutter客户端配置已更新
- [ ] APK已重新编译
- [ ] 手机能连接服务器

---

## 🎯 快速启动命令总结

```bash
# 一键部署（创建后使用）
./deploy.sh

# 手动启动
cd /home/username/server
pm2 start server.js --name todolist-api

# 停止服务
pm2 stop todolist-api

# 查看状态
pm2 status
pm2 logs todolist-api

# 数据库备份
mysqldump -u root -pgoodboy todolist_cloud > backup.sql

# 重启所有服务
pm2 restart all
sudo systemctl restart mysql
sudo systemctl restart nginx
```

---

## 💡 推荐配置

### 生产环境最佳实践

1. **使用专用数据库用户**（不用root）
2. **启用HTTPS** （使用Let's Encrypt免费证书）
3. **配置Nginx反向代理**
4. **启用日志轮转**
5. **设置自动备份计划任务**
6. **配置监控告警**
7. **使用强JWT密钥**

### 性能优化

```javascript
// 在server.js中添加
app.use(compression());  // 启用gzip压缩

// MySQL连接池配置
connectionLimit: 100,     // 增加连接池
```

---

## 📞 需要帮助？

如果遇到问题，请检查：
1. 服务器日志: `pm2 logs todolist-api`
2. MySQL日志: `sudo tail -f /var/log/mysql/error.log`
3. 防火墙规则: `sudo ufw status verbose`
4. 网络连接: `ping your-ubuntu-server-ip`

---

## 🎉 部署完成验证

### 在Ubuntu服务器上
```bash
curl http://localhost:3000/health
# 应返回: {"status":"ok",...}
```

### 从手机上
```
浏览器访问: http://your-ubuntu-ip:3000/health
应该能看到JSON响应
```

### 在TodoList应用中
```
1. 设置 → 云服务 → 云同步登录
2. 注册/登录
3. 测试上传/下载功能
```

成功！🎊

