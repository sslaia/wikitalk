import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wikimedia_core/wikimedia_core.dart';

import '../../core/theme/wiki_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/channels_provider.dart';
import '../providers/settings_provider.dart';

/// Settings screen allowing users to customize language, project, base target page,
/// subpages/channels, theme, and Wikimedia account.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _customLangController = TextEditingController();
  late final TextEditingController _baseTitleController;

  static const List<Map<String, String>> _popularLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'id', 'name': 'Bahasa Indonesia'},
    {'code': 'jv', 'name': 'Basa Jawa'},
    {'code': 'su', 'name': 'Basa Sunda'},
    {'code': 'ban', 'name': 'Basa Bali'},
    {'code': 'min', 'name': 'Bahaso Minangkabau'},
    {'code': 'nia', 'name': 'Bahasa Nias'},
    {'code': 'th', 'name': 'ไทย (Thai)'},
    {'code': 'tet', 'name': 'Tetun (Timorese)'},
    {'code': 'ms', 'name': 'Bahasa Melayu'},
    {'code': 'my', 'name': 'မြန်မာဘာသာ (Burmese)'},
    {'code': 'km', 'name': 'ភាសាខ្មែរ (Khmer)'},
    {'code': 'zh', 'name': '中文 (Chinese)'},
    {'code': 'ja', 'name': '日本語 (Japanese)'},
    {'code': 'ko', 'name': '한국어 (Korean)'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'es', 'name': 'Español'},
  ];

  @override
  void initState() {
    super.initState();
    _baseTitleController = TextEditingController(
      text: ref.read(settingsProvider).basePageTitle,
    );
  }

  @override
  void dispose() {
    _customLangController.dispose();
    _baseTitleController.dispose();
    super.dispose();
  }

  IconData _getChannelIcon(String? iconName) {
    switch (iconName) {
      case 'gavel':
        return Icons.gavel_rounded;
      case 'lightbulb':
        return Icons.lightbulb_outline_rounded;
      case 'build':
        return Icons.build_rounded;
      case 'translate':
        return Icons.translate_rounded;
      case 'campaign':
        return Icons.campaign_rounded;
      case 'tea':
      case 'coffee':
        return Icons.local_cafe_rounded;
      case 'science':
        return Icons.science_rounded;
      default:
        return Icons.forum_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final settings = ref.watch(settingsProvider);
    final auth = ref.watch(authProvider);
    final channelsAsync = ref.watch(channelsProvider);

    // Keep base title controller in sync when settings change
    ref.listen<SettingsState>(settingsProvider, (previous, next) {
      if (previous?.basePageTitle != next.basePageTitle) {
        _baseTitleController.text = next.basePageTitle;
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section 1: Target Wikimedia Project & Language
          _sectionHeader(l10n.wikimediaTargetHeader, isDark),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Type Selector
                  Text(
                    l10n.wikimediaProject,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ProjectType>(
                    initialValue: settings.project,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: ProjectType.values.map((p) {
                      final name =
                          p.name[0].toUpperCase() + p.name.substring(1);
                      return DropdownMenuItem(value: p, child: Text(name));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(settingsProvider.notifier).setProject(val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Language Code Selector
                  Text(
                    l10n.languageEdition,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue:
                        _popularLanguages.any(
                          (l) => l['code'] == settings.langCode,
                        )
                        ? settings.langCode
                        : 'custom',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      ..._popularLanguages.map((l) {
                        return DropdownMenuItem(
                          value: l['code'],
                          child: Text('${l['name']} (${l['code']})'),
                        );
                      }),
                      DropdownMenuItem(
                        value: 'custom',
                        child: Text('${l10n.customLanguage}...'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val == 'custom') {
                        _showCustomLangDialog(context, l10n);
                      } else if (val != null) {
                        ref.read(settingsProvider.notifier).setLanguage(val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.public,
                        size: 16,
                        color: WikiTheme.wikiBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.targetDomain(settings.target.domain),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? WikiTheme.wikiBlueDark
                              : WikiTheme.wikiBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 2: Discussion Page Title / Village Pump
          _sectionHeader(l10n.targetDiscussionPageTitleHeader, isDark),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mainDiscussionBoardTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.baseDiscussionPageDesc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? WikiTheme.darkTextSecondary
                          : WikiTheme.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _baseTitleController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            isDense: true,
                            hintText: l10n.basePageTitleHint,
                          ),
                          onSubmitted: (val) {
                            if (val.trim().isNotEmpty) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .setBasePageTitle(val);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.targetPageSetSnackBar(val),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.check, size: 20),
                        tooltip: l10n.applyTargetPageTitle,
                        onPressed: () {
                          final val = _baseTitleController.text.trim();
                          if (val.isNotEmpty) {
                            ref
                                .read(settingsProvider.notifier)
                                .setBasePageTitle(val);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.targetPageSetSnackBar(val)),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton.outlined(
                        icon: const Icon(Icons.restore_rounded, size: 20),
                        tooltip: l10n.resetToDefault,
                        onPressed: () {
                          ref
                              .read(settingsProvider.notifier)
                              .resetBasePageTitleToDefault();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.resetToDefaultSnackBar),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 3: Subpages / Channels Configuration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader(l10n.channelsSubpagesHeader, isDark),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: TextButton.icon(
                  icon: const Icon(Icons.restore_rounded, size: 14),
                  label: Text(
                    l10n.resetDefaults,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    ref.read(channelsProvider.notifier).resetToDefaults();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.resetChannelsSnackBar)),
                    );
                  },
                ),
              ),
            ],
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.channelsSubpagesDesc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? WikiTheme.darkTextSecondary
                          : WikiTheme.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  channelsAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (err, _) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${l10n.error}: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    data: (channels) {
                      if (channels.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              l10n.noChannelsConfiguredFull,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        );
                      }

                      return Material(
                        type: MaterialType.transparency,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: channels.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (ctx, index) {
                            final ch = channels[index];
                            return ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: isDark
                                    ? WikiTheme.darkSurfaceVariant
                                    : WikiTheme.lightSurfaceVariant,
                                child: Icon(
                                  _getChannelIcon(ch.iconName),
                                  size: 16,
                                  color: isDark
                                      ? WikiTheme.wikiBlueDark
                                      : WikiTheme.wikiBlue,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      ch.getLocalizedDisplayName(l10n),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  if (ch.isCustom) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.blueGrey.shade800
                                            : Colors.blueGrey.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        l10n.customBadge,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Text(
                                ch.pageTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? WikiTheme.darkTextSecondary
                                      : WikiTheme.lightTextSecondary,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                                color: Colors.redAccent,
                                tooltip: l10n.removeChannel,
                                onPressed: () {
                                  ref
                                      .read(channelsProvider.notifier)
                                      .deleteChannel(ch.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.removedChannelSnackBar(
                                          ch.displayName,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(l10n.addSubpageOrChannel),
                    onPressed: () => _showAddChannelDialog(
                      context,
                      settings.basePageTitle,
                      l10n,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 4: Appearance
          _sectionHeader(l10n.appearanceHeader, isDark),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.themeMode,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text(l10n.themeSystem),
                        icon: const Icon(
                          Icons.settings_suggest_rounded,
                          size: 16,
                        ),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text(l10n.themeLight),
                        icon: const Icon(Icons.light_mode_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text(l10n.themeDark),
                        icon: const Icon(Icons.dark_mode_rounded, size: 16),
                      ),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (val) {
                      if (val.isNotEmpty) {
                        ref
                            .read(settingsProvider.notifier)
                            .setThemeMode(val.first);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 5: Account
          _sectionHeader(l10n.wikimediaAccountHeader, isDark),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: auth.isLoggedIn
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: WikiTheme.wikiBlue,
                              radius: 18,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    auth.username ?? l10n.loggedIn,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    l10n.connectedViaOAuth,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.logout, size: 16),
                          label: Text(l10n.logOut),
                          onPressed: () =>
                              ref.read(authProvider.notifier).logout(),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.guestNotice,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          icon: const Icon(Icons.login_rounded, size: 16),
                          label: Text(l10n.loginWithWikimedia),
                          style: FilledButton.styleFrom(
                            backgroundColor: WikiTheme.wikiBlue,
                          ),
                          onPressed: () =>
                              ref.read(authProvider.notifier).login(context),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 6: About & Compliance
          _sectionHeader(l10n.aboutComplianceHeader, isDark),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.aboutAppTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.aboutAppDescription,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: isDark
              ? WikiTheme.darkTextSecondary
              : WikiTheme.lightTextSecondary,
        ),
      ),
    );
  }

  void _showAddChannelDialog(
    BuildContext context,
    String baseTitle,
    AppLocalizations l10n,
  ) {
    final titleController = TextEditingController(
      text: '$baseTitle (${l10n.subpageLabel})',
    );
    final nameController = TextEditingController();
    final descController = TextEditingController();
    String selectedIcon = 'forum';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.addDiscussionChannelTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.fullOnWikiPageTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: l10n.wikiPageTitleHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.channelDisplayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: l10n.channelDisplayNameHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.channelDescriptionOptional,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    hintText: l10n.channelDescriptionHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.channelIconLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        'forum',
                        'coffee',
                        'gavel',
                        'lightbulb',
                        'build',
                        'translate',
                        'campaign',
                        'science',
                      ].map((iconKey) {
                        final isSel = selectedIcon == iconKey;
                        return ChoiceChip(
                          selected: isSel,
                          label: Icon(_getChannelIcon(iconKey), size: 18),
                          onSelected: (_) {
                            setDialogState(() => selectedIcon = iconKey);
                          },
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final pageTitle = titleController.text.trim();
                var displayName = nameController.text.trim();
                if (displayName.isEmpty) {
                  displayName = pageTitle
                      .replaceAll(RegExp(r'^[^:]+:'), '')
                      .replaceAll('_', ' ');
                }
                if (pageTitle.isNotEmpty) {
                  ref
                      .read(channelsProvider.notifier)
                      .addCustomChannel(
                        pageTitle: pageTitle,
                        displayName: displayName,
                        description: descController.text.trim(),
                        iconName: selectedIcon,
                      );
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.addedChannelSnackBar(displayName)),
                    ),
                  );
                }
              },
              child: Text(l10n.addChannel),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomLangDialog(BuildContext context, AppLocalizations l10n) {
    _customLangController.text = ref.read(settingsProvider).langCode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customLanguageCodeDialogTitle),
        content: TextField(
          controller: _customLangController,
          decoration: InputDecoration(
            labelText: l10n.isoLanguageCode,
            hintText: l10n.customLanguageHint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final code = _customLangController.text.trim();
              if (code.isNotEmpty) {
                ref.read(settingsProvider.notifier).setLanguage(code);
                Navigator.of(ctx).pop();
              }
            },
            child: Text(l10n.apply),
          ),
        ],
      ),
    );
  }
}
