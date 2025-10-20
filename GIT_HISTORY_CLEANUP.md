# Git 历史清理指南

## 警告

**此文档仅在敏感信息已提交到Git仓库时使用**

当前项目尚未初始化Git仓库，因此无需执行清理操作。
本文档作为预防性参考保存。

## 检查是否需要清理

### 1. 检查文件是否已提交到Git

```bash
# 检查.env文件历史
git log --all --full-history -- "server/.env"

# 检查.env.example文件历史
git log --all --full-history -- "server/.env.example"

# 搜索包含敏感关键词的提交
git log -S "goodboy" --all
git log -S "192.168.88" --all
```

### 2. 如果发现敏感信息已提交

立即执行以下步骤：

## 清理方案

### 方案1：使用 git-filter-repo（推荐）

**优点**：
- 最快速、最安全
- Python工具，易于安装
- Git官方推荐

**安装**：
```bash
# 使用pip安装
pip install git-filter-repo

# 或在Ubuntu/Debian
apt-get install git-filter-repo

# macOS
brew install git-filter-repo
```

**执行清理**：
```bash
# 进入项目目录
cd E:/todolist

# 备份仓库（重要！）
cp -r .git .git.backup

# 移除.env文件的所有历史记录
git filter-repo --path server/.env --invert-paths

# 如果.env.example也包含敏感信息，移除其历史
git filter-repo --path server/.env.example --invert-paths

# 验证清理结果
git log --all --full-history -- "server/.env"
```

**强制推送到远程**：
```bash
# 警告：此操作会重写远程仓库历史！
# 确保团队成员已知晓并备份本地工作

git push origin --force --all
git push origin --force --tags
```

### 方案2：使用 BFG Repo-Cleaner

**优点**：
- 速度极快
- 简单易用
- 适合大型仓库

**安装**：
```bash
# 下载BFG
# 访问: https://rtyley.github.io/bfg-repo-cleaner/
# 或直接下载jar文件
wget https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar
```

**执行清理**：
```bash
# 创建新克隆（BFG要求在镜像仓库上操作）
git clone --mirror git@github.com:your-username/your-repo.git

# 删除.env文件
java -jar bfg-1.14.0.jar --delete-files .env your-repo.git

# 替换包含敏感信息的文本
java -jar bfg-1.14.0.jar --replace-text passwords.txt your-repo.git

# 进入镜像仓库
cd your-repo.git

# 清理和压缩
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 强制推送
git push
```

### 方案3：手动使用 git filter-branch（不推荐）

**仅在无法使用上述工具时使用**：

```bash
# 移除文件
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch server/.env" \
  --prune-empty --tag-name-filter cat -- --all

# 清理引用
git for-each-ref --format="delete %(refname)" refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 强制推送
git push origin --force --all
git push origin --force --tags
```

## 团队协作清理流程

### 执行前

1. **通知所有团队成员**
   - 说明清理原因和时间
   - 要求成员提交并推送所有工作
   - 等待所有成员确认

2. **创建完整备份**
   ```bash
   # 在多个位置创建备份
   cp -r /path/to/repo /backup/location1/
   cp -r /path/to/repo /backup/location2/
   ```

3. **记录当前状态**
   ```bash
   git log --oneline --all > commits-before-cleanup.txt
   git branch -a > branches-before-cleanup.txt
   ```

### 执行中

1. **执行清理**（使用上述任一方案）

2. **验证清理结果**
   ```bash
   # 检查敏感信息是否完全移除
   git log --all --full-history -- "server/.env"

   # 搜索敏感关键词
   git log -S "goodboy" --all
   git log -S "sensitive-keyword" --all

   # 检查仓库大小变化
   du -sh .git
   ```

3. **强制推送**
   ```bash
   git push origin --force --all
   git push origin --force --tags
   ```

### 执行后

1. **团队成员清理本地仓库**

   发送给所有团队成员的说明：
   ```bash
   # 删除本地仓库
   rm -rf /path/to/old/repo

   # 重新克隆
   git clone git@github.com:your-username/your-repo.git

   # 或者，保留本地更改：
   git fetch origin
   git reset --hard origin/main  # 或你的主分支名
   git clean -fdx
   ```

