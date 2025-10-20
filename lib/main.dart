import 'package:todolist/src/app/app.dart';
import 'package:todolist/src/bootstrap.dart';

Future<void> main() async {
  await bootstrap((_) async => const App());
}
