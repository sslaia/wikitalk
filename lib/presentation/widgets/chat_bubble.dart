import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/wiki_theme.dart';
import '../../domain/models/chat_message.dart';
import '../../l10n/generated/app_localizations.dart';

/// Renders an individual talk page comment as a modern chat bubble with Wikipedia styling.
class ChatBubble extends StatelessWidget {
  final WikiChatMessage message;
  final bool isCurrentUser;
  final VoidCallback? onReplyTap;
  final String domain;

  const ChatBubble({
    super.key,
    required this.message,
    this.isCurrentUser = false,
    this.onReplyTap,
    this.domain = 'id.wikipedia.org',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
                          _formatDate(message.timestamp, l10n),
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

                  // Quoted Reply banner if replying to someone (WhatsApp style)
                  if (message.replyingToAuthor != null)
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black26
                            : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(5),
                        border: const Border(
                          left: BorderSide(
                              color: WikiTheme.wikiBlue, width: 3.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.replyingTo(message.replyingToAuthor!.replaceFirst(RegExp(r'^@'), '')),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 11.5,
                              color: isDark
                                  ? WikiTheme.wikiBlueDark
                                  : WikiTheme.wikiBlue,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (message.replyingToSnippet != null &&
                              message.replyingToSnippet!.trim().isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              message.replyingToSnippet!,
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
                        ],
                      ),
                    ),

                  // HTML Message Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: HtmlWidget(
                      message.htmlContent.isEmpty
                          ? '<i>(${l10n.emptyComment})</i>'
                          : message.htmlContent,
                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                      onTapUrl: (url) async {
                        return await openUrl(url, domain);
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
                                l10n.reply,
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

  String _formatDate(DateTime? dt, AppLocalizations l10n) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return l10n.timeMinutesAgo(diff.inMinutes);
    } else if (diff.inHours < 24) {
      return l10n.timeHoursAgo(diff.inHours);
    } else if (diff.inDays < 7) {
      return l10n.timeDaysAgo(diff.inDays);
    }
    return DateFormat('d MMM yyyy').format(dt);
  }

  /// Resolves relative or scheme-less URLs from MediaWiki HTML content into
  /// canonical HTTPS URIs targeting the active wiki domain.
  static Uri? resolveUri(String url, String domain) {
    var resolved = url.trim();
    if (resolved.isEmpty) return null;

    final cleanDomain =
        domain.trim().isEmpty ? 'id.wikipedia.org' : domain.trim();

    if (resolved.startsWith('//')) {
      resolved = 'https:$resolved';
    } else if (resolved.startsWith('./')) {
      resolved = 'https://$cleanDomain/wiki/${resolved.substring(2)}';
    } else if (resolved.startsWith('/wiki/')) {
      resolved = 'https://$cleanDomain$resolved';
    } else if (resolved.startsWith('/')) {
      resolved = 'https://$cleanDomain$resolved';
    } else if (resolved.startsWith('#')) {
      resolved = 'https://$cleanDomain/wiki/$resolved';
    } else if (!resolved.startsWith('http://') &&
        !resolved.startsWith('https://') &&
        !resolved.startsWith('mailto:') &&
        !resolved.startsWith('tel:')) {
      resolved = 'https://$cleanDomain/wiki/$resolved';
    }

    return Uri.tryParse(resolved) ?? Uri.tryParse(Uri.encodeFull(resolved));
  }

  /// Opens the given URL in an in-app browser view if HTTP/HTTPS, falling back
  /// to platform default if unavailable, so users can easily return to the app.
  static Future<bool> openUrl(String url, String domain) async {
    final uri = resolveUri(url, domain);
    if (uri == null) return false;

    final scheme = uri.scheme.toLowerCase();
    if (scheme == 'http' || scheme == 'https') {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppBrowserView,
        );
        if (launched) return true;
      } catch (_) {}

      try {
        return await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {
        return false;
      }
    } else {
      try {
        return await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {
        return false;
      }
    }
  }
}
