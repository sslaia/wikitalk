import 'package:flutter_test/flutter_test.dart';
import 'package:wiki_talk/domain/models/chat_message.dart';
import 'package:wiki_talk/domain/models/chat_topic.dart';
import 'package:wiki_talk/domain/models/discussion_channel.dart';
import 'package:wiki_talk/domain/models/wiki_project_target.dart';
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
}
