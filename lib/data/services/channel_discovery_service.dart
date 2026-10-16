import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wikimedia_core/wikimedia_core.dart';

import '../../domain/models/discussion_channel.dart';
import '../../domain/models/wiki_project_target.dart';

/// Service to resolve and dynamically discover discussion channels/subpages.
class ChannelDiscoveryService {
  final http.Client _client;

  ChannelDiscoveryService({http.Client? client})
    : _client = client ?? http.Client();

  /// Resolve known channels or dynamically discover them via API.
  Future<List<DiscussionChannel>> getChannels(
    WikiProjectTarget target, {
    String? basePageTitle,
  }) async {
    final lang = target.langCode.toLowerCase();
    final project = target.project;

    // Check predefined curated channels when basePageTitle is default or null
    final isDefaultBase =
        basePageTitle == null ||
        basePageTitle.trim().isEmpty ||
        basePageTitle.trim().toLowerCase() == 'wikipedia:warung kopi' ||
        basePageTitle.trim().toLowerCase() == 'wikipedia:village pump' ||
        basePageTitle.trim().toLowerCase() == 'wikipedia:angkringan' ||
        basePageTitle.trim().toLowerCase() == 'wikipedia:monganga afo';

    if (isDefaultBase) {
      if (project == ProjectType.wikipedia && lang == 'id') {
        return _indonesianWarungKopiChannels;
      } else if (project == ProjectType.wikipedia && lang == 'en') {
        return _englishVillagePumpChannels;
      } else if (project == ProjectType.wikipedia && lang == 'jv') {
        return _javaneseAngkringanChannels;
      } else if (project == ProjectType.wikipedia && lang == 'nia') {
        return _niasMongangaAfoChannels;
      }
    }

    // Otherwise, discover dynamically or fallback using the configured basePageTitle
    return await _discoverDynamicChannels(target, basePageTitle: basePageTitle);
  }

  static const List<DiscussionChannel> _indonesianWarungKopiChannels = [
    DiscussionChannel(
      id: 'id_wiki_kebijakan',
      pageTitle: 'Wikipedia:Warung Kopi (Kebijakan)',
      displayName: 'Policy',
      description: 'Policy and guideline proposals, debates, and RFCs',
      iconName: 'gavel',
    ),
    DiscussionChannel(
      id: 'id_wiki_usulan',
      pageTitle: 'Wikipedia:Warung Kopi (Usulan)',
      displayName: 'Proposals',
      description: 'New proposals, features, and community ideas',
      iconName: 'lightbulb',
    ),
    DiscussionChannel(
      id: 'id_wiki_teknis',
      pageTitle: 'Wikipedia:Warung Kopi (Teknis)',
      displayName: 'Technical',
      description: 'Technical issues, bot bugs, Lua scripts, and gadgets',
      iconName: 'build',
    ),
    DiscussionChannel(
      id: 'id_wiki_bahasa',
      pageTitle: 'Wikipedia:Warung Kopi (Bahasa)',
      displayName: 'Language',
      description: 'Grammar, translation terms, and spelling rules',
      iconName: 'translate',
    ),
    DiscussionChannel(
      id: 'id_wiki_berita',
      pageTitle: 'Wikipedia:Warung Kopi (Berita)',
      displayName: 'News',
      description: 'Project announcements, contests, and community news',
      iconName: 'campaign',
    ),
    DiscussionChannel(
      id: 'id_wiki_lain',
      pageTitle: 'Wikipedia:Warung Kopi (Lain-lain)',
      displayName: 'Miscellaneous',
      description: 'General discussions and casual community topics',
      iconName: 'coffee',
    ),
  ];

