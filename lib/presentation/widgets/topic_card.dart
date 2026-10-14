import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/wiki_theme.dart';
import '../../domain/models/chat_topic.dart';

/// Card displaying a discussion topic in the topic list.
class TopicCard extends StatelessWidget {
  final WikiChatTopic topic;
  final bool isSelected;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topic,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = isDark
        ? const Color(0xFF1B3B6F).withValues(alpha: 0.4)
        : const Color(0xFFEAF3FF);
    final selectedBorder = WikiTheme.wikiBlue;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? selectedBg : (isDark ? WikiTheme.darkSurface : WikiTheme.lightSurface),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? selectedBorder
              : (isDark ? WikiTheme.darkBorder : WikiTheme.lightBorder),
          width: isSelected ? 1.5 : 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic Title
                Text(
                  topic.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Latest Message Snippet
                if (topic.messages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _cleanSnippet(topic.messages.last.htmlContent),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? WikiTheme.darkTextSecondary
                            : WikiTheme.lightTextSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Footer Metadata
                Row(
                  children: [
                    // Comment Count Badge
                    _badge(
                      icon: Icons.chat_bubble_outline_rounded,
                      text: '${topic.commentCount}',
                      isDark: isDark,
                    ),
                    const SizedBox(width: 12),

                    // Author Count Badge
                    _badge(
                      icon: Icons.people_outline_rounded,
                      text: '${topic.authorCount}',
                      isDark: isDark,
                    ),
                    const Spacer(),

                    // Latest Timestamp
                    if (topic.latestReplyTimestamp != null)
                      Text(
                        _formatDate(topic.latestReplyTimestamp!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: isDark
                              ? WikiTheme.darkTextSecondary
                              : WikiTheme.lightTextSecondary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: isDark
              ? WikiTheme.darkTextSecondary
              : WikiTheme.lightTextSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: isDark
                ? WikiTheme.darkTextSecondary
                : WikiTheme.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  String _cleanSnippet(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return DateFormat('d MMM').format(dt);
  }
}
