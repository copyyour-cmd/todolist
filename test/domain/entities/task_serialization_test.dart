import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/src/domain/entities/attachment.dart';
import 'package:todolist/src/domain/entities/sub_task.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';

void main() {
  group('Domain entity serialization', () {
    final now = DateTime.utc(2025, 1, 1, 8);

    test('Task round-trips through JSON', () {
      final subTask = SubTask(
        id: 'sub-1',
        title: 'Draft outline',
        isCompleted: true,
        completedAt: now,
      );
      final attachment = Attachment(
        id: 'att-1',
        type: AttachmentType.file,
        filePath: '/path/to/deck.pdf',
        fileName: 'deck.pdf',
        fileSize: 1024,
        createdAt: now,
      );
      final task = Task(
        id: 'task-1',
        title: 'Prepare kickoff deck',
        notes: 'Include roadmap highlights',
        listId: 'list-1',
        tagIds: const ['tag-1', 'tag-2'],
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        dueAt: now.add(const Duration(hours: 4)),
        remindAt: now.add(const Duration(hours: 2)),
        subtasks: [subTask],
        attachments: [attachment],
        createdAt: now,
        updatedAt: now,
        version: 3,
      );

      final encoded = task.toJson();
      final decoded = Task.fromJson(encoded);

      expect(decoded, equals(task));
    });

    test('TaskList round-trips through JSON', () {
      final list = TaskList(
        id: 'list-1',
        name: 'Planning',
        sortOrder: 2,
        iconName: 'calendar_today',
        colorHex: '#F97316',
        createdAt: now,
        updatedAt: now,
      );

      final encoded = list.toJson();
      final decoded = TaskList.fromJson(encoded);

      expect(decoded, equals(list));
    });

    test('Tag round-trips through JSON', () {
      final tag = Tag(
        id: 'tag-1',
        name: 'Focus',
        colorHex: '#FFAA33',
        createdAt: now,
        updatedAt: now,
      );

      final encoded = tag.toJson();
      final decoded = Tag.fromJson(encoded);

      expect(decoded, equals(tag));
    });
  });
}
