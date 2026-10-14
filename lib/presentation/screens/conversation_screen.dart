import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_topic.dart';
import '../providers/topics_provider.dart';
import '../widgets/conversation_pane.dart';

/// Full-screen conversation view for mobile screen layouts.
class ConversationScreen extends ConsumerWidget {
  final WikiChatTopic topic;

  const ConversationScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current topic state in case new replies are posted or refreshed
    final topicsState = ref.watch(topicsProvider);
    final activeTopic = topicsState.topics.cast<WikiChatTopic?>().firstWhere(
          (t) => t?.id == topic.id,
          orElse: () => topic,
        );

    return Scaffold(
      body: SafeArea(
        child: ConversationPane(
          topic: activeTopic,
          showBackButton: true,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
