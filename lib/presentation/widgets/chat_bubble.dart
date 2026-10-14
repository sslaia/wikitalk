import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/wiki_theme.dart';
import '../../domain/models/chat_message.dart';

/// Renders an individual talk page comment as a modern chat bubble with Wikipedia styling.
class ChatBubble extends StatelessWidget {
  final WikiChatMessage message;
  final bool isCurrentUser;
  final VoidCallback? onReplyTap;

  const ChatBubble({
    super.key,
    required this.message,
    this.isCurrentUser = false,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bubbleBg = isCurrentUser
        ? (isDark ? const Color(0xFF1B3B6F) : const Color(0xFFEAF3FF))
        : (isDark ? WikiTheme.darkSurfaceVariant : WikiTheme.lightSurface);

    final borderColor = isCurrentUser
        ? (isDark ? const Color(0xFF2A5298) : const Color(0xFFB8D6FF))
        : (isDark ? WikiTheme.darkBorder : WikiTheme.lightBorder);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            _buildAvatar(message.author, isDark),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 620),
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author & Timestamp Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: borderColor, width: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            message.author,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCurrentUser
                                  ? (isDark
                                      ? WikiTheme.wikiBlueDark
                                      : WikiTheme.wikiBlue)
                                  : (isDark
                                      ? WikiTheme.darkTextPrimary
                                      : WikiTheme.lightTextPrimary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(message.timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: isDark
                                ? WikiTheme.darkTextSecondary
                                : WikiTheme.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quoted Reply banner if replying to someone
                  if (message.replyingToAuthor != null)
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black26
                            : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(4),
                        border: const Border(
                          left: BorderSide(
                              color: WikiTheme.wikiBlue, width: 3),
                        ),
                      ),
                      child: Text(
                        'Replying to ${message.replyingToAuthor}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 11,
                        ),
                      ),
                    ),

                  // HTML Message Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: HtmlWidget(
                      message.htmlContent.isEmpty
                          ? '<i>(Empty comment)</i>'
                          : message.htmlContent,
                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                      onTapUrl: (url) async {
                        final uri = Uri.tryParse(url);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                          return true;
                        }
                        return false;
                      },
                    ),
                  ),

                  // Action Footer (Reply button)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 8, bottom: 4),
                      child: InkWell(
                        onTap: onReplyTap,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.reply_rounded,
                                size: 14,
                                color: isDark
                                    ? WikiTheme.darkTextSecondary
                                    : WikiTheme.lightTextSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Reply',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isDark
                                      ? WikiTheme.darkTextSecondary
                                      : WikiTheme.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            _buildAvatar(message.author, isDark, isCurrent: true),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(String author, bool isDark, {bool isCurrent = false}) {
    final initial = author.isNotEmpty ? author[0].toUpperCase() : 'W';
    final color = isCurrent
        ? WikiTheme.wikiBlue
        : _generateAvatarColor(author, isDark);

    return CircleAvatar(
      radius: 16,
      backgroundColor: color,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _generateAvatarColor(String name, bool isDark) {
    final colors = [
      const Color(0xFF3366CC),
      const Color(0xFF00AF89),
      const Color(0xFF72777D),
      const Color(0xFFAC6600),
      const Color(0xFF702963),
      const Color(0xFF2E7D32),
      const Color(0xFFC2185B),
    ];
    final hash = name.codeUnits.fold(0, (prev, elem) => prev + elem);
    return colors[hash % colors.length];
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return DateFormat('d MMM yyyy').format(dt);
  }
}
