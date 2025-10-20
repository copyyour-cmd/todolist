# 📝 Markdown笔记系统实现文档

> 实现日期: 2025-10-10
> 完成进度: 40% (数据层+服务层+编辑器完成)

---

## 🎯 功能概述

Markdown笔记系统是TodoList应用的重要扩展功能,提供以下核心能力:

- ✅ **富文本Markdown编辑器** - 实时编辑和预览
- ✅ **完整的笔记管理** - CRUD + 分类 + 标签 + 搜索
- 🔄 **图片插入与管理** - 待实现
- 🔄 **内部链接** - 笔记↔任务互联
- 🔄 **全文搜索** - 高效检索
- 📊 **统计分析** - 字数、阅读时间等

---

## ✅ 已完成部分

### 1. 数据层 (100%)

#### Note实体 (`lib/src/domain/entities/note.dart`)
```dart
- 20个字段完整数据模型
- 8种分类(通用/工作/个人/学习/项目/会议/日记/参考)
- 支持标签、文件夹、链接、附件
- 自动统计字数和阅读时间
- 置顶、收藏、归档功能
- 查看计数和历史
```

#### NoteRepository接口 (`lib/src/domain/repositories/note_repository.dart`)
```dart
- 18个方法定义
- 基础CRUD操作
- 分类/标签/收藏/置顶筛选
- 全文搜索
- 最近查看/更新
```

#### HiveNoteRepository实现 (`lib/src/infrastructure/repositories/hive_note_repository.dart`)
```dart
- Hive本地存储
- Stream响应式更新
- 智能排序(置顶>更新时间)
- 异常处理
```

### 2. 服务层 (100%)

#### NoteService (`lib/src/features/notes/application/note_service.dart`)
```dart
- 创建/更新/删除笔记
- 收藏/置顶/归档切换
- 标签管理
- 任务/笔记链接管理
- 复制笔记
- 查看记录
```

#### NoteProviders (`lib/src/features/notes/application/note_providers.dart`)
```dart
- 12个Riverpod Provider
- 所有笔记流
- 分类筛选
- 收藏/置顶/归档
- 搜索
- 统计信息
```

### 3. UI组件 (30%)

#### MarkdownEditor (`lib/src/features/notes/presentation/widgets/markdown_editor.dart`)
```dart
✅ 编辑/预览Tab切换
✅ 完整工具栏(20+功能)
  - 粗体/斜体/删除线
  - 标题(1-6级)
  - 引用/代码/代码块
  - 无序/有序/任务列表
  - 链接/图片
  - 表格/分隔线
✅ 实时Markdown渲染
✅ 语法高亮
✅ 选中文本智能包裹
```

---

## 🔄 待完成部分

### 4. 页面实现 (0%)

#### ✏️ 笔记列表页面 (`notes_list_page.dart`)
**功能需求:**
- 分类Tab切换(8种)
- 搜索框
- 筛选按钮(收藏/置顶/归档)
- 笔记卡片列表
  - 标题
  - 预览内容(100字)
  - 分类图标+标签
  - 字数+查看数
  - 更新时间
- 长按进入选择模式
- 批量操作(删除/归档/标签)
- FAB创建新笔记
- 下拉刷新
- 空状态提示

#### 📄 笔记详情/编辑页面 (`note_editor_page.dart`)
**功能需求:**
- AppBar
  - 保存按钮
  - 更多菜单(收藏/置顶/归档/删除/复制)
- 标题输入框
- Markdown编辑器
- 底部工具栏
  - 分类选择
  - 标签管理
  - 图片插入
  - 链接任务
  - 链接笔记
  - 统计信息显示

#### 🔍 笔记搜索页面 (`note_search_page.dart`)
**功能需求:**
- 搜索框(自动完成)
- 搜索历史
- 实时结果展示
- 关键词高亮
- 按相关度排序

---

### 5. 图片管理 (0%)

#### 📸 ImagePicker集成
```dart
- 从相册选择
- 拍照
- 多选支持
- 压缩优化
- 本地存储或云存储
```

#### 🖼️ 图片管理器
```dart
- 图片网格预览
- 点击放大查看
- 删除管理
- Markdown语法自动插入
```

---

### 6. 内部链接 (0%)

#### 🔗 任务链接
```dart
- 选择任务对话框
- 已链接任务列表
- 点击跳转到任务详情
- 双向链接(任务中显示关联笔记)
```

#### 📝 笔记链接
```dart
- 选择笔记对话框
- 已链接笔记列表
- 点击跳转到笔记详情
- 知识网络可视化(可选)
```

