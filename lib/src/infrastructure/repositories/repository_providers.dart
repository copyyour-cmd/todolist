import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/domain/repositories/app_settings_repository.dart';
import 'package:todolist/src/domain/repositories/habit_repository.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/domain/repositories/tag_repository.dart';
import 'package:todolist/src/domain/repositories/task_list_repository.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/domain/repositories/task_template_repository.dart';
import 'package:todolist/src/domain/repositories/widget_config_repository.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
AppSettingsRepository appSettingsRepository(AppSettingsRepositoryRef ref) {
  throw UnimplementedError('AppSettingsRepository provider not overridden');
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(TaskRepositoryRef ref) {
  throw UnimplementedError('TaskRepository provider not overridden');
}

@Riverpod(keepAlive: true)
TaskListRepository taskListRepository(TaskListRepositoryRef ref) {
  throw UnimplementedError('TaskListRepository provider not overridden');
}

@Riverpod(keepAlive: true)
TagRepository tagRepository(TagRepositoryRef ref) {
  throw UnimplementedError('TagRepository provider not overridden');
}

@Riverpod(keepAlive: true)
TaskTemplateRepository taskTemplateRepository(TaskTemplateRepositoryRef ref) {
  throw UnimplementedError('TaskTemplateRepository provider not overridden');
}

@Riverpod(keepAlive: true)
HabitRepository habitRepository(HabitRepositoryRef ref) {
  throw UnimplementedError('HabitRepository provider not overridden');
}

@Riverpod(keepAlive: true)
WidgetConfigRepository widgetConfigRepository(WidgetConfigRepositoryRef ref) {
  throw UnimplementedError('WidgetConfigRepository provider not overridden');
}

@Riverpod(keepAlive: true)
NoteRepository noteRepository(NoteRepositoryRef ref) {
  throw UnimplementedError('NoteRepository provider not overridden');
}

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('SharedPreferences provider not overridden');
}
