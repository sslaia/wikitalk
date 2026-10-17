import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/wiki_theme.dart';
import '../../data/services/wiki_chat_api_service.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/chat_topic.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/channels_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/topics_provider.dart';
import 'chat_bubble.dart';
import 'chat_composer.dart';
import 'wiki_captcha_dialog.dart';

enum LoginPromptAction {
  cancel,
  login,
  openInBrowser,
}

/// Pane displaying the active conversation thread with chat bubbles and composer.
class ConversationPane extends ConsumerStatefulWidget {
  final WikiChatTopic? topic;
  final bool showBackButton;
  final VoidCallback? onBack;

  const ConversationPane({
    super.key,
    required this.topic,
    this.showBackButton = false,
    this.onBack,
  });

  /// Constructs the web URL for a topic on a Wikimedia project talk page.
  static Uri buildTopicWebUri({
    required String domain,
    String? pageTitle,
    String? topicTitle,
  }) {
    final cleanPage = pageTitle?.trim().replaceAll(' ', '_') ?? '';
    final cleanTopic = topicTitle?.trim().replaceAll(' ', '_') ?? '';
    return Uri.https(
      domain,
      cleanPage.isNotEmpty ? '/wiki/$cleanPage' : '/',
    ).replace(
      fragment: cleanTopic.isNotEmpty ? cleanTopic : null,
    );
  }

  @override
  ConsumerState<ConversationPane> createState() => _ConversationPaneState();
}

class _ConversationPaneState extends ConsumerState<ConversationPane> {
  final ScrollController _scrollController = ScrollController();
  WikiChatMessage? _replyingTo;
  bool _isSubmitting = false;

  Future<void> _handleSendMessage(String text) async {
    final topic = widget.topic;
    if (topic == null) return;
    final l10n = AppLocalizations.of(context)!;
    final domain = ref.read(settingsProvider).target.domain;

    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn) {
      final action = await showDialog<LoginPromptAction>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.loginRequired),
          content: Text(l10n.loginRequiredMessage),
          actionsAlignment: MainAxisAlignment.end,
          actionsOverflowButtonSpacing: 8,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(LoginPromptAction.cancel),
              child: Text(l10n.cancel),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.open_in_browser_rounded, size: 16),
              label: Text(l10n.openInBrowser),
              onPressed: () => Navigator.of(ctx).pop(LoginPromptAction.openInBrowser),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(LoginPromptAction.login),
              style: FilledButton.styleFrom(backgroundColor: WikiTheme.wikiBlue),
              child: Text(l10n.logIn),
            ),
          ],
        ),
      );

      if (action == LoginPromptAction.openInBrowser) {
        final activeChannel = ref.read(activeChannelProvider);
        final pageUri = ConversationPane.buildTopicWebUri(
          domain: domain,
          pageTitle: activeChannel?.pageTitle,
          topicTitle: topic.title,
        );

        try {
          await launchUrl(pageUri, mode: LaunchMode.externalApplication);
        } catch (e) {
          if (mounted) {
            _showErrorSnackbar(e.toString());
          }
        }
        return;
      } else if (action == LoginPromptAction.login && mounted) {
        await ref.read(authProvider.notifier).login(context);
        if (!ref.read(authProvider).isLoggedIn) return;
      } else {
        return;
      }
    }

    setState(() => _isSubmitting = true);

    final commentTargetId =
        _replyingTo?.replyTargetCommentId ?? topic.replyTargetCommentId;

    try {
      await _executePost(
        topicId: topic.id,
        commentId: commentTargetId,
        wikitext: text,
      );
      setState(() => _replyingTo = null);
      _scrollToBottom();
    } on WikiCaptchaException catch (captchaEx) {
      if (!mounted) return;
      final captchaRes = await showDialog<Map<String, dynamic>>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => WikiCaptchaDialog(exception: captchaEx),
      );

      if (captchaRes != null && mounted) {
        try {
          await _executePost(
            topicId: topic.id,
            commentId: commentTargetId,
            wikitext: text,
            captchaWord: captchaRes['captchaWord'] as String?,
            captchaId: captchaRes['captchaId'] as String?,
          );
          setState(() => _replyingTo = null);
          _scrollToBottom();
        } catch (e) {
          _showErrorSnackbar(e.toString());
        }
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _executePost({
    required String topicId,
    required String commentId,
    required String wikitext,
    String? captchaWord,
    String? captchaId,
  }) async {
    await ref.read(topicsProvider.notifier).postReply(
          topicId: topicId,
          commentId: commentId,
          wikitext: wikitext,
          captchaWord: captchaWord,
          captchaId: captchaId,
        );
  }

  void _showErrorSnackbar(String error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: WikiTheme.wikiRed,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final topic = widget.topic;
    final currentUsername = ref.watch(authProvider).username;
    final domain = ref.watch(settingsProvider).target.domain;

    if (topic == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined,
                size: 54, color: isDark ? Colors.white30 : Colors.black26),
            const SizedBox(height: 12),
            Text(
              l10n.selectTopicToRead,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? WikiTheme.darkTextSecondary
                    : WikiTheme.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Topic Header
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
              if (widget.showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: widget.onBack,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.commentsAndContributors(topic.commentCount, topic.authorCount),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? WikiTheme.darkTextSecondary
                            : WikiTheme.lightTextSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.open_in_browser_rounded),
                tooltip: l10n.openInBrowserTooltip,
                onPressed: () {
                  final activeChannel = ref.read(activeChannelProvider);
                  final pageUri = ConversationPane.buildTopicWebUri(
                    domain: domain,
                    pageTitle: activeChannel?.pageTitle,
                    topicTitle: topic.title,
                  );
                  launchUrl(pageUri, mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
        ),

        // Messages List
        Expanded(
          child: topic.messages.isEmpty
              ? Center(
                  child: Text(
                    l10n.noCommentsYetBeFirst,
                    style: TextStyle(
                      color: isDark
                          ? WikiTheme.darkTextSecondary
                          : WikiTheme.lightTextSecondary,
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: topic.messages.length,
                  itemBuilder: (context, index) {
                    final msg = topic.messages[index];
                    final isCurrent = currentUsername != null &&
                        msg.author.toLowerCase() ==
                            currentUsername.toLowerCase();

                    return ChatBubble(
                      message: msg,
                      isCurrentUser: isCurrent,
                      domain: domain,
                      onReplyTap: () {
                        setState(() => _replyingTo = msg);
                      },
                    );
                  },
                ),
        ),

        // Composer
        ChatComposer(
          replyingTo: _replyingTo,
          onCancelReply: () => setState(() => _replyingTo = null),
          onSendMessage: _handleSendMessage,
          isSubmitting: _isSubmitting,
        ),
      ],
    );
  }
}
