import 'package:flutter/material.dart';
import '../../core/theme/wiki_theme.dart';
import '../../data/services/wiki_chat_api_service.dart';

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
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.security_rounded, color: WikiTheme.wikiBlue),
          SizedBox(width: 8),
          Text('CAPTCHA Verification'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MediaWiki requires a quick verification before publishing this edit.',
            style: TextStyle(fontSize: 13),
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
                    const Text('Failed to load CAPTCHA image.'),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Answer / Word',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
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
          child: const Text('Verify & Submit'),
        ),
      ],
    );
  }
}
