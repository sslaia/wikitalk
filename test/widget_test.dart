import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:wiki_talk/core/locale_utils.dart';
import 'package:wiki_talk/domain/models/chat_message.dart';
import 'package:wiki_talk/domain/models/chat_topic.dart';
import 'package:wiki_talk/domain/models/discussion_channel.dart';
import 'package:wiki_talk/domain/models/wiki_project_target.dart';
import 'package:wiki_talk/presentation/providers/settings_provider.dart';
import 'package:wiki_talk/presentation/widgets/chat_bubble.dart';
import 'package:wikimedia_core/wikimedia_core.dart';

void main() {
  test('DiscussionChannel creation and map conversion test', () {
    const channel = DiscussionChannel(
      id: 'id_wiki_kebijakan',
      pageTitle: 'Wikipedia:Warung Kopi (Kebijakan)',
      displayName: 'Kebijakan',
      iconName: 'gavel',
    );

    expect(channel.displayName, 'Kebijakan');
    expect(channel.iconName, 'gavel');

    final map = channel.toMap();
    final restored = DiscussionChannel.fromMap(map);

    expect(restored.id, channel.id);
    expect(restored.pageTitle, channel.pageTitle);
    expect(restored.displayName, channel.displayName);
  });

  test('WikiProjectTarget domain generation test', () {
    const idTarget = WikiProjectTarget(
      langCode: 'id',
      project: ProjectType.wikipedia,
    );
    expect(idTarget.domain, 'id.wikipedia.org');

    const enTarget = WikiProjectTarget(
      langCode: 'en',
      project: ProjectType.wiktionary,
    );
    expect(enTarget.domain, 'en.wiktionary.org');
  });

  test('WikiChatTopic and WikiChatMessage model test', () {
    const topic = WikiChatTopic(
      id: 'h-Tinjauan_tahunan',
      title: 'Tinjauan tahunan',
      commentCount: 1,
      authorCount: 1,
      messages: [
        WikiChatMessage(
          id: 'c-Author-123',
          author: 'Author',
          htmlContent: '<p>Content</p>',
        ),
      ],
    );

    expect(topic.id, 'h-Tinjauan_tahunan');
    expect(topic.messages.length, 1);
    expect(topic.replyTargetCommentId, 'c-Author-123');

    final map = topic.toMap('Wikikamus:Warung Kopi');
    final restored = WikiChatTopic.fromMap(map, messages: topic.messages);
    expect(restored.id, topic.id);
    expect(restored.title, topic.title);
  });

  test('WikiChatMessage firstLineSnippet extraction test', () {
    const msg1 = WikiChatMessage(
      id: 'c-1',
      author: 'User1',
      htmlContent: '<p>Halo ini baris pertama.<br>Ini baris kedua.</p>',
    );
    expect(msg1.firstLineSnippet, 'Halo ini baris pertama.');

    const msg2 = WikiChatMessage(
      id: 'c-2',
      author: 'User2',
      htmlContent: '<p>&quot;Kutipan penting&quot; &amp; referensi</p>',
    );
    expect(msg2.firstLineSnippet, '"Kutipan penting" & referensi');

    const msg3 = WikiChatMessage(
      id: 'c-3',
      author: 'User3',
      htmlContent: '   \n<p>  Baris dengan spasi  </p>',
    );
    expect(msg3.firstLineSnippet, 'Baris dengan spasi');

    const msg4 = WikiChatMessage(
      id: 'c-4',
      author: 'User4',
      htmlContent: '',
    );
    expect(msg4.firstLineSnippet, '');
  });

  test('WikiChatMessage serialization with replyingToSnippet', () {
    const original = WikiChatMessage(
      id: 'c-reply-1',
      author: 'Responder',
      htmlContent: '<p>Saya setuju dengan Anda.</p>',
      replyingToAuthor: 'OriginalAuthor',
      replyingToSnippet: 'Poin pertama diskusi',
    );

    final map = original.toMap('topic-123');
    expect(map['replying_to_author'], 'OriginalAuthor');
    expect(map['replying_to_snippet'], 'Poin pertama diskusi');

    final restored = WikiChatMessage.fromMap(map);
    expect(restored.id, original.id);
    expect(restored.replyingToAuthor, 'OriginalAuthor');
    expect(restored.replyingToSnippet, 'Poin pertama diskusi');
  });

  test('Indonesian regional languages resolve to Indonesian locale', () {
    expect(isIndonesianRegionLanguage('id'), isTrue);
    expect(isIndonesianRegionLanguage('jv'), isTrue);
    expect(isIndonesianRegionLanguage('nia'), isTrue);
    expect(isIndonesianRegionLanguage('su'), isTrue);
    expect(isIndonesianRegionLanguage('min'), isTrue);
    expect(isIndonesianRegionLanguage('ban'), isTrue);
    expect(isIndonesianRegionLanguage('ace'), isTrue);
    expect(isIndonesianRegionLanguage('bjn'), isTrue);
    expect(isIndonesianRegionLanguage('gor'), isTrue);
    expect(isIndonesianRegionLanguage('bug'), isTrue);
    expect(isIndonesianRegionLanguage('bew'), isTrue);
    expect(isIndonesianRegionLanguage('map-bms'), isTrue);
    expect(isIndonesianRegionLanguage('en'), isFalse);
    expect(isIndonesianRegionLanguage('de'), isFalse);
    expect(isIndonesianRegionLanguage('fr'), isFalse);
    // Timorese (Tetun) and other ESEAP languages are not Indonesian
    expect(isIndonesianRegionLanguage('tet'), isFalse);
    expect(isIndonesianRegionLanguage('th'), isFalse);
    expect(isIndonesianRegionLanguage('vi'), isFalse);
    expect(isIndonesianRegionLanguage('tl'), isFalse);

    // Verify resolveAppLocale maps all regional languages of Indonesia to 'id'
    expect(resolveAppLocale('jv'), const Locale('id'));
    expect(resolveAppLocale('nia'), const Locale('id'));
    expect(resolveAppLocale('su'), const Locale('id'));
    expect(resolveAppLocale('min'), const Locale('id'));
    expect(resolveAppLocale('id'), const Locale('id'));
    // ESEAP and other global languages resolve to English
    expect(resolveAppLocale('en'), const Locale('en'));
    expect(resolveAppLocale('tet'), const Locale('en'));
    expect(resolveAppLocale('th'), const Locale('en'));
    expect(resolveAppLocale('vi'), const Locale('en'));
    expect(resolveAppLocale('tl'), const Locale('en'));
    expect(resolveAppLocale('fr'), const Locale('en'));
  });

  test('getDefaultBasePageTitle resolves native village pump titles for ESEAP and global projects', () {
    // English default
    expect(
      SettingsNotifier.getDefaultBasePageTitle('en', ProjectType.wikipedia),
      'Wikipedia:Village pump',
    );
    // Thai (สภากาแฟ)
    expect(
      SettingsNotifier.getDefaultBasePageTitle('th', ProjectType.wikipedia),
      'วิกิพีเดีย:สภากาแฟ',
    );
    // Vietnamese (Thảo luận)
    expect(
      SettingsNotifier.getDefaultBasePageTitle('vi', ProjectType.wikipedia),
      'Wikipedia:Thảo luận',
    );
    // Timorese / Tetun (Kafe)
    expect(
      SettingsNotifier.getDefaultBasePageTitle('tet', ProjectType.wikipedia),
      'Wikipédia:Kafe',
    );
    // Tagalog (Kapihan)
    expect(
      SettingsNotifier.getDefaultBasePageTitle('tl', ProjectType.wikipedia),
      'Wikipedia:Kapihan',
    );
    // Malay (Kedai Kopi)
    expect(
      SettingsNotifier.getDefaultBasePageTitle('ms', ProjectType.wikipedia),
      'Wikipedia:Kedai Kopi',
    );
    // Indonesian (Warung Kopi)
    expect(
      SettingsNotifier.getDefaultBasePageTitle('id', ProjectType.wikipedia),
      'Wikipedia:Warung Kopi',
    );
  });

  test('ChatBubble.resolveUri correctly normalizes internal and external links', () {
    const domain = 'id.wikipedia.org';

    // DiscussionTools relative page links (as reported in bug)
    expect(
      ChatBubble.resolveUri('./Keraton_Kasepuhan', domain)?.toString(),
      'https://id.wikipedia.org/wiki/Keraton_Kasepuhan',
    );
    expect(
      ChatBubble.resolveUri('./Kampung_Batik_Trusmi', domain)?.toString(),
      'https://id.wikipedia.org/wiki/Kampung_Batik_Trusmi',
    );
    expect(
      ChatBubble.resolveUri('./Pengguna:Ariyanto', domain)?.toString(),
      'https://id.wikipedia.org/wiki/Pengguna:Ariyanto',
    );
    expect(
      ChatBubble.resolveUri('./Pengguna%3AAriyanto', domain)?.toString(),
      'https://id.wikipedia.org/wiki/Pengguna%3AAriyanto',
    );

    // Root-relative links
    expect(
      ChatBubble.resolveUri('/wiki/Keraton_Kasepuhan', domain)?.toString(),
      'https://id.wikipedia.org/wiki/Keraton_Kasepuhan',
    );
    expect(
      ChatBubble.resolveUri('/w/index.php?title=Keraton_Kasepuhan', domain)?.toString(),
      'https://id.wikipedia.org/w/index.php?title=Keraton_Kasepuhan',
    );

    // Protocol-relative links
    expect(
      ChatBubble.resolveUri('//commons.wikimedia.org/wiki/File:Cirebon.jpg', domain)?.toString(),
      'https://commons.wikimedia.org/wiki/File:Cirebon.jpg',
    );

    // Anchor links
    expect(
      ChatBubble.resolveUri('#Tinjauan_tahunan', domain)?.toString(),
      'https://id.wikipedia.org/wiki/#Tinjauan_tahunan',
    );

    // External and absolute links
    expect(
      ChatBubble.resolveUri('https://en.wikipedia.org/wiki/Cirebon', domain)?.toString(),
      'https://en.wikipedia.org/wiki/Cirebon',
    );
    expect(
      ChatBubble.resolveUri('http://example.com', domain)?.toString(),
      'http://example.com',
    );
    expect(
      ChatBubble.resolveUri('mailto:user@example.com', domain)?.toString(),
      'mailto:user@example.com',
    );

    // Empty or blank links
    expect(ChatBubble.resolveUri('', domain), isNull);
    expect(ChatBubble.resolveUri('   ', domain), isNull);
  });
}
