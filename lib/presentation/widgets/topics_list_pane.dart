import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/wiki_theme.dart';
import '../../domain/models/chat_topic.dart';
import '../../domain/models/discussion_channel.dart';
import '../providers/channels_provider.dart';
import '../providers/topics_provider.dart';
import 'topic_card.dart';

/// Pane displaying the list of discussion topics for the active channel.
class TopicsListPane extends ConsumerStatefulWidget {
  final bool isLargeScreen;
  final void Function(WikiChatTopic topic)? onTopicSelected;

  const TopicsListPane({
    super.key,
    required this.isLargeScreen,
    this.onTopicSelected,
  });

  @override
  ConsumerState<TopicsListPane> createState() => _TopicsListPaneState();
}

class _TopicsListPaneState extends ConsumerState<TopicsListPane> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showNewTopicDialog(BuildContext context, DiscussionChannel channel) async {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;
    String? formError;

    final theme = Theme.of(context);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 18,
                right: 18,
                top: 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New Topic in ${channel.displayName}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (formError != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: WikiTheme.wikiRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          formError!,
                          style: const TextStyle(
                            color: WikiTheme.wikiRed,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Topic Title',
                        hintText: 'e.g. Proposal for new guideline',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: messageController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Message Body (Wikitext supported)',
                        hintText: 'Share your thoughts with the community...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Message is required' : null,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              setModalState(() {
                                isSubmitting = true;
                                formError = null;
                              });

                              try {
                                await ref.read(topicsProvider.notifier).createNewTopic(
                                      topicTitle: titleController.text.trim(),
                                      wikitext: messageController.text.trim(),
                                    );
                                if (ctx.mounted) Navigator.of(ctx).pop();
                              } on Exception catch (e) {
                                setModalState(() {
                                  isSubmitting = false;
                                  formError = e.toString();
                                });
                              }
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: WikiTheme.wikiBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Publish Topic to Wiki'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeChannel = ref.watch(activeChannelProvider);
    final topicsState = ref.watch(topicsProvider);
    final selectedTopicId = ref.watch(activeTopicIdProvider);

    if (activeChannel == null) {
      return const Center(child: Text('Select a channel to view discussions'));
    }

    final filteredTopics = topicsState.topics.where((t) {
      if (_searchQuery.isEmpty) return true;
      return t.title.toLowerCase().contains(_searchQuery) ||
          t.messages.any((m) => m.htmlContent.toLowerCase().contains(_searchQuery));
    }).toList();

    return Column(
      children: [
        // Channel Header Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? WikiTheme.darkSurface : WikiTheme.lightSurface,
            border: Border(
              bottom: BorderSide(
                color: isDark ? WikiTheme.darkBorder : WikiTheme.lightBorder,
                width: 0.8,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(activeChannel.icon, color: WikiTheme.wikiBlue, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeChannel.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (activeChannel.description.isNotEmpty)
                      Text(
                        activeChannel.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11.5,
                          color: isDark
                              ? WikiTheme.darkTextSecondary
                              : WikiTheme.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_comment_outlined),
                tooltip: 'New Topic',
                onPressed: () => _showNewTopicDialog(context, activeChannel),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search topics in ${activeChannel.displayName}...',
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 16),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? WikiTheme.darkBorder : WikiTheme.lightBorder,
                ),
              ),
            ),
          ),
        ),

        // Topics List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.read(topicsProvider.notifier).refresh(),
            child: topicsState.isLoading && topicsState.topics.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : topicsState.errorMessage != null && topicsState.topics.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  size: 40, color: WikiTheme.wikiRed),
                              const SizedBox(height: 8),
                              Text(topicsState.errorMessage!),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () =>
                                    ref.read(topicsProvider.notifier).loadTopics(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : filteredTopics.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.inbox_outlined,
                                    size: 40, color: Colors.grey),
                                const SizedBox(height: 8),
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'No discussions in this channel yet.'
                                      : 'No topics match "$_searchQuery"',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            itemCount: filteredTopics.length,
                            itemBuilder: (context, index) {
                              final topic = filteredTopics[index];
                              final isSelected = widget.isLargeScreen &&
                                  topic.id == selectedTopicId;

                              return TopicCard(
                                topic: topic,
                                isSelected: isSelected,
                                onTap: () {
                                  ref.read(activeTopicIdProvider.notifier).state =
                                      topic.id;
                                  widget.onTopicSelected?.call(topic);
                                },
                              );
                            },
                          ),
          ),
        ),
      ],
    );
  }
}