#### 🎯 特殊语法支持
```markdown
[[task:taskId]] - 链接到任务
[[note:noteId]] - 链接到笔记
#标签 - 自动识别标签
@提及 - 支持提及(未来)
```

---

### 7. 全文搜索 (50%)

#### ✅ 已实现
- Repository层search方法
- Provider支持

#### 🔄 待完善
- 搜索UI
- 搜索历史持久化
- 高级搜索(正则/作者/日期)
- 搜索结果高亮
- 模糊搜索

---

### 8. 集成工作 (0%)

#### 📌 Bootstrap集成
```dart
// lib/src/bootstrap.dart
- 添加HiveNoteRepository初始化
- 注册noteRepositoryProvider
- 注册Note TypeAdapter
```

#### 🧭 路由配置
```dart
// lib/src/app/router.dart
- /notes - 笔记列表
- /notes/:id - 笔记详情
- /notes/new - 新建笔记
- /notes/search - 搜索笔记
```

#### 🏠 主页集成
```dart
// lib/src/features/home/presentation/home_page.dart
- AppBar添加笔记入口按钮
- 或在"新建"菜单中添加"新建笔记"选项
```

#### 🎨 主题适配
- 确保Dark Mode适配
- 自定义主题色支持

---

## 📦 依赖包

已引入(无需额外安装):
```yaml
flutter_markdown: ^0.7.4+1  # Markdown渲染
image_picker: ^1.1.2        # 图片选择
file_picker: ^8.1.6         # 文件选择
path_provider: ^2.1.5       # 路径管理
```

---

## 🎨 UI设计建议

### 笔记卡片
```
┌─────────────────────────────────┐
│ 📝 标题                    ⭐ 📌 │
│ 预览内容前100字...             │
│ 💼工作 #标签1 #标签2            │
│ 1234字 · 23次查看 · 2小时前    │
└─────────────────────────────────┘
```

### 编辑器布局
```
┌─────────────────────────────────┐
│ [保存] 标题输入框        [•••]  │
├─────────────────────────────────┤
│ [编辑] [预览]                   │
├─────────────────────────────────┤
│ [B] [I] [~] | [H] [>] [`] [{}] │
│ [•] [1.] [☑] | [🔗] [🖼] [—]    │
├─────────────────────────────────┤
│                                 │
│  Markdown编辑区域               │
│                                 │
│                                 │
└─────────────────────────────────┘
│ 💼分类 🏷️标签 🖼️图片 🔗链接    │
└─────────────────────────────────┘
```

---

## 🔧 下一步开发计划

### 优先级 1 (本周完成)
1. ✏️ 实现笔记列表页面
2. 📄 实现笔记编辑页面
3. 📌 Bootstrap集成
4. 🧭 路由配置

### 优先级 2 (下周完成)
5. 📸 图片插入功能
6. 🔗 内部链接功能
7. 🔍 搜索页面完善

### 优先级 3 (后续优化)
8. 📊 统计图表
9. 📤 导出PDF/Markdown文件
10. 🌐 云同步支持
11. 🎯 知识图谱可视化

---

## 💡 高级功能构想

### 📚 笔记本/文件夹
- 多级文件夹结构
- 拖拽整理
- 文件夹封面

### 🎨 Markdown扩展
- Mermaid图表
- LaTeX数学公式
- 自定义组件

### 🤝 协作功能
- 分享笔记链接
- 协作编辑
- 评论讨论

### 🔔 提醒功能
- 定时复习提醒
- 知识回顾

### 🎓 知识管理
- 双链笔记
- 反向链接
- 知识图谱
- 时间轴视图

---

## 📖 使用示例

### 创建笔记
```dart
final service = ref.read(noteServiceProvider);

final note = await service.createNote(
  NoteCreationInput(
    title: 'Flutter开发笔记',
    content: '# 今日学习\n\n- Riverpod状态管理\n- Freezed数据类',
    category: NoteCategory.study,
    tags: ['Flutter', 'Dart'],
  ),
);
```

### 搜索笔记
```dart
final results = await ref.read(
  searchNotesProvider('Flutter').future,
);
```

### 链接任务
```dart
await service.linkTask(note, taskId);
```

---

## 🎉 总结

Markdown笔记系统的核心架构已经完成,包括:
- ✅ 完整的数据模型和Repository
- ✅ 业务逻辑服务层
- ✅ 功能丰富的Markdown编辑器

接下来需要完成UI页面、图片管理和内部链接等功能,预计再需要2-3天即可完成全部功能！

---

*开发者: Claude Code*
*项目: TodoList*
*更新: 2025-10-10*
