# TodoList - 智能任务管理应用

一个功能丰富的跨平台任务管理应用，基于 Flutter 开发，提供智能化的任务管理、习惯追踪、专注模式等多种功能。

## 主要功能

### 📝 任务管理
- **任务创建与编辑**：支持标题、描述、优先级、标签、截止时间等多种属性
- **任务分类**：通过列表和标签灵活组织任务
- **子任务支持**：将大任务分解为可管理的小任务
- **重复任务**：支持每日、每周、每月等多种重复模式
- **任务搜索**：快速查找所需任务
- **任务统计**：直观展示任务完成情况

### 📅 日历视图
- **月历视图**：清晰展示任务分布
- **任务密度热力图**：可视化任务负载
- **拖拽调整**：轻松重新安排任务时间
- **多视图切换**：日、周、月视图自由切换

### ⏱️ 专注模式
- **番茄钟计时**：经典的时间管理方法
- **专注统计**：记录和分析专注时间
- **专注热力图**：可视化专注习惯
- **时间估算**：为任务设置预期完成时间

### 🎯 习惯追踪
- **习惯打卡**：每日习惯完成记录
- **连续打卡**：追踪习惯坚持天数
- **习惯热力图**：GitHub风格的习惯可视化
- **习惯统计**：分析习惯养成进度

### 🎮 游戏化元素
- **成就系统**：完成任务获得成就徽章
- **等级系统**：通过完成任务提升等级
- **积分奖励**：任务完成获得积分
- **挑战任务**：完成特殊挑战获得额外奖励
- **称号系统**：展示你的成就

### 📊 数据统计
- **完成趋势**：任务完成情况趋势图
- **分类统计**：按列表、标签、优先级统计
- **时间分析**：专注时间和任务耗时分析
- **习惯分析**：习惯养成情况统计

### 📝 笔记功能
- **Markdown编辑**：支持丰富的Markdown语法
- **笔记搜索**：全文搜索笔记内容
- **笔记分类**：通过标签组织笔记
- **阅读模式**：优化的阅读体验
- **知识图谱**：可视化笔记之间的关联

### 🎨 个性化设置
- **主题切换**：浅色/深色主题
- **主题颜色**：多种预设颜色方案
- **自定义颜色**：自由选择主题色
- **自动切换主题**：根据时间自动切换日间/夜间主题
- **字体大小调整**：适应不同阅读需求
- **语言切换**：支持中文和英文

### 🔐 安全与隐私
- **密码保护**：应用启动密码保护
- **提醒保护**：隐藏通知详情保护隐私
- **本地存储**：数据存储在本地设备
- **云同步**（可选）：安全的云端备份

### 🔔 智能提醒
- **任务提醒**：截止时间提醒
- **习惯提醒**：每日习惯打卡提醒
- **自定义提醒**：灵活设置提醒时间
- **重复提醒**：支持多次提醒

### 📤 数据导入导出
- **备份功能**：完整导出应用数据
- **恢复功能**：从备份恢复数据
- **多种格式**：支持JSON、CSV等格式导出
- **选择性导出**：导出特定数据类型

### 🤖 AI 辅助功能
- **智能建议**：基于历史数据的任务建议
- **自然语言处理**：快速创建任务
- **语音输入**：语音转文字创建任务
- **智能分类**：自动推荐标签和列表

## 技术栈

- **框架**：Flutter 3.22+
- **语言**：Dart 3.9.2
- **状态管理**：Riverpod 2.5.1
- **本地存储**：Drift (SQLite)
- **路由**：go_router
- **国际化**：flutter_localizations
- **通知**：flutter_local_notifications
- **后端**（可选）：Node.js + Express + MySQL

## 系统要求

- **Android**：Android 5.0 (API 21) 或更高版本
- **iOS**：iOS 12.0 或更高版本
- **Windows**：Windows 10 或更高版本
- **macOS**：macOS 10.14 或更高版本
- **Linux**：支持 GTK 3.0+

## 安装方式

### Android
1. 从 [Releases](https://github.com/copyyour-cmd/todolist/releases) 下载最新版本的 APK
2. 在设备上安装 APK 文件
3. 打开应用开始使用

### 从源码构建

```bash
# 克隆仓库
git clone https://github.com/copyyour-cmd/todolist.git
cd todolist

# 安装依赖
flutter pub get

# 运行应用
flutter run

# 构建发布版本
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Windows
flutter build windows --release
```

## 开发环境设置

```bash
# 检查 Flutter 环境
flutter doctor

# 安装依赖
flutter pub get

# 生成代码
flutter pub run build_runner build

# 运行测试
flutter test
```

## 项目结构

```
lib/
├── l10n/                    # 国际化资源
├── src/
│   ├── app/                 # 应用配置
│   ├── core/                # 核心功能
│   │   ├── database/        # 数据库层
│   │   ├── design/          # 设计系统
│   │   └── utils/           # 工具函数
│   ├── domain/              # 业务模型
│   │   ├── entities/        # 实体类
│   │   └── repositories/    # 仓储接口
│   └── features/            # 功能模块
│       ├── tasks/           # 任务管理
│       ├── calendar/        # 日历
│       ├── focus/           # 专注模式
│       ├── habits/          # 习惯追踪
│       ├── notes/           # 笔记
│       ├── gamification/    # 游戏化
│       ├── statistics/      # 统计
│       └── settings/        # 设置
```

## 贡献指南

欢迎贡献代码、报告问题或提出建议！

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 联系方式

- **项目主页**：https://github.com/copyyour-cmd/todolist
- **问题反馈**：https://github.com/copyyour-cmd/todolist/issues

## 致谢

感谢所有为这个项目做出贡献的开发者和用户！

---

**享受高效的任务管理体验！** 🚀
