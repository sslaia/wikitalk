import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/chat_topic.dart';
import '../../domain/models/discussion_channel.dart';

/// Local SQLite database for Wiki Talk caching and offline access.
class WikiTalkDatabase {
  static WikiTalkDatabase? _instance;
  final Database _db;

  WikiTalkDatabase._(this._db);

  factory WikiTalkDatabase.inMemory() {
    final db = sqlite3.openInMemory();
    _initSchema(db);
    return WikiTalkDatabase._(db);
  }

  static Future<WikiTalkDatabase> getInstance() async {
    if (_instance != null) return _instance!;
    final dir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dir.path, 'wiki_talk.db'));
    final db = sqlite3.open(dbFile.path);
    _initSchema(db);
    _instance = WikiTalkDatabase._(db);
    return _instance!;
  }

  static void _initSchema(Database db) {
    db.execute('''
      CREATE TABLE IF NOT EXISTS channels (
        id TEXT PRIMARY KEY,
        target_key TEXT DEFAULT '',
        page_title TEXT NOT NULL,
        display_name TEXT NOT NULL,
        description TEXT,
        icon_name TEXT,
        is_custom INTEGER DEFAULT 0,
        unread_count INTEGER DEFAULT 0,
        last_revision_id INTEGER
      );
    ''');

    try {
      db.execute('ALTER TABLE channels ADD COLUMN target_key TEXT DEFAULT ""');
    } catch (_) {}

    // Check if topics needs migration to db_id scoped schema
    try {
      final tableInfo = db.select("PRAGMA table_info(topics)");
      final hasDbId = tableInfo.any((col) => col['name'] == 'db_id');
      if (!hasDbId && tableInfo.isNotEmpty) {
        db.execute('DROP TABLE IF EXISTS messages');
        db.execute('DROP TABLE IF EXISTS topics');
      }
    } catch (_) {}

    db.execute('''
      CREATE TABLE IF NOT EXISTS topics (
        db_id TEXT PRIMARY KEY,
        id TEXT NOT NULL,
        channel_page_title TEXT NOT NULL,
        title TEXT NOT NULL,
        comment_count INTEGER DEFAULT 0,
        author_count INTEGER DEFAULT 1,
        latest_reply_ts TEXT,
        updated_at INTEGER
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS messages (
        db_id TEXT PRIMARY KEY,
        id TEXT NOT NULL,
        topic_db_id TEXT NOT NULL,
        author TEXT NOT NULL,
        timestamp TEXT,
        html_content TEXT NOT NULL,
        level INTEGER DEFAULT 1,
        parent_id TEXT,
        replying_to_author TEXT
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS drafts (
        target_id TEXT PRIMARY KEY,
        text TEXT NOT NULL,
        updated_at INTEGER
      );
    ''');
  }

  // Channel Operations
  void saveChannels(String targetKey, List<DiscussionChannel> channels) {
    _db.execute('BEGIN TRANSACTION');
    try {
      _db.execute('DELETE FROM channels WHERE target_key = ?', [targetKey]);

      final stmt = _db.prepare('''
        INSERT OR REPLACE INTO channels (id, target_key, page_title, display_name, description, icon_name, is_custom, unread_count, last_revision_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''');
      for (final ch in channels) {
        stmt.execute([
          ch.id,
          targetKey,
          ch.pageTitle,
          ch.displayName,
          ch.description,
          ch.iconName,
          ch.isCustom ? 1 : 0,
          ch.unreadCount,
          ch.lastRevisionId,
        ]);
      }
      stmt.dispose();
      _db.execute('COMMIT');
    } catch (_) {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }

  List<DiscussionChannel> getCachedChannels(String targetKey) {
    final rs = _db.select(
      'SELECT * FROM channels WHERE target_key = ? ORDER BY is_custom ASC, display_name ASC',
      [targetKey],
    );
    return rs.map((row) => DiscussionChannel.fromMap(row)).toList();
  }

  void deleteChannel(String channelId) {
    _db.execute('DELETE FROM channels WHERE id = ?', [channelId]);
  }

  void updateChannelRevision(String pageTitle, int revId) {
    _db.execute(
      'UPDATE channels SET last_revision_id = ? WHERE page_title = ?',
      [revId, pageTitle],
    );
  }

  // Topic Operations
  void saveTopics(String channelPageTitle, List<WikiChatTopic> topics) {
    _db.execute('BEGIN TRANSACTION');
    try {
      final oldTopicDbIds = _db.select(
        'SELECT db_id FROM topics WHERE channel_page_title = ?',
        [channelPageTitle],
      ).map((r) => r['db_id'] as String).toList();

      for (final tid in oldTopicDbIds) {
        _db.execute('DELETE FROM messages WHERE topic_db_id = ?', [tid]);
      }
      _db.execute('DELETE FROM topics WHERE channel_page_title = ?', [channelPageTitle]);

      final topicStmt = _db.prepare('''
        INSERT OR REPLACE INTO topics (db_id, id, channel_page_title, title, comment_count, author_count, latest_reply_ts, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''');

      final msgStmt = _db.prepare('''
        INSERT OR REPLACE INTO messages (db_id, id, topic_db_id, author, timestamp, html_content, level, parent_id, replying_to_author)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''');

      final now = DateTime.now().millisecondsSinceEpoch;

      for (int i = 0; i < topics.length; i++) {
        final topic = topics[i];
        final topicDbId = '$channelPageTitle::${topic.id}::$i';

        topicStmt.execute([
          topicDbId,
          topic.id,
          channelPageTitle,
          topic.title,
          topic.commentCount,
          topic.authorCount,
          topic.latestReplyTimestamp?.toIso8601String(),
          now,
        ]);

        for (int m = 0; m < topic.messages.length; m++) {
          final msg = topic.messages[m];
          final msgDbId = '$topicDbId::${msg.id}::$m';

          msgStmt.execute([
            msgDbId,
            msg.id,
            topicDbId,
            msg.author,
            msg.timestamp?.toIso8601String(),
            msg.htmlContent,
            msg.level,
            msg.parentId,
            msg.replyingToAuthor,
          ]);
        }
      }

      topicStmt.dispose();
      msgStmt.dispose();
      _db.execute('COMMIT');
    } catch (_) {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }

  List<WikiChatTopic> getCachedTopics(String channelPageTitle) {
    final topicRows = _db.select(
      'SELECT * FROM topics WHERE channel_page_title = ? ORDER BY rowid ASC',
      [channelPageTitle],
    );

    final topics = <WikiChatTopic>[];
    for (final tr in topicRows) {
      final topicDbId = tr['db_id'] as String;
      final msgRows = _db.select(
        'SELECT * FROM messages WHERE topic_db_id = ? ORDER BY rowid ASC',
        [topicDbId],
      );
      final messages = msgRows.map((mr) => WikiChatMessage.fromMap(mr)).toList();
      topics.add(WikiChatTopic.fromMap(tr, messages: messages));
    }

    return topics;
  }

  // Drafts
  void saveDraft(String targetId, String text) {
    if (text.trim().isEmpty) {
      _db.execute('DELETE FROM drafts WHERE target_id = ?', [targetId]);
    } else {
      _db.execute('''
        INSERT OR REPLACE INTO drafts (target_id, text, updated_at)
        VALUES (?, ?, ?)
      ''', [targetId, text, DateTime.now().millisecondsSinceEpoch]);
    }
  }

  String? getDraft(String targetId) {
    final rs = _db.select('SELECT text FROM drafts WHERE target_id = ?', [targetId]);
    if (rs.isEmpty) return null;
    return rs.first['text'] as String?;
  }

  void close() {
    _db.dispose();
  }
}
