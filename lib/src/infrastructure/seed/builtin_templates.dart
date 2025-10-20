import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/sub_task.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_template.dart';
import 'package:todolist/src/infrastructure/seed/famous_quotes.dart';

/// 内置任务模板数据
class BuiltInTemplates {
  // Use a fixed seed to generate consistent IDs for built-in templates
  static const _templateIdPrefix = 'builtin_';

  /// 获取所有内置模板
  static List<TaskTemplate> getAll() {
    final now = DateTime.now();
    final idGen = IdGenerator();

    return [
      ..._getFitnessTemplates(now, idGen),
      ..._getCookingTemplates(now, idGen),
      ..._getLearningTemplates(now, idGen),
      ..._getWorkTemplates(now, idGen),
      ..._getHomeTemplates(now, idGen),
      ..._getHealthTemplates(now, idGen),
      ..._getTravelTemplates(now, idGen),
      ..._getShoppingTemplates(now, idGen),
      ..._getProjectTemplates(now, idGen),
      ..._getHabitTemplates(now, idGen),
      ..._getFinanceTemplates(now, idGen),
      ..._getCreativeTemplates(now, idGen),
      ..._getSocialTemplates(now, idGen),
      ..._getMaintenanceTemplates(now, idGen),
    ];
  }

  // ========== 健身运动模板 ==========
  static List<TaskTemplate> _getFitnessTemplates(DateTime now, IdGenerator idGen) => [
    // ===== 在家无器械健身模板 =====
    TaskTemplate(
      id: '${_templateIdPrefix}home_pushup_workout',
      title: '在家俯卧撑训练',
      description: '全面锻炼胸肌、三头肌和核心,无需器械',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 25,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 肩部绕环20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '标准俯卧撑 3组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '宽距俯卧撑 3组 x 12次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '钻石俯卧撑 3组 x 10次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '拉伸胸部和手臂',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_squat_workout',
      title: '在家深蹲训练',
      description: '打造强壮大腿和臀部,徒手训练',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 30,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 原地高抬腿2分钟',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '标准深蹲 4组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '相扑深蹲 3组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '箭步蹲 3组 x 12次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '单腿深蹲 3组 x 8次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '腿部拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_core_workout',
      title: '在家核心训练',
      description: '强化腹肌和核心稳定性,随时随地练',
      category: TemplateCategory.fitness,
      priority: TaskPriority.high,
      estimatedMinutes: 20,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '平板支撑 4组 x 60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '侧平板支撑 3组 x 45秒/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '卷腹 4组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '俄罗斯转体 3组 x 30次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '死虫式 3组 x 15次',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_burpee_cardio',
      title: '在家波比跳燃脂',
      description: '全身爆发力训练,高效燃烧卡路里',
      category: TemplateCategory.fitness,
      priority: TaskPriority.high,
      estimatedMinutes: 20,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 原地慢跑3分钟',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '标准波比跳 5组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '半波比跳 3组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '波比跳+俯卧撑 3组 x 10次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '拉伸放松',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_plank_challenge',
      title: '在家平板支撑挑战',
      description: '核心耐力训练,打造钢铁腹肌',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 15,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '标准平板支撑 90秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '侧平板支撑左侧 60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '侧平板支撑右侧 60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '平板支撑抬腿 3组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '平板支撑点肩 3组 x 16次',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_mountain_climbers',
      title: '在家登山跑训练',
      description: '燃脂+核心+心肺三合一',
      category: TemplateCategory.fitness,
      priority: TaskPriority.high,
      estimatedMinutes: 15,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 开合跳2分钟',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '标准登山跑 5组 x 45秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '交叉登山跑 4组 x 40秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '慢速登山跑 3组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '腹部拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_jumping_jacks',
      title: '在家开合跳有氧',
      description: '简单高效的全身有氧运动',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 20,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '标准开合跳 5组 x 50次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '前后开合跳 4组 x 40次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '蹲跳开合 3组 x 30次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '快速开合跳 3组 x 60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '全身拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_lunge_workout',
      title: '在家箭步蹲训练',
      description: '锻炼腿部线条和臀部力量',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 25,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 腿部摆动20次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '前向箭步蹲 4组 x 15次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '后向箭步蹲 3组 x 12次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '侧向箭步蹲 3组 x 12次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '跳跃箭步蹲 3组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '腿部深度拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_glute_bridge',
      title: '在家臀桥训练',
      description: '塑造完美翘臀,改善腰背不适',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 20,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 猫式伸展10次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '标准臀桥 4组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '单腿臀桥 3组 x 12次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '臀桥保持 3组 x 60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '臀部和腰部拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_wall_sit',
      title: '在家靠墙静蹲',
      description: '增强腿部耐力和膝关节稳定性',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 15,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 原地踏步2分钟',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '靠墙静蹲 5组 x 60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '单腿靠墙蹲 3组 x 30秒/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '靠墙深蹲 3组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '腿部放松按摩',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_tricep_dips',
      title: '在家凳上反屈伸',
      description: '用椅子锻炼手臂后侧三头肌',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 15,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 手臂绕环30次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '标准凳上反屈伸 4组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '单腿悬空反屈伸 3组 x 12次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '慢速反屈伸 3组 x 10次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '手臂拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_leg_raises',
      title: '在家仰卧举腿',
      description: '强化下腹肌和髋部屈肌',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 15,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 仰卧膝盖环绕20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '双腿举腿 4组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '单腿举腿 3组 x 12次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '剪刀腿 3组 x 30秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '下腹拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_calf_raises',
      title: '在家提踵训练',
      description: '塑造小腿线条,增强踝关节力量',
      category: TemplateCategory.fitness,
      priority: TaskPriority.low,
      estimatedMinutes: 15,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 踝关节转动20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '双腿提踵 5组 x 25次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '单腿提踵 4组 x 15次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '台阶提踵 3组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '小腿拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_full_body_hiit',
      title: '在家全身HIIT',
      description: '15分钟高强度燃脂,不需要器械',
      category: TemplateCategory.fitness,
      priority: TaskPriority.high,
      estimatedMinutes: 20,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 动态拉伸3分钟',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '波比跳 45秒 + 休息15秒 x 3轮',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '高抬腿 45秒 + 休息15秒 x 3轮',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '深蹲跳 45秒 + 休息15秒 x 3轮',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '登山跑 45秒 + 休息15秒 x 3轮',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '拉伸放松',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_back_workout',
      title: '在家背部训练',
      description: '徒手练背,改善圆肩驼背',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 25,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 肩胛骨激活10次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '超人式 4组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: 'Y-T-W拉伸 3组 x 10次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '俯卧划船 4组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '反向雪天使 3组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '背部拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_shoulder_workout',
      title: '在家肩部训练',
      description: '无器械练肩,打造宽厚肩膀',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 20,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 肩部绕环前后各20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '派克俯卧撑 4组 x 12次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '平板支撑转体 3组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '倒立撑(靠墙) 3组 x 8次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '肩部拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_flexibility_stretch',
      title: '在家全身拉伸',
      description: '改善柔韧性,缓解肌肉紧张',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 20,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '颈部拉伸 - 前后左右各30秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '肩部拉伸 - 交叉拉伸各30秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '胸部拉伸 - 门框拉伸60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '腰部拉伸 - 猫牛式10次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '腿部拉伸 - 前侧后侧各60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '臀部拉伸 - 鸽子式各60秒',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_tabata_4min',
      title: '在家4分钟Tabata',
      description: '超短时高效燃脂训练',
      category: TemplateCategory.fitness,
      priority: TaskPriority.high,
      estimatedMinutes: 10,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 原地慢跑2分钟',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '波比跳 20秒全力+10秒休息 x 8组',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '放松拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}home_abs_6pack',
      title: '在家腹肌雕刻',
      description: '专注腹肌训练,打造六块腹肌',
      category: TemplateCategory.fitness,
      priority: TaskPriority.high,
      estimatedMinutes: 25,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '卷腹 4组 x 20次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '反向卷腹 4组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '自行车卷腹 4组 x 30次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '平板支撑 3组 x 60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '仰卧抬腿 3组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '腹部拉伸',
          isCompleted: false,
        ),
      ],
    ),

    // ===== 需要器械的健身模板 =====
    TaskTemplate(
      id: '${_templateIdPrefix}morning_run',
      title: '晨跑训练',
      description: '早晨慢跑锻炼,提升心肺功能',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 30,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '5分钟热身拉伸',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '20分钟慢跑',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '5分钟放松拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}upper_body_training',
      title: '力量训练 - 上肢',
      description: '针对胸、肩、背、手臂的力量训练',
      category: TemplateCategory.fitness,
      priority: TaskPriority.high,
      estimatedMinutes: 60,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 5分钟有氧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '俯卧撑 4组 x 12次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '哑铃推举 4组 x 10次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '引体向上 4组 x 8次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '二头弯举 3组 x 12次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '拉伸放松',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}lower_body_training',
      title: '力量训练 - 下肢',
      description: '针对腿部和核心的力量训练',
      category: TemplateCategory.fitness,
      priority: TaskPriority.high,
      estimatedMinutes: 60,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 5分钟有氧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '深蹲 4组 x 15次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '箭步蹲 3组 x 12次/侧',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '硬拉 4组 x 10次',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '平板支撑 3组 x 60秒',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '拉伸放松',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}hiit_training',
      title: 'HIIT高强度间歇训练',
      description: '高效燃脂间歇训练',
      category: TemplateCategory.fitness,
      priority: TaskPriority.high,
      estimatedMinutes: 30,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 3分钟原地跑',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '波比跳 45秒 x 4组',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '高抬腿 45秒 x 4组',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '开合跳 45秒 x 4组',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '登山跑 45秒 x 4组',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '放松拉伸',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}yoga_practice',
      title: '瑜伽练习',
      description: '基础瑜伽体式练习',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 45,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '冥想调息 5分钟',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '拜日式 10组',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '战士式体式练习',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '平衡体式练习',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '摊尸式放松 5分钟',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}swimming_training',
      title: '游泳训练',
      description: '游泳有氧训练',
      category: TemplateCategory.fitness,
      priority: TaskPriority.medium,
      estimatedMinutes: 60,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '热身 - 慢游200米',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '自由泳 400米 x 4组',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '蛙泳 200米 x 2组',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '放松游 200米',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 烹饪美食模板 ==========
  static List<TaskTemplate> _getCookingTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}breakfast_prep',
      title: '准备早餐',
      description: '营养健康早餐准备',
      category: TemplateCategory.cooking,
      priority: TaskPriority.high,
      estimatedMinutes: 30,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '准备食材',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '煮鸡蛋/燕麦粥',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '准备水果',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '冲泡豆浆/牛奶',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}kung_pao_chicken',
      title: '中式家常菜 - 宫保鸡丁',
      description: '经典川菜宫保鸡丁',
      category: TemplateCategory.cooking,
      priority: TaskPriority.medium,
      estimatedMinutes: 45,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '鸡胸肉切丁腌制',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '准备配菜(黄瓜、花生)',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '调制宫保酱汁',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '热锅炒制',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '装盘',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}chiffon_cake',
      title: '烘焙 - 戚风蛋糕',
      description: '制作经典戚风蛋糕',
      category: TemplateCategory.cooking,
      priority: TaskPriority.low,
      estimatedMinutes: 90,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '准备材料并称重',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '分离蛋黄蛋白',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '制作蛋黄糊',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '打发蛋白',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '混合面糊',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '烤箱烘烤 150°C 60分钟',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '倒扣放凉',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}fitness_meal',
      title: '健身餐准备',
      description: '低脂高蛋白健身餐',
      category: TemplateCategory.cooking,
      priority: TaskPriority.medium,
      estimatedMinutes: 40,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '煮鸡胸肉/牛肉',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '蒸红薯/糙米饭',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '清炒西兰花',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '准备蔬菜沙拉',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '分装便当盒',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 学习教育模板 ==========
  static List<TaskTemplate> _getLearningTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}daily_word',
      title: '每天学一个单词',
      description: '每天学习并掌握一个英语单词,积少成多提升词汇量',
      category: TemplateCategory.learning,
      priority: TaskPriority.medium,
      estimatedMinutes: 15,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '查看单词发音和拼写',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '理解中英文释义',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '学习至少2个例句',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '自己造1个句子',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '记录到单词本',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}english_vocabulary',
      title: '英语单词背诵(10-20个)',
      description: '批量背诵英语单词',
      category: TemplateCategory.learning,
      priority: TaskPriority.high,
      estimatedMinutes: 30,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '复习昨日单词',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '学习20个新单词',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '例句造句练习',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '听力跟读',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}python_learning',
      title: '编程学习 - Python基础',
      description: 'Python编程基础学习',
      category: TemplateCategory.learning,
      priority: TaskPriority.high,
      estimatedMinutes: 90,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '观看教程视频',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '阅读文档资料',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '编写练习代码',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '完成课后习题',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '整理学习笔记',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}reading_plan',
      title: '阅读计划',
      description: '每日阅读打卡',
      category: TemplateCategory.learning,
      priority: TaskPriority.medium,
      estimatedMinutes: 60,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '阅读30页',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '摘抄金句',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '撰写读书笔记',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 工作学习模板 ==========
  static List<TaskTemplate> _getWorkTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}daily_standup',
      title: '每日站会',
      description: '团队每日站会同步',
      category: TemplateCategory.work,
      priority: TaskPriority.high,
      estimatedMinutes: 15,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '准备今日工作计划',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '参加站会',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '记录会议要点',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}weekly_report',
      title: '周报撰写',
      description: '撰写本周工作总结',
      category: TemplateCategory.work,
      priority: TaskPriority.high,
      estimatedMinutes: 60,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '整理本周完成事项',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '总结遇到的问题',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '规划下周计划',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '撰写周报文档',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '发送周报邮件',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}code_review',
      title: '代码审查',
      description: '审查团队成员代码',
      category: TemplateCategory.work,
      priority: TaskPriority.medium,
      estimatedMinutes: 45,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '查看Pull Request',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '检查代码规范',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '测试功能',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '提供Review意见',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 家务清洁模板 ==========
  static List<TaskTemplate> _getHomeTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}weekend_cleaning',
      title: '周末大扫除',
      description: '全屋深度清洁',
      category: TemplateCategory.home,
      priority: TaskPriority.medium,
      estimatedMinutes: 120,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '整理物品归位',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '吸尘拖地',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '擦洗厨房',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '清洁卫生间',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '换洗床单被罩',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '倒垃圾',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}laundry',
      title: '洗衣服',
      description: '衣物清洗晾晒',
      category: TemplateCategory.home,
      priority: TaskPriority.low,
      estimatedMinutes: 90,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '分类衣物',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '洗衣机清洗',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '晾晒衣物',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 健康医疗模板 ==========
  static List<TaskTemplate> _getHealthTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}health_checkup',
      title: '体检准备',
      description: '年度体检前准备',
      category: TemplateCategory.health,
      priority: TaskPriority.high,
      estimatedMinutes: 30,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '预约体检时间',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '准备体检资料',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '前一晚禁食',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}meditation',
      title: '冥想练习',
      description: '正念冥想放松',
      category: TemplateCategory.health,
      priority: TaskPriority.medium,
      estimatedMinutes: 20,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '找安静场所',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '调整坐姿',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '专注呼吸 15分钟',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 旅行规划模板 ==========
  static List<TaskTemplate> _getTravelTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}weekend_trip',
      title: '周末短途旅行',
      description: '周末2日游准备',
      category: TemplateCategory.travel,
      priority: TaskPriority.medium,
      estimatedMinutes: 90,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '预订酒店',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '规划行程路线',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '准备行李',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '检查证件',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '预订交通',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 购物清单模板 ==========
  static List<TaskTemplate> _getShoppingTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}grocery_shopping',
      title: '超市采购',
      description: '每周超市采购清单',
      category: TemplateCategory.shopping,
      priority: TaskPriority.medium,
      estimatedMinutes: 60,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '购买蔬菜水果',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '购买肉蛋奶',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '购买日用品',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '购买零食饮料',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 项目管理模板 ==========
  static List<TaskTemplate> _getProjectTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}project_kickoff',
      title: '新项目启动',
      description: '项目启动检查清单',
      category: TemplateCategory.project,
      priority: TaskPriority.critical,
      estimatedMinutes: 180,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '明确项目目标',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '组建项目团队',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '制定项目计划',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '分配任务',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '创建项目文档',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '召开启动会议',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 习惯养成模板 ==========
  static List<TaskTemplate> _getHabitTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}daily_quote',
      title: '每日名言',
      description: '每天阅读一句名人名言,汲取智慧力量 (1000句精选)',
      category: TemplateCategory.habit,
      priority: TaskPriority.medium,
      estimatedMinutes: 5,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: FamousQuotes.getQuote(now.day),
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '思考这句话的含义',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '记录自己的感悟',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}early_morning',
      title: '早起打卡',
      description: '养成早起习惯',
      category: TemplateCategory.habit,
      priority: TaskPriority.high,
      estimatedMinutes: 5,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '6:30准时起床',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '喝一杯温水',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '打卡记录',
          isCompleted: false,
        ),
      ],
    ),
    TaskTemplate(
      id: '${_templateIdPrefix}bedtime_routine',
      title: '睡前仪式',
      description: '养成规律作息',
      category: TemplateCategory.habit,
      priority: TaskPriority.high,
      estimatedMinutes: 30,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '22:00停止使用电子设备',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '洗漱',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '阅读15分钟',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '23:00上床睡觉',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 财务管理模板 ==========
  static List<TaskTemplate> _getFinanceTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}monthly_accounting',
      title: '月度记账',
      description: '每月收支记录整理',
      category: TemplateCategory.finance,
      priority: TaskPriority.medium,
      estimatedMinutes: 45,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '整理收入记录',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '整理支出记录',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '分类汇总',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '分析消费情况',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 创意设计模板 ==========
  static List<TaskTemplate> _getCreativeTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}ui_design',
      title: 'UI设计方案',
      description: 'APP界面设计',
      category: TemplateCategory.creative,
      priority: TaskPriority.high,
      estimatedMinutes: 180,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '需求分析',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '竞品分析',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '绘制线框图',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '视觉设计',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '交互设计',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '设计评审',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 社交娱乐模板 ==========
  static List<TaskTemplate> _getSocialTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}party_planning',
      title: '聚会组织',
      description: '朋友聚会准备',
      category: TemplateCategory.social,
      priority: TaskPriority.medium,
      estimatedMinutes: 120,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '确定时间地点',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '邀请好友',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '预订餐厅/场地',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '准备节目/游戏',
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ========== 维护保养模板 ==========
  static List<TaskTemplate> _getMaintenanceTemplates(DateTime now, IdGenerator idGen) => [
    TaskTemplate(
      id: '${_templateIdPrefix}car_maintenance',
      title: '汽车保养',
      description: '汽车定期保养',
      category: TemplateCategory.maintenance,
      priority: TaskPriority.high,
      estimatedMinutes: 120,
      isBuiltIn: true,
      createdAt: now,
      defaultSubtasks: [
        SubTask(
          id: idGen.generate(),
          title: '预约4S店',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '更换机油机滤',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '检查轮胎',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '检查刹车系统',
          isCompleted: false,
        ),
        SubTask(
          id: idGen.generate(),
          title: '车辆清洗',
          isCompleted: false,
        ),
      ],
    ),
  ];
}
