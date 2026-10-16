import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/wiki_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/channels_provider.dart';
import '../providers/topics_provider.dart';
import '../widgets/channels_sidebar.dart';
import '../widgets/conversation_pane.dart';
import '../widgets/topics_list_pane.dart';
import 'conversation_screen.dart';
import 'settings_screen.dart';

/// Main adaptive shell that automatically responds to screen size and orientation.
class ResponsiveHomeShell extends ConsumerWidget {
  const ResponsiveHomeShell({super.key});

  static const double largeScreenBreakpoint = 650.0;
  static const double threePaneBreakpoint = 980.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width >= threePaneBreakpoint) {
          return _buildThreePaneLayout(context, ref);
        } else if (width >= largeScreenBreakpoint) {
          return _buildTwoPaneLayout(context, ref);
        } else {
          return _buildMobileLayout(context, ref);
        }
      },
    );
  }

  // 1. Mobile Layout (< 650px): Drawer + Topic List -> pushes ConversationScreen
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    final activeChannel = ref.watch(activeChannelProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: WikiTheme.wikiBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'W',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              activeChannel?.getLocalizedDisplayName(l10n) ?? l10n.appTitle,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ChannelsSidebar(
          onSettingsTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          onChannelTap: (_) => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: TopicsListPane(
          isLargeScreen: false,
          onTopicSelected: (topic) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConversationScreen(topic: topic),
              ),
            );
          },
        ),
      ),
    );
  }

  // 2. Tablet / Landscape Layout (650px - 980px): Sidebar Drawer or Rail + Master Topics + Detail Thread
  Widget _buildTwoPaneLayout(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Left Sidebar for Channels (Compact or Drawer)
            SizedBox(
              width: 250,
              child: ChannelsSidebar(
                onSettingsTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ),
            const VerticalDivider(width: 1),

            // Right Pane: Topics List
            Expanded(
              child: TopicsListPane(
                isLargeScreen: true,
                onTopicSelected: (topic) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConversationScreen(topic: topic),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Desktop / Large Tablet Layout (> 980px): Full Three-Pane (Channels + Topics + Conversation)
  Widget _buildThreePaneLayout(BuildContext context, WidgetRef ref) {
    final activeTopic = ref.watch(activeTopicProvider);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Pane 1: Channels (260px)
            SizedBox(
              width: 260,
              child: ChannelsSidebar(
                onSettingsTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ),
            const VerticalDivider(width: 1),

            // Pane 2: Topics List (340px)
            SizedBox(
              width: 340,
              child: TopicsListPane(
                isLargeScreen: true,
                onTopicSelected: (topic) {
                  // Active topic is automatically updated in provider
                },
              ),
            ),
            const VerticalDivider(width: 1),

            // Pane 3: Active Conversation Thread (Expanded)
            Expanded(
              child: ConversationPane(
                topic: activeTopic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
