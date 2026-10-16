import 'package:flutter/material.dart';
import '../../core/theme/wiki_theme.dart';
import '../../domain/models/chat_message.dart';
import '../../l10n/generated/app_localizations.dart';

/// Bottom composer for typing and submitting talk page replies.
class ChatComposer extends StatefulWidget {
  final WikiChatMessage? replyingTo;
  final VoidCallback? onCancelReply;
  final Future<void> Function(String text) onSendMessage;
  final bool isSubmitting;

  const ChatComposer({
    super.key,
    this.replyingTo,
    this.onCancelReply,
    required this.onSendMessage,
    this.isSubmitting = false,
  });

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _controller = TextEditingController();
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final valid = _controller.text.trim().isNotEmpty;
      if (valid != _canSubmit) {
        setState(() => _canSubmit = valid);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _insertFormatting(String prefix, String suffix) {
    final text = _controller.text;
    final selection = _controller.selection;

    if (!selection.isValid || selection.isCollapsed) {
      final newText = text + prefix + suffix;
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: text.length + prefix.length),
      );
    } else {
      final selectedText = selection.textInside(text);
      final replaced = prefix + selectedText + suffix;
      final newText = selection.textBefore(text) +
          replaced +
          selection.textAfter(text);
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: selection.start + prefix.length,
          extentOffset:
              selection.start + prefix.length + selectedText.length,
        ),
      );
    }
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSubmitting) return;

    await widget.onSendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? WikiTheme.darkSurface : WikiTheme.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? WikiTheme.darkBorder : WikiTheme.lightBorder,
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quoted reply banner (WhatsApp style)
            if (widget.replyingTo != null)
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1B2A3D)
                      : const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                    left: BorderSide(
                      color: WikiTheme.wikiBlue,
                      width: 4,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.reply_rounded,
                      size: 18,
                      color: WikiTheme.wikiBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.replyingTo(widget.replyingTo!.author.replaceFirst(RegExp(r'^@'), '')),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? WikiTheme.wikiBlueDark
                                  : WikiTheme.wikiBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.replyingTo!.firstLineSnippet.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.replyingTo!.firstLineSnippet,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? WikiTheme.darkTextSecondary
                                    : WikiTheme.lightTextSecondary,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: widget.onCancelReply,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      tooltip: l10n.cancelReply,
                    ),
                  ],
                ),
              ),

            // Wikitext toolbar
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _toolbarButton('B', l10n.bold, () => _insertFormatting("'''", "'''")),
                  _toolbarButton('I', l10n.italic, () => _insertFormatting("''", "''")),
                  _toolbarButton(l10n.link, l10n.link, () => _insertFormatting('[[', ']]')),
                  _toolbarButton('@${l10n.userLabel}', l10n.toolbarMentionTooltip, () => _insertFormatting('{{u|', '}}')),
                  _toolbarButton('✓ ${l10n.toolbarSupport}', l10n.toolbarSupportTooltip, () => _insertFormatting('{{Support}} ', '')),
                  _toolbarButton('✗ ${l10n.toolbarOppose}', l10n.toolbarOpposeTooltip, () => _insertFormatting('{{Oppose}} ', '')),
                ],
              ),
            ),

            // Input area
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 8, bottom: 8, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: 5,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: l10n.writeCommentOnWiki,
                        hintStyle: TextStyle(
                          color: isDark
                              ? WikiTheme.darkTextSecondary
                              : WikiTheme.lightTextSecondary,
                          fontSize: 14,
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: isDark
                            ? WikiTheme.darkSurfaceVariant
                            : WikiTheme.lightSurfaceVariant,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: l10n.send,
                    onPressed: _canSubmit && !widget.isSubmitting
                        ? _handleSend
                        : null,
                    icon: widget.isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: WikiTheme.wikiBlue,
                      disabledBackgroundColor: isDark
                          ? WikiTheme.darkBorder
                          : WikiTheme.lightBorder,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbarButton(String label, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          minimumSize: const Size(32, 28),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: label == 'B' ? FontWeight.bold : FontWeight.w500,
            fontStyle: label == 'I' ? FontStyle.italic : FontStyle.normal,
            color: label.startsWith('✓')
                ? WikiTheme.wikiGreen
                : label.startsWith('✗')
                    ? WikiTheme.wikiRed
                    : null,
          ),
        ),
      ),
    );
  }
}
