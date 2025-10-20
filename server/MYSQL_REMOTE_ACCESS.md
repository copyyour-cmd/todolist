# MySQL 远程访问配置指南

## 当前配置状态

### ✅ 已完成配置
1. **用户权限**: root用户已允许从任何主机访问 (`%`)
   ```sql
   SELECT host, user FROM mysql.user WHERE user='root';
   -- 结果显示: % 和 localhost
   ```

2. **绑定地址**: MySQL已绑定到所有网络接口
   ```sql
   SHOW VARIABLES LIKE 'bind_address';
   -- 结果: 0.0.0.0
   ```

3. **权限已刷新**: `FLUSH PRIVILEGES` 已执行

### ⚠️ 需要手动完成

**配置防火墙规则**（需要管理员权限）

#### 方法1: 使用PowerShell脚本（推荐）
```powershell
# 以管理员身份运行PowerShell，然后执行：
cd E:\todolist\server
.\setup-mysql-firewall.ps1
```

#### 方法2: 使用命令行
```cmd
# 以管理员身份运行CMD，然后执行：
netsh advfirewall firewall add rule name="MySQL Port 3306" dir=in action=allow protocol=TCP localport=3306
```

#### 方法3: 使用图形界面
1. 打开"Windows Defender 防火墙"
2. 点击"高级设置"
3. 点击"入站规则" -> "新建规则"
4. 选择"端口" -> 下一步
5. 选择"TCP"，输入端口号 `3306` -> 下一步
6. 选择"允许连接" -> 下一步
7. 勾选所有配置文件（域、专用、公用）-> 下一步
8. 输入名称"MySQL Port 3306" -> 完成

## 测试远程连接

### 从远程主机测试
```bash
# 测试端口连通性
telnet 192.168.88.209 3306

# 或使用PowerShell
Test-NetConnection -ComputerName 192.168.88.209 -Port 3306

# 使用MySQL客户端连接
mysql -h 192.168.88.209 -u root -pgoodboy -e "SHOW DATABASES;"
```

### 从本机测试（模拟远程）
```bash
mysql -h 192.168.88.209 -u root -pgoodboy -e "SELECT 'Remote access works!' AS status;"
```

## 安全建议

### 🔒 生产环境配置

1. **创建专用远程用户**（不要直接使用root）
   ```sql
   -- 创建只能从特定IP访问的用户
   CREATE USER 'todolist_user'@'192.168.88.%' IDENTIFIED BY 'strong_password_here';

   -- 只授予todolist_cloud数据库权限
   GRANT ALL PRIVILEGES ON todolist_cloud.* TO 'todolist_user'@'192.168.88.%';
   FLUSH PRIVILEGES;
   ```

2. **限制root远程访问**
   ```sql
   -- 删除root的远程访问权限
   DELETE FROM mysql.user WHERE user='root' AND host='%';
   FLUSH PRIVILEGES;
   ```

3. **使用SSL连接**
   ```sql
   -- 配置MySQL使用SSL
   SHOW VARIABLES LIKE '%ssl%';
   ```

4. **修改默认端口**（可选）
   - 编辑 `my.ini` 文件
   - 修改 `port=3306` 为其他端口
   - 重启MySQL服务

## 故障排查

### 连接被拒绝
```bash
# 1. 检查MySQL服务是否运行
sc query MySQL80

# 2. 检查端口是否监听
netstat -ano | findstr :3306

# 3. 检查防火墙规则
netsh advfirewall firewall show rule name="MySQL Port 3306"

# 4. 检查MySQL绑定地址
mysql -u root -p -e "SHOW VARIABLES LIKE 'bind_address';"
```

### 访问被拒绝（Access Denied）
```bash
# 检查用户权限
mysql -u root -p -e "SELECT host, user FROM mysql.user;"

# 授予权限
mysql -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
```

## 当前服务器配置

- **本机IP**: 192.168.88.209
- **MySQL端口**: 3306
- **数据库**: todolist_cloud
- **用户**: root
- **绑定地址**: 0.0.0.0（所有接口）
- **远程访问**: ✅ 已配置（需添加防火墙规则）

## 更新 .env 配置

配置完成后，可以在其他机器上使用远程MySQL：

```env
DB_HOST=192.168.88.209
DB_PORT=3306
DB_USER=root
DB_PASSWORD=goodboy
DB_NAME=todolist_cloud
```

或者从本机使用IP而不是localhost：
```env
DB_HOST=192.168.88.209  # 代替 localhost
```
