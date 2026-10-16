import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikimedia_core/wikimedia_core.dart';
import '../../domain/models/wiki_project_target.dart';

class SettingsState {
  final String langCode;
  final ProjectType project;
  final ThemeMode themeMode;
  final String basePageTitle;

  const SettingsState({
    this.langCode = 'en',
    this.project = ProjectType.wikipedia,
    this.themeMode = ThemeMode.system,
    this.basePageTitle = 'Wikipedia:Village pump',
  });

  WikiProjectTarget get target => WikiProjectTarget(
        langCode: langCode,
        project: project,
      );

  SettingsState copyWith({
    String? langCode,
    ProjectType? project,
    ThemeMode? themeMode,
    String? basePageTitle,
  }) {
    return SettingsState(
      langCode: langCode ?? this.langCode,
      project: project ?? this.project,
      themeMode: themeMode ?? this.themeMode,
      basePageTitle: basePageTitle ?? this.basePageTitle,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(const SettingsState()) {
    _loadSettings();
  }

  static String _baseTitleKey(String lang, ProjectType proj) =>
      'wiki_talk_base_title_${lang.toLowerCase()}_${proj.name.toLowerCase()}';

  static String getDefaultBasePageTitle(String langCode, ProjectType project) {
    final clean = langCode.trim().toLowerCase();
    switch (clean) {
      case 'id':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:Warung Kopi';
          case ProjectType.wiktionary:
            return 'Wikikamus:Warung Kopi';
          case ProjectType.wikibooks:
            return 'Wikibooks:Warung Kopi';
        }
      case 'th':
        switch (project) {
          case ProjectType.wikipedia:
            return 'วิกิพีเดีย:สภากาแฟ';
          case ProjectType.wiktionary:
            return 'วิกิพจนานุกรม:สภากาแฟ';
          case ProjectType.wikibooks:
            return 'วิกิตำรา:สภากาแฟ';
        }
      case 'vi':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:Thảo luận';
          case ProjectType.wiktionary:
            return 'Wiktionary:Bàn thảo luận';
          case ProjectType.wikibooks:
            return 'Wikibooks:Thảo luận';
        }
      case 'tet':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipédia:Kafe';
          case ProjectType.wiktionary:
            return 'Wikisionáriu:Kafe';
          case ProjectType.wikibooks:
            return 'Wikilivru:Kafe';
        }
      case 'tl':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:Kapihan';
          case ProjectType.wiktionary:
            return 'Wiksiyonaryo:Kapihan';
          case ProjectType.wikibooks:
            return 'Wikibooks:Kapihan';
        }
      case 'ms':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:Kedai Kopi';
          case ProjectType.wiktionary:
            return 'Wikikamus:Kedai Kopi';
          case ProjectType.wikibooks:
            return 'Wikibooks:Kedai Kopi';
        }
      case 'my':
        switch (project) {
          case ProjectType.wikipedia:
            return 'ဝီကီပီးဒီးယား:လက်ဖက်ရည်ဆိုင်';
          case ProjectType.wiktionary:
            return 'ဝစ်ရှင်နရီ:လက်ဖက်ရည်ဆိုင်';
          case ProjectType.wikibooks:
            return 'ဝီကီစာအုပ်:လက်ဖက်ရည်ဆိုင်';
        }
      case 'km':
        switch (project) {
          case ProjectType.wikipedia:
            return 'វិគីភីឌា:សាលាស្រុក';
          case ProjectType.wiktionary:
            return 'វិគីវចនានុក្រម:សាលាស្រុក';
          case ProjectType.wikibooks:
            return 'វិគីសៀវភៅ:សាលាស្រុក';
        }
      case 'zh':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:互助客栈';
          case ProjectType.wiktionary:
            return 'Wiktionary:互助客栈';
          case ProjectType.wikibooks:
            return 'Wikibooks:互助客栈';
        }
      case 'ja':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:井戸端';
          case ProjectType.wiktionary:
            return 'Wiktionary:お茶場';
          case ProjectType.wikibooks:
            return 'Wikibooks:談話室';
        }
      case 'ko':
        switch (project) {
          case ProjectType.wikipedia:
            return '위키백과:사랑방';
          case ProjectType.wiktionary:
            return '위키낱말사전:사랑방';
          case ProjectType.wikibooks:
            return '위키책:사랑방';
        }
      case 'nia':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:Monganga afo';
          case ProjectType.wiktionary:
            return 'Wikikamus:Monganga afo';
          case ProjectType.wikibooks:
            return 'Wikibooks:Monganga afo';
        }
      case 'jv':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:Angkringan';
          case ProjectType.wiktionary:
            return 'Wikisastra:Angkringan';
          case ProjectType.wikibooks:
            return 'Wikibooks:Angkringan';
        }
      case 'en':
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:Village pump';
          case ProjectType.wiktionary:
            return 'Wiktionary:Beer parlour';
          case ProjectType.wikibooks:
            return 'Wikibooks:Staff lounge';
        }
      default:
        switch (project) {
          case ProjectType.wikipedia:
            return 'Wikipedia:Village pump';
          case ProjectType.wiktionary:
            return 'Wiktionary:Village pump';
          case ProjectType.wikibooks:
            return 'Wikibooks:Staff lounge';
        }
    }
  }

  void _loadSettings() {
    final lang = _prefs.getString('wiki_talk_lang') ?? 'en';
    final projIndex = _prefs.getInt('wiki_talk_proj') ?? 0;
    final themeIndex = _prefs.getInt('wiki_talk_theme') ?? 0;

    final project = projIndex < ProjectType.values.length
        ? ProjectType.values[projIndex]
        : ProjectType.wikipedia;

    final theme = themeIndex == 1
        ? ThemeMode.light
        : themeIndex == 2
            ? ThemeMode.dark
            : ThemeMode.system;

    final baseTitle = _prefs.getString(_baseTitleKey(lang, project)) ??
        getDefaultBasePageTitle(lang, project);

    state = SettingsState(
      langCode: lang,
      project: project,
      themeMode: theme,
      basePageTitle: baseTitle,
    );
  }

  Future<void> setLanguage(String lang) async {
    final clean = lang.trim().toLowerCase();
    if (clean.isEmpty) return;
    await _prefs.setString('wiki_talk_lang', clean);

    final title = _prefs.getString(_baseTitleKey(clean, state.project)) ??
        getDefaultBasePageTitle(clean, state.project);

    state = state.copyWith(langCode: clean, basePageTitle: title);
  }

  Future<void> setProject(ProjectType project) async {
    await _prefs.setInt('wiki_talk_proj', project.index);

    final title = _prefs.getString(_baseTitleKey(state.langCode, project)) ??
        getDefaultBasePageTitle(state.langCode, project);

    state = state.copyWith(project: project, basePageTitle: title);
  }

  Future<void> setBasePageTitle(String title) async {
    final clean = title.trim();
    if (clean.isEmpty) return;
    await _prefs.setString(_baseTitleKey(state.langCode, state.project), clean);
    state = state.copyWith(basePageTitle: clean);
  }

  Future<void> resetBasePageTitleToDefault() async {
    final defaultTitle = getDefaultBasePageTitle(state.langCode, state.project);
    await _prefs.remove(_baseTitleKey(state.langCode, state.project));
    state = state.copyWith(basePageTitle: defaultTitle);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final index = mode == ThemeMode.light
        ? 1
        : mode == ThemeMode.dark
            ? 2
            : 0;
    await _prefs.setInt('wiki_talk_theme', index);
    state = state.copyWith(themeMode: mode);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize sharedPreferences in main()');
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});