2. **验证所有副本已清理**
   - GitHub/GitLab/Bitbucket等托管平台
   - CI/CD系统中的缓存
   - 团队成员的本地克隆
   - 备份系统

## 应急响应清单

### 立即执行（0-1小时）

- [ ] 确认泄露的敏感信息范围
- [ ] 轮换所有泄露的密钥和密码
  - [ ] 数据库密码
  - [ ] JWT密钥
  - [ ] API密钥
  - [ ] 其他凭证
- [ ] 通知安全团队
- [ ] 检查系统日志，寻找异常访问

### 短期措施（1-24小时）

- [ ] 执行Git历史清理
- [ ] 强制用户重新认证（如JWT密钥泄露）
- [ ] 审计数据库访问记录
- [ ] 检查数据完整性
- [ ] 通知受影响的相关方

### 长期措施（1-7天）

- [ ] 实施增强的监控
- [ ] 审查和更新安全策略
- [ ] 进行安全培训
- [ ] 更新文档和流程
- [ ] 进行事后分析

## 清理验证

### 完全验证检查表

- [ ] Git历史中不包含.env文件
- [ ] 搜索敏感关键词无结果
- [ ] 远程仓库已更新
- [ ] 所有团队成员已更新本地仓库
- [ ] CI/CD缓存已清理
- [ ] 密钥和密码已全部轮换
- [ ] 审计日志显示无异常访问
- [ ] 新的.gitignore配置生效

### 验证命令

```bash
# 确保.env不在任何历史中
git log --all --full-history --pretty=format: --name-only | sort -u | grep "\.env$"

# 应该返回空结果（或只有.env.example）

# 检查仓库中所有文件
git ls-tree -r HEAD --name-only

# 搜索敏感字符串
git grep -i "goodboy" $(git rev-list --all)
git grep -i "192.168.88" $(git rev-list --all)
```

## 防止未来泄露

### Git Hooks

创建 `.git/hooks/pre-commit`：

```bash
#!/bin/bash

# 检查是否尝试提交.env文件
if git diff --cached --name-only | grep -q "\.env$"; then
  echo "错误：不允许提交 .env 文件！"
  echo "请将其添加到 .gitignore"
  exit 1
fi

# 检查是否包含敏感关键词
if git diff --cached | grep -i "password.*=.*[a-zA-Z0-9]"; then
  echo "警告：检测到可能的密码，请确认是否为示例值"
  read -p "确认提交？(y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

exit 0
```

设置执行权限：
```bash
chmod +x .git/hooks/pre-commit
```

### GitHub Secrets Scanning

如果使用GitHub，启用以下功能：

1. **启用Secret Scanning**
   - 仓库设置 → Security & analysis
   - 启用 "Secret scanning"

2. **启用Push Protection**
   - 防止推送包含密钥的提交

3. **配置通知**
   - 设置安全通知邮箱

### Git Guardian

集成第三方工具：

```bash
# 安装
pip install ggshield

# 配置
ggshield auth login

# 扫描当前仓库
ggshield secret scan repo .

# 扫描历史
ggshield secret scan repo . --all-history
```

## 资源和工具

### 工具链接

- **git-filter-repo**: https://github.com/newren/git-filter-repo
- **BFG Repo-Cleaner**: https://rtyley.github.io/bfg-repo-cleaner/
- **GitGuardian**: https://www.gitguardian.com/
- **TruffleHog**: https://github.com/trufflesecurity/trufflehog
- **Gitleaks**: https://github.com/gitleaks/gitleaks

### 学习资源

- GitHub文档：Removing sensitive data from a repository
- Git官方文档：git-filter-repo
- OWASP：Secrets Management Cheat Sheet

## 联系信息

如遇到问题或需要协助：

- 安全团队邮箱：security@example.com
- 紧急热线：+86-xxx-xxxx-xxxx
- 内部Wiki：https://wiki.example.com/security

---

**文档版本**: 1.0
**最后更新**: 2025-10-20
**维护者**: DevSecOps团队
