import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/src/features/home/application/home_tasks_provider.dart';
import 'package:todolist/src/features/home/presentation/home_page.dart';

void main() {
  testWidgets('Home page shows empty state when no tasks', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayTasksProvider.overrideWith(
            (ref) => Stream.value(const []),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Nothing planned yet'), findsOneWidget);
  });
}
