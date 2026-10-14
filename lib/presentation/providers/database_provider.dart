import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/wiki_talk_database.dart';

final databaseProvider = FutureProvider<WikiTalkDatabase>((ref) async {
  return await WikiTalkDatabase.getInstance();
});
