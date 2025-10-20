import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/features/notes/domain/note_template.dart';

/// 笔记模板服务
class NoteTemplateService {
  static const String _boxName = 'note_templates';
  Box<NoteTemplate>? _box;

  /// 初始化
  Future<void> init() async {
    // 检查box是否已经打开
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box<NoteTemplate>(_boxName);
    } else {
      _box = await Hive.openBox<NoteTemplate>(_boxName);
    }

    // 如果是第一次运行，添加预设模板
    if (_box!.isEmpty) {
      await _initPresetTemplates();
    }
  }

  /// 初始化预设模板
  Future<void> _initPresetTemplates() async {
    final presetTemplates = [
      NoteTemplate.create(
        name: '会议记录',
        description: '记录会议要点、决策和行动项',
        icon: 'groups',
        content: '''# 会议记录

## 📋 会议信息
- **会议主题**:
- **日期时间**: ${DateTime.now().toString().split('.')[0]}
- **参会人员**:
- **会议地点**:

## 📝 会议议程
1.
2.
3.

## 💡 讨论要点
### 议题一：
-

### 议题二：
-

## ✅ 决策事项
- [ ]
- [ ]

## 📌 行动项
| 任务 | 负责人 | 截止日期 |
|-----|-------|---------|
|     |       |         |

## 📎 备注
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '读书笔记',
        description: '记录阅读心得、摘抄和感悟',
        icon: 'book',
        content: '''# 📚 读书笔记

## 📖 书籍信息
- **书名**:
- **作者**:
- **出版社**:
- **阅读日期**: ${DateTime.now().toString().split(' ')[0]}

## ⭐ 评分
⭐⭐⭐⭐⭐

## 📝 内容摘要


## 💭 精彩摘抄
>


## 🤔 个人感悟


## 💡 收获与启发
-
-

## 🔖 推荐指数
- [ ] 强烈推荐
- [ ] 值得一读
- [ ] 一般般
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '项目规划',
        description: '项目目标、计划和里程碑',
        icon: 'assignment',
        content: '''# 🎯 项目规划

## 📌 项目概述
- **项目名称**:
- **项目负责人**:
- **开始日期**: ${DateTime.now().toString().split(' ')[0]}
- **预计结束**:

## 🎯 项目目标


## 📊 项目范围
### 包含内容
-

### 不包含内容
-

## 🗓️ 里程碑
- [ ] **阶段一**: （截止日期：）
  -
- [ ] **阶段二**: （截止日期：）
  -
- [ ] **阶段三**: （截止日期：）
  -

## 👥 团队成员
| 姓名 | 角色 | 职责 |
|-----|-----|------|
|     |     |      |

## ⚠️ 风险与应对
| 风险 | 影响 | 应对措施 |
|-----|-----|---------|
|     |     |         |

## 📈 成功标准
-
-
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '日常笔记',
        description: '简单的日常记录模板',
        icon: 'edit_note',
        content: '''# 📝 ${DateTime.now().toString().split(' ')[0]}

## 今日计划
- [ ]
- [ ]

## 记录


## 想法与灵感
💡

## 待办事项
- [ ]
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '学习笔记',
        description: '课程、教程或技能学习记录',
        icon: 'school',
        content: '''# 📖 学习笔记

## 📚 学习内容
- **主题**:
- **来源**:
- **日期**: ${DateTime.now().toString().split(' ')[0]}

## 🎯 学习目标
-
-

## 📝 核心知识点
### 知识点一
-

### 知识点二
-

## 💻 实践练习


## 🤔 疑问与思考
-

## 📌 总结
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '旅行计划',
        description: '旅行行程、预算和清单',
        icon: 'flight',
        content: '''# ✈️ 旅行计划

## 📍 目的地信息
- **目的地**:
- **出发日期**:
- **返程日期**:
- **同行人员**:

## 🗓️ 行程安排
### Day 1
- 上午:
- 下午:
- 晚上:

### Day 2
- 上午:
- 下午:
- 晚上:

## 💰 预算规划
| 项目 | 预算 | 实际花费 |
|-----|------|---------|
| 交通 |      |         |
| 住宿 |      |         |
| 餐饮 |      |         |
| 门票 |      |         |
| 其他 |      |         |

## 📦 行李清单
- [ ] 证件（身份证、护照）
- [ ] 衣物
- [ ] 洗漱用品
- [ ] 电子设备及充电器
- [ ] 常用药品

## 📞 紧急联系
- 酒店电话:
- 当地急救:
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '工作周报',
        description: '每周工作总结和下周计划',
        icon: 'description',
        content: '''# 📊 工作周报

## 📅 报告周期
${DateTime.now().toString().split(' ')[0]} -

## ✅ 本周完成
1.
2.

## 📈 工作进展
| 项目/任务 | 进度 | 状态 |
|----------|------|------|
|          |      |      |

## 💡 亮点与收获
-

## ⚠️ 问题与困难
-

## 📋 下周计划
1.
2.

## 💭 其他说明
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: 'Bug报告',
        description: '软件缺陷记录和跟踪',
        icon: 'bug_report',
        content: '''# 🐛 Bug报告

## 📋 基本信息
- **Bug ID**:
- **发现日期**: ${DateTime.now().toString().split(' ')[0]}
- **严重程度**: [ ] 严重 [ ] 一般 [ ] 轻微
- **优先级**: [ ] 高 [ ] 中 [ ] 低

## 🔍 问题描述


## 📌 复现步骤
1.
2.
3.

## 🎯 预期结果


## ❌ 实际结果


## 📸 截图/附件


## 🖥️ 环境信息
- **操作系统**:
- **浏览器/版本**:
- **其他**:

## 💡 建议方案
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '面试准备',
        description: '面试问题和答案整理',
        icon: 'work',
        content: '''# 💼 面试准备

## 🏢 公司信息
- **公司名称**:
- **职位**:
- **面试时间**: ${DateTime.now().toString().split(' ')[0]}
- **面试官**:

## 📝 准备要点
### 自我介绍
-

### 项目经历
-

### 技术栈
-

## ❓ 常见问题
### 1.
**答**:

### 2.
**答**:

## 🎯 想要了解的问题
- [ ]
- [ ]

## 📌 注意事项
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '健身计划',
        description: '运动训练和饮食记录',
        icon: 'fitness',
        content: '''# 💪 健身计划

## 🎯 目标
- **开始日期**: ${DateTime.now().toString().split(' ')[0]}
- **目标体重**:
- **目标期限**:

## 🏋️ 本周训练
### 周一
-

### 周三
-

### 周五
-

## 🥗 饮食计划
### 早餐
-

### 午餐
-

### 晚餐
-

## 📊 数据记录
| 日期 | 体重 | 运动时长 | 备注 |
|------|------|---------|------|
|      |      |         |      |

## 💡 心得体会
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '购物清单',
        description: '购物计划和预算管理',
        icon: 'shopping',
        content: '''# 🛒 购物清单

## 📅 日期
${DateTime.now().toString().split(' ')[0]}

## 🏪 超市采购
- [ ]
- [ ]
- [ ]

## 🍎 生鲜食品
- [ ]
- [ ]

## 🏠 日用品
- [ ]
- [ ]

## 💰 预算
| 类别 | 预算 | 实际 |
|-----|------|------|
| 食品 |      |      |
| 日用 |      |      |
| 其他 |      |      |
| **总计** |  |      |

## 📝 备注
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '灵感笔记',
        description: '创意想法和点子收集',
        icon: 'lightbulb',
        content: '''# 💡 灵感笔记

## 📅 日期
${DateTime.now().toString().split(' ')[0]}

## ✨ 核心想法


## 🎯 应用场景
-
-

## 🔧 实现方式
1.
2.

## 📊 可行性分析
### 优势
-

### 挑战
-

## 🚀 下一步行动
- [ ]
- [ ]

## 🔗 相关资源
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '复盘总结',
        description: '项目或活动复盘分析',
        icon: 'analytics',
        content: '''# 🔄 复盘总结

## 📋 基本信息
- **项目/活动**:
- **时间**: ${DateTime.now().toString().split(' ')[0]}
- **参与人员**:

## 🎯 目标回顾
### 原定目标
-

### 实际完成
-

## ✅ 做得好的地方
1.
2.

## ⚠️ 遇到的问题
1.
2.

## 💡 改进建议
1.
2.

## 📈 数据分析
| 指标 | 目标值 | 实际值 |
|-----|--------|--------|
|     |        |        |

## 🔮 下次优化
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '读影评',
        description: '电影观后感和评价',
        icon: 'movie',
        content: '''# 🎬 影评

## 🎥 影片信息
- **片名**:
- **导演**:
- **主演**:
- **观看日期**: ${DateTime.now().toString().split(' ')[0]}

## ⭐ 评分
⭐⭐⭐⭐⭐ /5

## 📝 剧情简介


## 💭 观后感


## 🎯 亮点
-
-

## ⚠️ 不足
-

## 🔖 经典台词
>

## 💡 推荐指数
- [ ] 强烈推荐
- [ ] 值得一看
- [ ] 一般般
- [ ] 不推荐
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '每日日志',
        description: '记录每天的生活点滴和心情',
        icon: 'calendar_today',
        content: '''# 📅 每日日志

## 📆 日期
${DateTime.now().toString().split(' ')[0]}

## ☀️ 天气心情
**天气**: ☀️ / ⛅ / 🌧️ / ❄️
**心情**: 😊 / 😐 / 😔 / 😄

## 📝 今日要事
1.
2.
3.

## 🎯 完成情况
- [x]
- [ ]
- [ ]

## 💡 今日收获


## 🤔 反思与总结


## 🔜 明日计划
-
-

## 📸 今日一图/一句


## 💭 随笔
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '目标计划',
        description: '设定和追踪长期目标',
        icon: 'flag',
        content: '''# 🎯 目标计划

## 📌 目标信息
- **目标名称**:
- **制定日期**: ${DateTime.now().toString().split(' ')[0]}
- **目标期限**:
- **目标类型**: [ ] 短期 [ ] 中期 [ ] 长期

## 🎯 目标描述


## 📊 衡量标准
- **成功指标**:
-
-

## 🗓️ 阶段规划
### 第一阶段（时间：）
- [ ]
- [ ]

### 第二阶段（时间：）
- [ ]
- [ ]

### 第三阶段（时间：）
- [ ]
- [ ]

## 💪 所需资源
- **时间投入**:
- **资金投入**:
- **人力支持**:
- **学习内容**:

## ⚠️ 潜在障碍
1.
2.

## 💡 应对策略
1.
2.

## 📈 进度追踪
| 日期 | 进度 | 备注 |
|-----|------|------|
|     |      |      |

## 🎉 达成奖励
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '理财记录',
        description: '收支管理和财务规划',
        icon: 'account_balance',
        content: '''# 💰 理财记录

## 📅 记录周期
${DateTime.now().toString().split(' ')[0]} -

## 💵 收入统计
| 日期 | 来源 | 金额 | 备注 |
|-----|------|------|------|
|     | 工资 |      |      |
|     | 奖金 |      |      |
|     | 其他 |      |      |
| **总计** |  |      |      |

## 💸 支出统计
### 固定支出
- **房租/房贷**: ¥
- **水电燃气**: ¥
- **交通费**: ¥
- **保险**: ¥

### 可变支出
| 日期 | 类别 | 金额 | 备注 |
|-----|------|------|------|
|     | 餐饮 |      |      |
|     | 购物 |      |      |
|     | 娱乐 |      |      |
|     | 其他 |      |      |

## 📊 收支分析
- **总收入**: ¥
- **总支出**: ¥
- **结余**: ¥
- **储蓄率**: %

## 💎 投资理财
| 类型 | 金额 | 预期收益 | 到期时间 |
|-----|------|---------|---------|
|     |      |         |         |

## 🎯 财务目标
- 短期目标:
- 长期目标:

## 💡 本期总结
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '设计方案',
        description: '创意设计和方案记录',
        icon: 'palette',
        content: '''# 🎨 设计方案

## 📋 项目信息
- **项目名称**:
- **设计日期**: ${DateTime.now().toString().split(' ')[0]}
- **设计师**:
- **客户/部门**:

## 🎯 设计目标


## 🎨 设计理念


## 🖌️ 风格定位
- **视觉风格**: [ ] 简约 [ ] 商务 [ ] 时尚 [ ] 复古 [ ] 科技
- **色彩基调**:
- **字体选择**:

## 📐 设计要素
### 主要元素
-
-

### 辅助元素
-
-

## 🎨 配色方案
- **主色**: #
- **辅色**: #
- **点缀色**: #
- **背景色**: #

## 📱 应用场景
1.
2.
3.

## 🔍 竞品分析
| 竞品 | 优点 | 缺点 | 借鉴点 |
|-----|------|------|-------|
|     |      |      |       |

## ✅ 待办清单
- [ ] 初稿设计
- [ ] 客户反馈
- [ ] 修改调整
- [ ] 最终定稿

## 📎 参考资源
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '技术文档',
        description: '技术方案和API文档',
        icon: 'code',
        content: '''# 🔧 技术文档

## 📋 文档信息
- **文档标题**:
- **版本**: v1.0.0
- **创建日期**: ${DateTime.now().toString().split(' ')[0]}
- **作者**:
- **最后更新**:

## 📝 概述


## 🎯 功能说明


## 🏗️ 技术架构
### 技术栈
- **前端**:
- **后端**:
- **数据库**:
- **部署**:

### 系统架构图
```
(在此绘制或描述架构图)
```

## 📡 API文档
### 接口1:
**请求方式**: GET / POST / PUT / DELETE
**请求URL**: `/api/xxx`

**请求参数**:
| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
|       |      |      |      |

**响应数据**:
```json
{
  "code": 200,
  "message": "success",
  "data": {}
}
```

## 💾 数据库设计
### 表1:
| 字段名 | 类型 | 说明 | 索引 |
|-------|------|------|------|
|       |      |      |      |

## 🔐 安全说明


## 📊 性能优化


## ⚠️ 注意事项


## 🐛 已知问题


## 📌 更新日志
- v1.0.0 (${DateTime.now().toString().split(' ')[0]}) - 初始版本
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '菜谱笔记',
        description: '美食制作步骤记录',
        icon: 'restaurant',
        content: '''# 🍳 菜谱笔记

## 🍽️ 菜品信息
- **菜名**:
- **菜系**: [ ] 中餐 [ ] 西餐 [ ] 日料 [ ] 其他
- **难度**: ⭐⭐⭐☆☆
- **用时**: 约 分钟
- **份量**: 人份

## 🥗 食材清单
### 主料
-
-

### 辅料
-
-

### 调料
-
-

## 👨‍🍳 制作步骤
1. **准备工作**
   -

2. **第一步**
   -

3. **第二步**
   -

4. **第三步**
   -

5. **装盘**
   -

## 💡 烹饪技巧
-
-

## ⚠️ 注意事项
-

## 📸 成品照片
(拍照留念)

## ⭐ 口味评分
味道: ⭐⭐⭐⭐⭐
卖相: ⭐⭐⭐⭐⭐

## 💭 制作心得


## 🔄 改进想法
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '游戏攻略',
        description: '游戏心得和攻略笔记',
        icon: 'games',
        content: '''# 🎮 游戏攻略

## 🎯 游戏信息
- **游戏名称**:
- **平台**: [ ] PC [ ] PS5 [ ] Xbox [ ] Switch [ ] 手游
- **类型**:
- **开始日期**: ${DateTime.now().toString().split(' ')[0]}

## 📊 游戏进度
- **当前等级/章节**:
- **完成度**: %
- **游戏时长**: 小时

## 🗺️ 关卡攻略
### 关卡/章节名称
**难度**: ⭐⭐⭐☆☆

**通关要点**:
1.
2.
3.

**注意事项**:
-

## 💪 角色/装备推荐
### 推荐角色
- **角色名**:
  - 技能:
  - 优势:

### 推荐装备
- **装备名**:
  - 属性:
  - 获取方式:

## 🎯 任务清单
- [ ] 主线任务:
- [ ] 支线任务:
- [ ] 隐藏要素:
- [ ] 收集品:

## 💎 资源获取
| 资源名称 | 获取地点 | 获取方式 | 备注 |
|---------|---------|---------|------|
|         |         |         |      |

## 🏆 成就/奖杯
- [ ] 成就1:
- [ ] 成就2:

## 💡 游戏技巧
-
-

## 📝 游戏心得


## 🔗 参考资源
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '论文笔记',
        description: '学术论文阅读笔记',
        icon: 'article',
        content: '''# 📚 论文笔记

## 📄 论文信息
- **标题**:
- **作者**:
- **发表时间**:
- **期刊/会议**:
- **DOI/链接**:
- **阅读日期**: ${DateTime.now().toString().split(' ')[0]}

## 🎯 研究问题


## 💡 核心观点


## 🔬 研究方法
### 实验设计
-

### 数据来源
-

### 分析方法
-

## 📊 主要发现
1.
2.
3.

## 📈 实验结果


## 💪 创新点
-
-

## ⚠️ 局限性
-
-

## 🤔 个人思考
### 启发
-

### 疑问
-

### 改进建议
-

## 🔗 相关文献
1. [论文名] - 作者, 年份
2.

## 📌 重要术语
- **术语1**: 解释
- **术语2**: 解释

## 💡 应用价值


## 📝 引用格式
```
APA格式:
MLA格式:
```
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '演讲稿',
        description: '演讲内容和要点整理',
        icon: 'campaign',
        content: '''# 🎤 演讲稿

## 📋 基本信息
- **演讲主题**:
- **演讲场合**:
- **演讲日期**: ${DateTime.now().toString().split(' ')[0]}
- **演讲时长**: 分钟
- **目标听众**:

## 🎯 演讲目标


## 📝 演讲大纲
### 开场白（ 分钟）
-
-

### 主体部分
#### 第一部分：（ 分钟）
**要点**:
-
-

**支撑材料**:
-

#### 第二部分：（ 分钟）
**要点**:
-
-

**支撑材料**:
-

#### 第三部分：（ 分钟）
**要点**:
-
-

**支撑材料**:
-

### 结尾（ 分钟）
-
-

## 💡 金句/亮点
1.
2.
3.

## 📊 辅助材料
- [ ] PPT/Keynote
- [ ] 视频素材
- [ ] 数据图表
- [ ] 案例故事

## 🎭 演讲技巧提醒
- **语速**: 适中,重点放慢
- **停顿**: 关键处留白
- **肢体语言**: 自然得体
- **眼神交流**: 环顾四周
- **音量**: 洪亮清晰

## ⚠️ 注意事项
-
-

## 🤔 预期问题与回答
**Q1**:
**A1**:

**Q2**:
**A2**:

## 📝 演讲后总结
(演讲结束后填写)
''',
        isPreset: true,
      ),
      NoteTemplate.create(
        name: '就医记录',
        description: '健康和就医信息管理',
        icon: 'local_hospital',
        content: '''# 🏥 就医记录

## 📅 就诊信息
- **就诊日期**: ${DateTime.now().toString().split(' ')[0]}
- **就诊医院**:
- **科室**:
- **医生姓名**:

## 🤒 主诉症状
**症状描述**:
-
-

**持续时间**:
**严重程度**: [ ] 轻微 [ ] 中等 [ ] 严重

## 📋 检查项目
| 检查项目 | 检查结果 | 参考范围 | 异常标注 |
|---------|---------|---------|---------|
|         |         |         |         |
|         |         |         |         |

## 🩺 诊断结果
**疾病诊断**:

**病情分析**:

## 💊 用药方案
| 药品名称 | 规格 | 用法用量 | 疗程 | 注意事项 |
|---------|------|---------|------|---------|
|         |      |         |      |         |

## 🏥 治疗建议
1.
2.
3.

## ⚠️ 注意事项
- **饮食**:
- **运动**:
- **休息**:
- **禁忌**:

## 📅 复诊安排
- **复诊日期**:
- **复诊目的**:
- **需要携带**:

## 💰 费用记录
- **挂号费**: ¥
- **检查费**: ¥
- **药品费**: ¥
- **总计**: ¥

## 📝 病情追踪
| 日期 | 症状变化 | 用药情况 | 备注 |
|-----|---------|---------|------|
|     |         |         |      |

## 🔖 既往病史参考
-
-

## 📞 紧急联系
- **医生电话**:
- **医院电话**:
''',
        isPreset: true,
      ),
    ];

    for (final template in presetTemplates) {
      await _box!.add(template);
    }
  }

  /// 获取所有模板（按使用次数排序）
  List<NoteTemplate> getAllTemplates() {
    final templates = _box?.values.toList() ?? [];
    templates.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return templates;
  }

  /// 获取预设模板（按使用次数排序）
  List<NoteTemplate> getPresetTemplates() {
    final templates = _box?.values.where((t) => t.isPreset).toList() ?? [];
    templates.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return templates;
  }

  /// 获取自定义模板（按使用次数排序）
  List<NoteTemplate> getCustomTemplates() {
    final templates = _box?.values.where((t) => !t.isPreset).toList() ?? [];
    templates.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return templates;
  }

  /// 根据ID获取模板
  NoteTemplate? getTemplateById(String id) {
    return _box?.values.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Template not found'),
    );
  }

  /// 添加模板
  Future<void> addTemplate(NoteTemplate template) async {
    await _box!.add(template);
  }

  /// 更新模板
  Future<void> updateTemplate(NoteTemplate template) async {
    final index = _box!.values.toList().indexWhere((t) => t.id == template.id);
    if (index != -1) {
      await _box!.putAt(index, template);
    }
  }

  /// 增加模板使用次数
  Future<void> incrementUsageCount(String templateId) async {
    final template = getTemplateById(templateId);
    if (template != null) {
      template.usageCount++;
      await template.save();
    }
  }

  /// 删除模板（只能删除自定义模板）
  Future<bool> deleteTemplate(String id) async {
    final template = getTemplateById(id);
    if (template == null || template.isPreset) {
      return false; // 不能删除预设模板
    }

    final index = _box!.values.toList().indexWhere((t) => t.id == id);
    if (index != -1) {
      await _box!.deleteAt(index);
      return true;
    }
    return false;
  }

  /// 关闭数据库
  Future<void> close() async {
    await _box?.close();
  }
}
