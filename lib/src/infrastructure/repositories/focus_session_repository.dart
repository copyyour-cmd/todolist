import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/focus_session.dart';

class FocusSessionRepository {
  FocusSessionRepository(this._box);

  final Box<FocusSession> _box;

  static const _boxName = 'focus_sessions';

  static Future<FocusSessionRepository> create() async {
    final box = await Hive.openBox<FocusSession>(_boxName);
    return FocusSessionRepository(box);
  }

  Future<void> save(FocusSession session) async {
    await _box.put(session.id, session);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  FocusSession? getById(String id) {
    return _box.get(id);
  }

  List<FocusSession> getAll() {
    return _box.values.toList();
  }

  Stream<BoxEvent> watch() {
    return _box.watch();
  }

  Stream<List<FocusSession>> watchAll() {
    return watch().map((_) => getAll());
  }

  List<FocusSession> getCompletedSessions() {
    return _box.values.where((session) => session.isCompleted).toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  List<FocusSession> getSessionsForTask(String taskId) {
    return _box.values.where((session) => session.taskId == taskId).toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  int getTotalFocusMinutes() {
    return _box.values
        .where((session) => session.isCompleted)
        .fold(0, (sum, session) => sum + session.durationMinutes);
  }

  int getTotalFocusMinutesToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return _box.values
        .where((session) =>
            session.isCompleted &&
            session.startedAt.isAfter(today) &&
            session.startedAt.isBefore(tomorrow))
        .fold(0, (sum, session) => sum + session.durationMinutes);
  }
}
