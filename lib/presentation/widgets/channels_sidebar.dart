import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/wiki_theme.dart';
import '../../domain/models/discussion_channel.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/channels_provider.dart';
import '../providers/settings_provider.dart';

/// Navigation Sidebar or Drawer for switching between discussion channels/subpages.
class ChannelsSidebar extends ConsumerWidget {
  final VoidCallback? onSettingsTap;
  final void Function(DiscussionChannel channel)? onChannelTap;

  const ChannelsSidebar({
    super.key,
    this.onSettingsTap,
    this.onChannelTap,
  });

  Future<void> _showAddChannelDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final titleController = TextEditingController();
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addCustomTalkPage),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: l10n.wikiPageTitle,
                  hintText: l10n.wikiPageTitleHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.pageTitleRequired : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.channelDisplayName,
                  hintText: l10n.channelDisplayNameHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.nameRequired : null,
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
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final page = titleController.text.trim();
                final name = nameController.text.trim();
                final added = await ref.read(channelsProvider.notifier).addCustomChannel(
                      pageTitle: page,
                      displayName: name,
                      description: l10n.customTalkPage,
                      iconName: 'bookmark',
                    );
                ref.read(selectedChannelIdProvider.notifier).state = added.id;
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: WikiTheme.wikiBlue),
            child: Text(l10n.addChannel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final target = ref.watch(settingsProvider).target;
    final channelsAsync = ref.watch(channelsProvider);
    final activeChannel = ref.watch(activeChannelProvider);
    final auth = ref.watch(authProvider);

    return Material(
      color: isDark ? WikiTheme.darkSurface : WikiTheme.lightSurface,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: isDark ? WikiTheme.darkBorder : WikiTheme.lightBorder,
              width: 0.8,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header: App Title & Project Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? WikiTheme.darkBorder : WikiTheme.lightBorder,
                      width: 0.8,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/icon/wikitalk_icon_512.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.appTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? WikiTheme.darkSurfaceVariant
                                  : WikiTheme.lightSurfaceVariant,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              target.displayLabel,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? WikiTheme.wikiBlueDark
                                    : WikiTheme.wikiBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Channels List
              Expanded(
                child: channelsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('${l10n.error}: $e'),
                    ),
                  ),
                  data: (channels) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Text(
                            l10n.channelsSubpagesHeader,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: isDark
                                  ? WikiTheme.darkTextSecondary
                                  : WikiTheme.lightTextSecondary,
                            ),
                          ),
                        ),
                        for (final ch in channels)
                          _channelTile(
                            context: context,
                            channel: ch,
                            l10n: l10n,
                            isActive: activeChannel?.id == ch.id,
                            isDark: isDark,
                            onTap: () {
                              ref.read(selectedChannelIdProvider.notifier).state = ch.id;
                              onChannelTap?.call(ch);
                            },
                          ),
                        const SizedBox(height: 8),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.add_rounded, size: 20),
                            title: Text('${l10n.addChannel}...'),
                            onTap: () => _showAddChannelDialog(context, ref, l10n),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Settings Section (below Channels & Subpages)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark ? WikiTheme.darkBorder : WikiTheme.lightBorder,
                      width: 0.8,
                    ),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.settings_outlined, size: 20),
                    title: Text(
                      l10n.settings,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: onSettingsTap,
                  ),
                ),
              ),

              // User Account Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark ? WikiTheme.darkBorder : WikiTheme.lightBorder,
                      width: 0.8,
                    ),
                  ),
                ),
                child: auth.isLoggedIn
                    ? Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: WikiTheme.wikiBlue,
                            child: Text(
                              (auth.username?.isNotEmpty ?? false)
                                  ? auth.username![0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              auth.username ?? l10n.loggedIn,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout_rounded, size: 18),
                            tooltip: l10n.logOut,
                            onPressed: () =>
                                ref.read(authProvider.notifier).logout(),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.login_rounded, size: 16),
                          label: Text(l10n.loginWithWikimedia,
                              style: const TextStyle(fontSize: 12.5)),
                          onPressed: () =>
                              ref.read(authProvider.notifier).login(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            side: BorderSide(
                              color: isDark
                                  ? WikiTheme.darkBorder
                                  : WikiTheme.lightBorder,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _channelTile({
    required BuildContext context,
    required DiscussionChannel channel,
    required AppLocalizations l10n,
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final activeBg = isDark
        ? const Color(0xFF1B3B6F).withValues(alpha: 0.5)
        : const Color(0xFFEAF3FF);
    final activeColor = isDark ? WikiTheme.wikiBlueDark : WikiTheme.wikiBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isActive ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          leading: Icon(
            channel.icon,
            size: 20,
            color: isActive
                ? activeColor
                : (isDark
                    ? WikiTheme.darkTextSecondary
                    : WikiTheme.lightTextSecondary),
          ),
          title: Text(
            channel.getLocalizedDisplayName(l10n),
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? activeColor : null,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: channel.unreadCount > 0
              ? Badge.count(
                  count: channel.unreadCount,
                  backgroundColor: WikiTheme.wikiBlue,
                )
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
