import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class IdGenerator {
  IdGenerator({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  String generate() => _uuid.v4();
}

final idGeneratorProvider = Provider<IdGenerator>((ref) {
  return IdGenerator();
});
