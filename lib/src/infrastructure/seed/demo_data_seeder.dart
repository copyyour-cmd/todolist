import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/domain/repositories/tag_repository.dart';
import 'package:todolist/src/domain/repositories/task_list_repository.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';

class DemoDataSeeder {
  DemoDataSeeder({
    required this.taskRepository,
    required this.taskListRepository,
    required this.tagRepository,
    required this.idGenerator,
    this.isEnabled = true,
  });

  final TaskRepository taskRepository;
  final TaskListRepository taskListRepository;
  final TagRepository tagRepository;
  final IdGenerator idGenerator;
  final bool isEnabled;

  Future<void> seedIfEmpty() async {
    if (!isEnabled) {
      return;
    }

    final existingLists = await taskListRepository.findAll();
    if (existingLists.isNotEmpty) {
      return;
    }

    final now = DateTime.now();
    final inboxId = idGenerator.generate();
    final planningId = idGenerator.generate();
    final today = DateTime(now.year, now.month, now.day, 9);

    final inbox = TaskList(
      id: inboxId,
      name: '收件箱',
      iconName: 'inbox',
      createdAt: now,
      updatedAt: now,
      isDefault: true,
    );

    final planning = TaskList(
      id: planningId,
      name: '计划',
      sortOrder: 1,
      iconName: 'calendar_today',
      colorHex: '#F97316',
      createdAt: now,
      updatedAt: now,
    );

    await taskListRepository.save(inbox);
    await taskListRepository.save(planning);

    final focusTag = Tag(
      id: idGenerator.generate(),
      name: '专注',
      colorHex: '#4C83FB',
      createdAt: now,
      updatedAt: now,
    );

    final personalTag = Tag(
      id: idGenerator.generate(),
      name: '个人',
      colorHex: '#10B981',
      createdAt: now,
      updatedAt: now,
    );

    await tagRepository.save(focusTag);
    await tagRepository.save(personalTag);

    final tasks = [
      Task(
        id: idGenerator.generate(),
        title: '规划本周重点',
        notes: '回顾目标，并选择三个最重要的成果。',
        listId: planningId,
        tagIds: [focusTag.id],
        priority: TaskPriority.high,
        dueAt: today.add(const Duration(hours: 1)),
        remindAt: today,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: idGenerator.generate(),
        title: '预约健身时间',
        listId: inboxId,
        tagIds: [personalTag.id],
        priority: TaskPriority.medium,
        dueAt: today.add(const Duration(hours: 5)),
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: idGenerator.generate(),
        title: '准备产品演示',
        notes: '整理关键讲解要点，并收集演示资料。',
        listId: planningId,
        tagIds: [focusTag.id],
        priority: TaskPriority.critical,
        dueAt: today.add(const Duration(hours: 3)),
        createdAt: now,
        updatedAt: now,
      ),
    ];

    await taskRepository.saveAll(tasks);
  }
}
