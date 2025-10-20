import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/nlp/application/natural_language_parser.dart';

final naturalLanguageParserProvider = Provider<NaturalLanguageParser>((ref) {
  return NaturalLanguageParser();
});
