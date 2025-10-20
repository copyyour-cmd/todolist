# VoltAgent正确安装方式 (根据网络搜索结果)

## 重要发现!

根据搜索结果,VoltAgent的安装方式**不是**通过 `/plugin marketplace add`,而是:

## ✅ 正确的安装方法

### 方法1: 使用 `/agents` 命令 (推荐)

1. **在Claude Code CLI中执行:**
   ```
   /agents
   ```

2. **这个命令会打开交互式界面,可以:**
   - 列出所有可用的代理
   - 创建新代理
   - 管理现有代理
   - 选择代理存储位置

3. **选择存储位置:**
   - **项目级别**: `.claude/agents/` (项目内)
   - **个人级别**: `~/.claude/agents/` (全局)

### 方法2: 手动创建Markdown文件

VoltAgent的代理就是**普通的Markdown文件**!

1. **创建代理文件位置:**
   - Windows: `%USERPROFILE%\.claude\agents\`
   - macOS/Linux: `~/.claude/agents/`
   - 项目内: `.claude/agents/`

2. **文件格式示例:**
   ```markdown
   ---
   name: python-pro
   description: Python开发专家
   tools: [Read, Write, Bash, Grep]
   ---
   
   # Python专家
   
   你是Python开发专家,精通...
   
   ## 核心能力
   - Python 3.12+
   - FastAPI, Django
   ...
   ```

3. **Claude Code会自动检测和加载**这些文件

### 方法3: 从VoltAgent仓库复制

1. **VoltAgent仓库结构:**
   - GitHub仓库包含代理的Markdown文件
   - 不是通过marketplace安装
   - 直接复制`.md`文件即可

2. **安装步骤:**
   ```bash
   # 克隆VoltAgent仓库
   git clone https://github.com/VoltAgent/awesome-claude-code-subagents.git
   
   # 复制代理文件到你的agents目录
   # Windows:
   copy awesome-claude-code-subagents\categories\**\*.md %USERPROFILE%\.claude\agents\
   
   # macOS/Linux:
   cp -r awesome-claude-code-subagents/categories/**/*.md ~/.claude/agents/
   ```

## 重要区别

### ❌ 错误理解:
- `/plugin marketplace add VoltAgent/xxx` 
- 以为VoltAgent在marketplace上

### ✅ 正确理解:
- VoltAgent是一个GitHub仓库
- 包含100+个Markdown格式的代理文件
- 需要手动复制或使用`/agents`命令创建
- 文件存放在 `.claude/agents/` 目录

## 文件位置

### 当前我们的代理位置:
- `C:\Users\copyyour\.claude\subagents\` ❌ (错误位置)

### 应该放在:
- `C:\Users\copyyour\.claude\agents\` ✅ (正确位置)

或者

- `.claude\agents\` ✅ (项目级别)

## 下一步行动

1. **检查Claude Code版本**
   ```bash
   claude --version
   ```
   需要版本 >= 1.0.60

2. **创建正确的agents目录**
   ```bash
   mkdir -p ~/.claude/agents
   # Windows: mkdir %USERPROFILE%\.claude\agents
   ```

3. **移动或复制代理文件**
   从 `subagents/` 移到 `agents/`

4. **使用 `/agents` 命令验证**
   在Claude Code CLI中执行 `/agents` 查看已安装的代理

## 总结

VoltAgent **不是通过marketplace安装**,而是:
1. 直接复制Markdown文件到 `.claude/agents/`
2. 或使用 `/agents` 命令交互式创建
3. Claude Code会自动检测和加载这些文件
