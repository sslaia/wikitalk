import 'package:flutter/material.dart';
import '../../core/theme/wiki_theme.dart';
import '../../data/services/wiki_chat_api_service.dart';
import '../../l10n/generated/app_localizations.dart';

/// Dialog to solve MediaWiki anti-abuse (ConfirmEdit) CAPTCHA.
class WikiCaptchaDialog extends StatefulWidget {
  final WikiCaptchaException exception;

  const WikiCaptchaDialog({super.key, required this.exception});

  @override
  State<WikiCaptchaDialog> createState() => _WikiCaptchaDialogState();
}

class _WikiCaptchaDialogState extends State<WikiCaptchaDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.security_rounded, color: WikiTheme.wikiBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.captchaSecurityVerification,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.captchaVerificationMessage,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          if (widget.exception.question != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade400),
              ),
              child: Text(
                widget.exception.question!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          if (widget.exception.url != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Image.network(
                widget.exception.url!,
                errorBuilder: (_, _, _) =>
                    Text(l10n.failedToLoadCaptchaImage),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: l10n.captchaAnswerLabel,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final word = _controller.text.trim();
            if (word.isNotEmpty) {
              Navigator.of(context).pop({
                'captchaWord': word,
                'captchaId': widget.exception.id,
              });
            }
          },
          style: FilledButton.styleFrom(backgroundColor: WikiTheme.wikiBlue),
          child: Text(l10n.verifyAndSubmit),
        ),
      ],
    );
  }
}
