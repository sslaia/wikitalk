import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wikimedia_core/wikimedia_core.dart';
import '../../core/theme/wiki_theme.dart';
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
    {'code': 'id', 'name': 'Bahasa Indonesia'},
    {'code': 'en', 'name': 'English'},
    {'code': 'jv', 'name': 'Basa Jawa'},
    {'code': 'nia', 'name': 'Li Niha (Nias)'},
    {'code': 'su', 'name': 'Basa Sunda'},
    {'code': 'min', 'name': 'Bahaso Minangkabau'},
    {'code': 'ban', 'name': 'Basa Bali'},
    {'code': 'ms', 'name': 'Bahasa Melayu'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'ja', 'name': '日本語'},
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
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section 1: Target Wikimedia Project & Language
          _sectionHeader('WIKIMEDIA TARGET', isDark),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Type Selector
                  const Text(
                    'Wikimedia Project',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ProjectType>(
                    initialValue: settings.project,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: ProjectType.values.map((p) {
                      final name = p.name[0].toUpperCase() + p.name.substring(1);
                      return DropdownMenuItem(
                        value: p,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(settingsProvider.notifier).setProject(val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Language Code Selector
                  const Text(
                    'Language Edition',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _popularLanguages.any((l) => l['code'] == settings.langCode)
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
                      const DropdownMenuItem(
                        value: 'custom',
                        child: Text('Custom Language Code...'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val == 'custom') {
                        _showCustomLangDialog(context);
                      } else if (val != null) {
                        ref.read(settingsProvider.notifier).setLanguage(val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.public, size: 16, color: WikiTheme.wikiBlue),
                      const SizedBox(width: 6),
                      Text(
                        'Target Domain: ${settings.target.domain}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? WikiTheme.wikiBlueDark : WikiTheme.wikiBlue,
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
          _sectionHeader('TARGET DISCUSSION PAGE TITLE', isDark),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Main Discussion Board Title',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Village pump, teahouse, or discussion portal name in this language/project (e.g. "Wikikamus:Monganga afo" or "Wikipedia:Warung Kopi").',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? WikiTheme.darkTextSecondary : WikiTheme.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _baseTitleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            hintText: 'e.g. Wikipedia:Warung Kopi',
                          ),
                          onSubmitted: (val) {
                            if (val.trim().isNotEmpty) {
                              ref.read(settingsProvider.notifier).setBasePageTitle(val);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Target page set to "$val"')),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.check, size: 20),
                        tooltip: 'Apply Target Page Title',
                        onPressed: () {
                          final val = _baseTitleController.text.trim();
                          if (val.isNotEmpty) {
                            ref.read(settingsProvider.notifier).setBasePageTitle(val);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Target page set to "$val"')),
                            );
                          }
                        },
                      ),
                      IconButton.outlined(
                        icon: const Icon(Icons.restore_rounded, size: 20),
                        tooltip: 'Reset to Default',
                        onPressed: () {
                          ref.read(settingsProvider.notifier).resetBasePageTitleToDefault();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reset to project default page title')),
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
              _sectionHeader('CHANNELS & SUBPAGES', isDark),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: TextButton.icon(
                  icon: const Icon(Icons.restore_rounded, size: 14),
                  label: const Text('Reset Defaults', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    ref.read(channelsProvider.notifier).resetToDefaults();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reset channels to project defaults')),
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
                    'Configure subpages or dedicated discussion pages that appear as channels in the app.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? WikiTheme.darkTextSecondary : WikiTheme.lightTextSecondary,
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
                      child: Text('Error loading channels: $err', style: const TextStyle(color: Colors.red)),
                    ),
                    data: (channels) {
                      if (channels.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              'No channels configured.\nTap below to add a subpage or reset to defaults.',
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
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (ctx, index) {
                            final ch = channels[index];
                            return ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: isDark
                                    ? WikiTheme.darkSurfaceVariant
                                    : WikiTheme.lightSurfaceVariant,
                                child: Icon(
                                  _getChannelIcon(ch.iconName),
                                  size: 16,
                                  color: isDark ? WikiTheme.wikiBlueDark : WikiTheme.wikiBlue,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      ch.displayName,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                  ),
                                  if (ch.isCustom) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Custom',
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
                                  color: isDark ? WikiTheme.darkTextSecondary : WikiTheme.lightTextSecondary,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18),
                                color: Colors.redAccent,
                                tooltip: 'Remove channel',
                                onPressed: () {
                                  ref.read(channelsProvider.notifier).deleteChannel(ch.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Removed "${ch.displayName}"')),
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
                    label: const Text('Add Subpage / Channel'),
                    onPressed: () => _showAddChannelDialog(context, settings.basePageTitle),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 4: Appearance
          _sectionHeader('APPEARANCE', isDark),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Theme Mode',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(Icons.settings_suggest_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode_rounded, size: 16),
                      ),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (val) {
                      if (val.isNotEmpty) {
                        ref.read(settingsProvider.notifier).setThemeMode(val.first);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 5: Account
          _sectionHeader('WIKIMEDIA ACCOUNT', isDark),
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
                                    auth.username ?? 'Logged In User',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Text(
                                    'Connected via Wikimedia OAuth 2.0',
                                    style: TextStyle(
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
                          label: const Text('Log out'),
                          onPressed: () => ref.read(authProvider.notifier).logout(),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'You can browse public discussions freely as a guest. To post replies or start new topics, log in with your Wikimedia account.',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          icon: const Icon(Icons.login_rounded, size: 16),
                          label: const Text('Log in with Wikimedia'),
                          style: FilledButton.styleFrom(
                            backgroundColor: WikiTheme.wikiBlue,
                          ),
                          onPressed: () => ref.read(authProvider.notifier).login(context),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 6: About & Compliance
          _sectionHeader('ABOUT & PLAY CONSOLE COMPLIANCE', isDark),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wiki Talk v1.0.0',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Collaborative discussion reader and editor for Wikimedia community talk pages and village pumps.\n\n'
                    'Classification: Tools / Reference & Productivity.\n'
                    'Storage: All discussions are public on-wiki wikitext. Offline cache is stored in local device SQLite.\n'
                    'Permissions: Strictly Internet for MediaWiki API.',
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
          color: isDark ? WikiTheme.darkTextSecondary : WikiTheme.lightTextSecondary,
        ),
      ),
    );
  }

  void _showAddChannelDialog(BuildContext context, String baseTitle) {
    final titleController = TextEditingController(text: '$baseTitle (Subpage)');
    final nameController = TextEditingController();
    final descController = TextEditingController();
    String selectedIcon = 'forum';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Discussion Channel / Subpage'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Full On-Wiki Page Title',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Wikipedia:Warung Kopi (Usulan)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Channel Display Name',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Usulan',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Description (Optional)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Usulan ide baru dari komunitas',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Icon',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
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
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final pageTitle = titleController.text.trim();
                var displayName = nameController.text.trim();
                if (displayName.isEmpty) {
                  displayName = pageTitle.replaceAll(RegExp(r'^[^:]+:'), '').replaceAll('_', ' ');
                }
                if (pageTitle.isNotEmpty) {
                  ref.read(channelsProvider.notifier).addCustomChannel(
                        pageTitle: pageTitle,
                        displayName: displayName,
                        description: descController.text.trim(),
                        iconName: selectedIcon,
                      );
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added channel "$displayName"')),
                  );
                }
              },
              child: const Text('Add Channel'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomLangDialog(BuildContext context) {
    _customLangController.text = ref.read(settingsProvider).langCode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom Language Code'),
        content: TextField(
          controller: _customLangController,
          decoration: const InputDecoration(
            labelText: 'ISO Language Code',
            hintText: 'e.g. bar, bcl, zh-min-nan',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final code = _customLangController.text.trim();
              if (code.isNotEmpty) {
                ref.read(settingsProvider.notifier).setLanguage(code);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
