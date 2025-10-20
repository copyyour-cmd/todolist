import 'package:todolist/src/domain/entities/tag.dart';

abstract class TagRepository {
  Stream<List<Tag>> watchAll();

  Future<List<Tag>> findAll();

  Future<Tag?> findById(String id);

  Future<void> save(Tag tag);

  Future<void> delete(String id);

  Future<void> clear();
}
