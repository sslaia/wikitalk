import 'package:wikimedia_core/wikimedia_core.dart';

/// Target Wikimedia project and language configuration.
class WikiProjectTarget {
  final String langCode;
  final ProjectType project;

  const WikiProjectTarget({
    required this.langCode,
    required this.project,
  });

  /// Domain for this target, e.g., 'id.wikipedia.org' or 'commons.wikimedia.org'.
  String get domain {
    final cleanLang = langCode.trim().toLowerCase();
    switch (project) {
      case ProjectType.wikipedia:
        return '$cleanLang.wikipedia.org';
      case ProjectType.wiktionary:
        return '$cleanLang.wiktionary.org';
      case ProjectType.wikibooks:
        return '$cleanLang.wikibooks.org';
    }
  }

  /// Display title for the target, e.g. "Wikipedia (id)"
  String get displayLabel {
    final projName = project.name[0].toUpperCase() + project.name.substring(1);
    return '$projName (${langCode.toUpperCase()})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiProjectTarget &&
          runtimeType == other.runtimeType &&
          langCode.toLowerCase() == other.langCode.toLowerCase() &&
          project == other.project;

  @override
  int get hashCode => Object.hash(langCode.toLowerCase(), project);
}