  static const List<DiscussionChannel> _englishVillagePumpChannels = [
    DiscussionChannel(
      id: 'en_wiki_policy',
      pageTitle: 'Wikipedia:Village pump (policy)',
      displayName: 'Policy',
      description: 'Policy and guideline proposals, debates, and RFCs',
      iconName: 'gavel',
    ),
    DiscussionChannel(
      id: 'en_wiki_technical',
      pageTitle: 'Wikipedia:Village pump (technical)',
      displayName: 'Technical',
      description: 'MediaWiki technical issues, templates, and bots',
      iconName: 'build',
    ),
    DiscussionChannel(
      id: 'en_wiki_proposals',
      pageTitle: 'Wikipedia:Village pump (proposals)',
      displayName: 'Proposals',
      description: 'New proposals and ideas for the community',
      iconName: 'lightbulb',
    ),
    DiscussionChannel(
      id: 'en_wiki_idealab',
      pageTitle: 'Wikipedia:Village pump (idea lab)',
      displayName: 'Idea Lab',
      description: 'Incubate early-stage proposals before RFC',
      iconName: 'science',
    ),
    DiscussionChannel(
      id: 'en_wiki_teahouse',
      pageTitle: 'Wikipedia:Teahouse',
      displayName: 'Teahouse',
      description: 'Friendly space for new editors to ask questions',
      iconName: 'tea',
    ),
    DiscussionChannel(
      id: 'en_wiki_misc',
      pageTitle: 'Wikipedia:Village pump (miscellaneous)',
      displayName: 'Miscellaneous',
      description: 'General discussions not fitting other pumps',
      iconName: 'forum',
    ),
  ];

  static const List<DiscussionChannel> _javaneseAngkringanChannels = [
    DiscussionChannel(
      id: 'jv_wiki_angkringan',
      pageTitle: 'Wikipedia:Angkringan',
      displayName: 'Angkringan',
      description: 'Ruang diskusi komunitas Wikipedia Basa Jawa',
      iconName: 'coffee',
    ),
  ];

  static const List<DiscussionChannel> _niasMongangaAfoChannels = [
    DiscussionChannel(
      id: 'nia_wiki_monganga_afo',
      pageTitle: 'Wikipedia:Monganga_afo',
      displayName: 'Monganga Afo',
      description: 'Ruang diskusi komunitas Wikipedia Nias',
      iconName: 'coffee',
    ),
  ];

  Future<List<DiscussionChannel>> _discoverDynamicChannels(
    WikiProjectTarget target, {
    String? basePageTitle,
  }) async {
    final domain = target.domain;
    String rootPrefix = basePageTitle?.trim() ?? '';
    if (rootPrefix.isEmpty) {
      if (target.project == ProjectType.wikipedia) {
        rootPrefix = 'Wikipedia:Village pump';
      } else if (target.project == ProjectType.wiktionary) {
        rootPrefix = 'Wiktionary:Beer parlour';
      } else {
        rootPrefix = 'Wikibooks:Staff lounge';
      }
    }

    try {
      final uri = Uri.https(domain, '/w/api.php', {
        'action': 'query',
        'list': 'prefixsearch',
        'pssearch': rootPrefix,
        'pslimit': '15',
        'format': 'json',
        'formatversion': '2',
      });

      final res = await _client
          .get(
            uri,
            headers: {
              'User-Agent':
                  'WikiTalk/1.0.0 (Wikimedia Community Discussion Tool)',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final items = data['query']?['prefixsearch'] as List<dynamic>? ?? [];

        final channels = <DiscussionChannel>[];
        for (final item in items) {
          final title = item['title'] as String? ?? '';
          if (title.contains('/Arsip') ||
              title.contains('/Archive') ||
              title.contains('/Index')) {
            continue;
          }
          final cleanName = title
              .replaceAll(RegExp(r'^[^:]+:'), '')
              .replaceAll('_', ' ');
          channels.add(
            DiscussionChannel(
              id: '${target.langCode}_${target.project.name}_${title.hashCode}',
              pageTitle: title,
              displayName: cleanName.isEmpty ? title : cleanName,
              description: 'Discussion page on $domain',
              iconName: 'forum',
            ),
          );
        }

        if (channels.isNotEmpty) return channels;
      }
    } catch (_) {}

    final fallbackClean = rootPrefix
        .replaceAll(RegExp(r'^[^:]+:'), '')
        .replaceAll('_', ' ');

    return [
      DiscussionChannel(
        id: '${target.langCode}_${target.project.name}_main',
        pageTitle: rootPrefix,
        displayName: fallbackClean.isEmpty ? 'Community Discussion' : fallbackClean,
        description: 'Main discussion board on $domain',
        iconName: 'forum',
      ),
    ];
  }
}
