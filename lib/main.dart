import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/locale_utils.dart';
import 'core/theme/wiki_theme.dart';
import 'data/database/wiki_talk_database.dart';
import 'l10n/generated/app_localizations.dart';
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
    final appLocale = resolveAppLocale(settings.langCode);

    return MaterialApp(
      title: 'Wiki Talk',
      onGenerateTitle: (context) => AppLocalizations.of(context)?.appTitle ?? 'Wiki Talk',
      debugShowCheckedModeBanner: false,
      theme: WikiTheme.lightTheme(),
      darkTheme: WikiTheme.darkTheme(),
      themeMode: settings.themeMode,
      locale: appLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ResponsiveHomeShell(),
    );
  }
}
