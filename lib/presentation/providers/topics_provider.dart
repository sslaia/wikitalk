import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/wiki_talk_database.dart';
import '../../data/services/wiki_chat_api_service.dart';
import '../../domain/models/chat_topic.dart';
import '../../domain/models/discussion_channel.dart';
import 'auth_provider.dart';
import 'channels_provider.dart';
import 'settings_provider.dart';

final wikiChatApiServiceProvider = Provider<WikiChatApiService>((ref) {
  final service = WikiChatApiService();
  ref.onDispose(() => service.dispose());
  return service;
});

class TopicsState {
  final List<WikiChatTopic> topics;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const TopicsState({
    this.topics = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  TopicsState copyWith({
    List<WikiChatTopic>? topics,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return TopicsState(
      topics: topics ?? this.topics,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}

class TopicsNotifier extends StateNotifier<TopicsState> {
  final Ref _ref;
  final DiscussionChannel? _channel;

  TopicsNotifier(this._ref, this._channel)
      : super(TopicsState(isLoading: _channel != null)) {
    if (_channel != null) {
      Future.microtask(() => loadTopics());
    }
  }

  Future<void> loadTopics() async {
    if (_channel == null) return;
    final pageTitle = _channel.pageTitle;
    final target = _ref.read(settingsProvider).target;
    final api = _ref.read(wikiChatApiServiceProvider);
    final db = await WikiTalkDatabase.getInstance();

    // 1. Instantly display cached topics from SQLite (0ms UI latency)
    final cachedTopics = db.getCachedTopics(pageTitle);
    if (cachedTopics.isNotEmpty) {
      state = TopicsState(topics: cachedTopics, isLoading: false);
    }

    // 2. Fast check latest revision ID (~50ms)
    try {
      final token = await _ref.read(authProvider.notifier).getValidAccessToken();
      final latestRev = await api.fetchLatestRevisionId(
        domain: target.domain,
        pageTitle: pageTitle,
        accessToken: token,
      );

      // If we have cached topics and the revision hasn't changed, we are up to date!
      if (cachedTopics.isNotEmpty &&
          latestRev != null &&
          _channel.lastRevisionId == latestRev) {
        return;
      }

      // 3. Revision changed or no cache: fetch fresh topics
      final fresh = await api.fetchTopics(
        domain: target.domain,
        pageTitle: pageTitle,
        accessToken: token,
      );

      db.saveTopics(pageTitle, fresh);
      if (latestRev != null) {
        db.updateChannelRevision(pageTitle, latestRev);
      }

      state = TopicsState(topics: fresh, isLoading: false);
    } catch (e) {
      if (cachedTopics.isEmpty) {
        state = TopicsState(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  Future<void> refresh() async {
    if (_channel == null) return;
    state = state.copyWith(isRefreshing: true);
    final target = _ref.read(settingsProvider).target;
    final api = _ref.read(wikiChatApiServiceProvider);
    final pageTitle = _channel.pageTitle;

    try {
      final token = await _ref.read(authProvider.notifier).getValidAccessToken();
      final fresh = await api.fetchTopics(
        domain: target.domain,
        pageTitle: pageTitle,
        accessToken: token,
      );

      final db = await WikiTalkDatabase.getInstance();
      db.saveTopics(pageTitle, fresh);

      final latestRev = await api.fetchLatestRevisionId(
        domain: target.domain,
        pageTitle: pageTitle,
        accessToken: token,
      );
      if (latestRev != null) {
        db.updateChannelRevision(pageTitle, latestRev);
      }

      state = TopicsState(topics: fresh, isRefreshing: false);
    } catch (e) {
      state = state.copyWith(isRefreshing: false, errorMessage: e.toString());
    }
  }

  Future<void> postReply({
    required String topicId,
    required String commentId,
    required String wikitext,
    String? captchaWord,
    String? captchaId,
  }) async {
    if (_channel == null) return;
    final target = _ref.read(settingsProvider).target;
    final api = _ref.read(wikiChatApiServiceProvider);
    final token = await _ref.read(authProvider.notifier).getValidAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Login required to post a reply.');
    }

    await api.postReply(
      domain: target.domain,
      pageTitle: _channel.pageTitle,
      commentId: commentId,
      wikitext: wikitext,
      accessToken: token,
      captchaWord: captchaWord,
      captchaId: captchaId,
    );

    // Refresh topics after posting reply
    await refresh();
  }

  Future<void> createNewTopic({
    required String topicTitle,
    required String wikitext,
    String? captchaWord,
    String? captchaId,
  }) async {
    if (_channel == null) return;
    final target = _ref.read(settingsProvider).target;
    final api = _ref.read(wikiChatApiServiceProvider);
    final token = await _ref.read(authProvider.notifier).getValidAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Login required to create a topic.');
    }

    await api.createNewTopic(
      domain: target.domain,
      pageTitle: _channel.pageTitle,
      topicTitle: topicTitle,
      wikitext: wikitext,
      accessToken: token,
      captchaWord: captchaWord,
      captchaId: captchaId,
    );

    // Refresh topics after creating topic
    await refresh();
  }
}

final topicsProvider = StateNotifierProvider<TopicsNotifier, TopicsState>((ref) {
  final activeChannel = ref.watch(activeChannelProvider);
  return TopicsNotifier(ref, activeChannel);
});

final activeTopicIdProvider = StateProvider<String?>((ref) => null);

final activeTopicProvider = Provider<WikiChatTopic?>((ref) {
  final topicsState = ref.watch(topicsProvider);
  final activeId = ref.watch(activeTopicIdProvider);
  if (activeId == null) {
    return topicsState.topics.isNotEmpty ? topicsState.topics.first : null;
  }
  return topicsState.topics.cast<WikiChatTopic?>().firstWhere(
        (t) => t?.id == activeId,
        orElse: () => topicsState.topics.isNotEmpty ? topicsState.topics.first : null,
      );
});
