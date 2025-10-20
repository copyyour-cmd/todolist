# 🚀 VoltAgent代理一键安装指南

## 📌 重要说明

由于Claude Code CLI的安全设计,插件必须在CLI环境中手动确认安装。
但我已经为您准备了**最简化的流程**,只需3个简单步骤!

---

## ⚡ 超快速安装(3步完成)

### 步骤1: 复制所有命令到剪贴板

**方法A: 双击运行批处理**
```
E:\todolist\copy-install-commands.bat
```

**方法B: 使用PowerShell**
```powershell
Get-Content "E:\todolist\install-commands.txt" | Set-Clipboard
Write-Host "✅ 已复制170个安装命令到剪贴板!" -ForegroundColor Green
```

### 步骤2: 在Claude Code CLI中粘贴

1. 打开Claude Code CLI
2. 按 **Ctrl+V** 粘贴
3. 所有170个命令已就位!

### 步骤3: 执行安装

在CLI中按 **Enter** 开始执行。如果遇到:
- ✅ 成功安装 - 继续
- ⚠️ 已存在 - 跳过(正常)
- ❌ 不存在 - 跳过(某些代理可能未发布)

---

## 🎯 替代方案:分批安装

如果一次性安装太多,可以分批进行:

### 批次1: 核心必备(20个) - 5分钟
```bash
# 复制这些命令到CLI
/plugin marketplace add VoltAgent/python-pro
/plugin marketplace add VoltAgent/javascript-pro
/plugin marketplace add VoltAgent/typescript-pro
/plugin marketplace add VoltAgent/fastapi-pro
/plugin marketplace add VoltAgent/django-pro
/plugin marketplace add VoltAgent/react-expert
/plugin marketplace add VoltAgent/vue-expert
/plugin marketplace add VoltAgent/database-optimizer
/plugin marketplace add VoltAgent/security-auditor
/plugin marketplace add VoltAgent/ai-engineer
/plugin marketplace add VoltAgent/ml-engineer
/plugin marketplace add VoltAgent/data-scientist
/plugin marketplace add VoltAgent/cloud-architect
/plugin marketplace add VoltAgent/kubernetes-architect
/plugin marketplace add VoltAgent/devops-troubleshooter
/plugin marketplace add VoltAgent/test-automator
/plugin marketplace add VoltAgent/ui-ux-designer
/plugin marketplace add VoltAgent/docs-architect
/plugin marketplace add VoltAgent/search-specialist
/plugin marketplace add VoltAgent/context-manager
```

### 批次2: 语言和框架专家(30个)
```bash
/plugin marketplace add VoltAgent/java-pro
/plugin marketplace add VoltAgent/golang-pro
/plugin marketplace add VoltAgent/rust-pro
/plugin marketplace add VoltAgent/cpp-pro
/plugin marketplace add VoltAgent/c-pro
/plugin marketplace add VoltAgent/ruby-pro
/plugin marketplace add VoltAgent/php-pro
/plugin marketplace add VoltAgent/csharp-pro
/plugin marketplace add VoltAgent/scala-pro
/plugin marketplace add VoltAgent/elixir-pro
/plugin marketplace add VoltAgent/flask-expert
/plugin marketplace add VoltAgent/express-expert
/plugin marketplace add VoltAgent/nestjs-expert
/plugin marketplace add VoltAgent/spring-boot-expert
/plugin marketplace add VoltAgent/angular-expert
/plugin marketplace add VoltAgent/nextjs-expert
/plugin marketplace add VoltAgent/svelte-expert
/plugin marketplace add VoltAgent/react-native-expert
/plugin marketplace add VoltAgent/flutter-expert
/plugin marketplace add VoltAgent/ios-developer
/plugin marketplace add VoltAgent/android-developer
/plugin marketplace add VoltAgent/mobile-developer
/plugin marketplace add VoltAgent/backend-developer
/plugin marketplace add VoltAgent/frontend-developer
/plugin marketplace add VoltAgent/fullstack-developer
/plugin marketplace add VoltAgent/api-designer
/plugin marketplace add VoltAgent/graphql-architect
/plugin marketplace add VoltAgent/microservices-patterns
/plugin marketplace add VoltAgent/architecture-patterns
/plugin marketplace add VoltAgent/refactoring-expert
```

### 批次3: 其余所有代理(120个)
```bash
# 使用 install-commands.txt 中的剩余命令
```

---

## 📊 预计时间

| 方法 | 时间 | 难度 |
|------|------|------|
| 一次性安装全部 | 15-30分钟 | ⭐⭐⭐ |
| 分3批安装 | 10+10+15分钟 | ⭐⭐ |
| 只装核心20个 | 5分钟 | ⭐ |

---

## 🆘 遇到问题?

### Q: 命令太多,CLI卡住了?
A: 分批安装,每次20-30个

### Q: 某些代理安装失败?
A: 正常,可能是代理名称不存在或未发布,继续即可

### Q: 如何验证已安装?
A: 在CLI中运行 `/plugin list`

### Q: 能否真正自动化?
A: 不能,这是Claude Code的安全设计,必须手动执行

---

## ✨ 总结

**最快方法**:
1. 双击 `copy-install-commands.bat`
2. 在Claude Code CLI按 Ctrl+V
3. 按Enter执行

**推荐方法**:
1. 先安装批次1的20个核心代理
2. 使用后再决定是否安装其他代理

**完整安装**:
- 所有170个命令在 `install-commands.txt`
- 一次性复制粘贴到CLI执行

---

## 📁 相关文件

- `install-commands.txt` - 完整的170个命令
- `copy-install-commands.bat` - 一键复制脚本
- `install-agents.md` - 详细分类说明

---

祝安装顺利! 🎉

如有问题,我随时为您解答!
