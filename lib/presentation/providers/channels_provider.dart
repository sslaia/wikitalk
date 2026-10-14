import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/wiki_talk_database.dart';
import '../../data/services/channel_discovery_service.dart';
import '../../domain/models/discussion_channel.dart';
import 'settings_provider.dart';

final channelDiscoveryServiceProvider = Provider<ChannelDiscoveryService>((ref) {
  return ChannelDiscoveryService();
});

class ChannelsNotifier extends StateNotifier<AsyncValue<List<DiscussionChannel>>> {
  final Ref _ref;

  ChannelsNotifier(this._ref) : super(const AsyncValue.loading()) {
    Future.microtask(() => loadChannels());
  }

  Future<void> loadChannels() async {
    state = const AsyncValue.loading();
    try {
      final settings = _ref.read(settingsProvider);
      final target = settings.target;
      final targetKey = '${target.langCode}_${target.project.name}';
      final db = await WikiTalkDatabase.getInstance();

      // Check cached channels for this specific target
      final cached = db.getCachedChannels(targetKey);
      if (cached.isNotEmpty) {
        state = AsyncValue.data(cached);
        return;
      }

      // Fetch dynamic/curated channels
      final discovery = _ref.read(channelDiscoveryServiceProvider);
      final discovered = await discovery.getChannels(
        target,
        basePageTitle: settings.basePageTitle,
      );

      db.saveChannels(targetKey, discovered);
      state = AsyncValue.data(discovered);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<DiscussionChannel> addCustomChannel({
    required String pageTitle,
    required String displayName,
    String? description,
    String? iconName,
  }) async {
    final settings = _ref.read(settingsProvider);
    final target = settings.target;
    final targetKey = '${target.langCode}_${target.project.name}';
    final db = await WikiTalkDatabase.getInstance();

    final newChannel = DiscussionChannel(
      id: '${targetKey}_${DateTime.now().millisecondsSinceEpoch}',
      pageTitle: pageTitle.trim(),
      displayName: displayName.trim(),
      description: description?.trim().isNotEmpty == true
          ? description!.trim()
          : 'Subpage of ${settings.basePageTitle}',
      iconName: iconName ?? 'forum',
      isCustom: true,
    );

    final current = state.value ?? [];
    final updated = [...current, newChannel];
    state = AsyncValue.data(updated);
    db.saveChannels(targetKey, updated);
    return newChannel;
  }

  Future<void> deleteChannel(String channelId) async {
    final db = await WikiTalkDatabase.getInstance();
    db.deleteChannel(channelId);
    final current = state.value ?? [];
    final updated = current.where((c) => c.id != channelId).toList();
    state = AsyncValue.data(updated);
  }

  Future<void> resetToDefaults() async {
    state = const AsyncValue.loading();
    try {
      final settings = _ref.read(settingsProvider);
      final target = settings.target;
      final targetKey = '${target.langCode}_${target.project.name}';
      final db = await WikiTalkDatabase.getInstance();

      final discovery = _ref.read(channelDiscoveryServiceProvider);
      final discovered = await discovery.getChannels(
        target,
        basePageTitle: settings.basePageTitle,
      );

      db.saveChannels(targetKey, discovered);
      state = AsyncValue.data(discovered);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final channelsProvider = StateNotifierProvider<ChannelsNotifier, AsyncValue<List<DiscussionChannel>>>((ref) {
  // Reload whenever language or project target changes
  ref.watch(settingsProvider.select((s) => '${s.langCode}_${s.project.name}'));
  return ChannelsNotifier(ref);
});

final selectedChannelIdProvider = StateProvider<String?>((ref) => null);

final activeChannelProvider = Provider<DiscussionChannel?>((ref) {
  final channelsAsync = ref.watch(channelsProvider);
  final selectedId = ref.watch(selectedChannelIdProvider);
  return channelsAsync.maybeWhen(
    data: (channels) {
      if (channels.isEmpty) return null;
      if (selectedId != null) {
        final match = channels.cast<DiscussionChannel?>().firstWhere(
              (c) => c?.id == selectedId,
              orElse: () => null,
            );
        if (match != null) return match;
      }
      return channels.first;
    },
    orElse: () => null,
  );
});
