import 'package:todolist/src/domain/entities/task_template.dart';

abstract class TaskTemplateRepository {
  Stream<List<TaskTemplate>> watchAll();

  Stream<TaskTemplate?> watchById(String id);

  Future<List<TaskTemplate>> getAll();

  Future<List<TaskTemplate>> getByCategory(TemplateCategory category);

  Future<TaskTemplate?> getById(String id);

  Future<void> save(TaskTemplate template);

  Future<void> saveAll(Iterable<TaskTemplate> templates);

  Future<void> delete(String id);

  Future<void> incrementUsageCount(String id);

  Future<void> initializeBuiltInTemplates();
}
