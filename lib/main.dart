import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/wiki_theme.dart';
import 'data/database/wiki_talk_database.dart';
import 'presentation/providers/database_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/responsive_home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent services
  final prefs = await SharedPreferences.getInstance();
  final db = await WikiTalkDatabase.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWith((ref) => db),
      ],
      child: const WikiTalkApp(),
    ),
  );
}

class WikiTalkApp extends ConsumerWidget {
  const WikiTalkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Wiki Talk',
      debugShowCheckedModeBanner: false,
      theme: WikiTheme.lightTheme(),
      darkTheme: WikiTheme.darkTheme(),
      themeMode: settings.themeMode,
      home: const ResponsiveHomeShell(),
    );
  }
}
