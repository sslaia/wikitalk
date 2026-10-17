// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wiki Talk';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get submit => 'Submit';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get remove => 'Remove';

  @override
  String get error => 'Error';

  @override
  String get apply => 'Apply';

  @override
  String get channels => 'Channels';

  @override
  String get addChannel => 'Add Channel';

  @override
  String get addCustomTalkPage => 'Add Custom Talk Page';

  @override
  String get wikiPageTitle => 'Wiki Page Title';

  @override
  String get wikiPageTitleHint => 'e.g. Pembicaraan:Indonesia or WP:Kedutaan';

  @override
  String get channelDisplayName => 'Channel Display Name';

  @override
  String get channelDisplayNameHint => 'e.g. Indonesia Talk';

  @override
  String get pageTitleRequired => 'Page title is required';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get customTalkPage => 'Custom talk page';

  @override
  String get loggedIn => 'Logged in';

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get tapToLogIn => 'Tap to log in';

  @override
  String get settings => 'Settings';

  @override
  String get resetDefaults => 'Reset Defaults';

  @override
  String get resetChannelsSnackBar => 'Reset channels to project defaults';

  @override
  String get customBadge => 'CUSTOM';

  @override
  String get removeChannel => 'Remove channel';

  @override
  String removedChannelSnackBar(String name) {
    return 'Removed \"$name\"';
  }

  @override
  String addedChannelSnackBar(String name) {
    return 'Added channel \"$name\"';
  }

  @override
  String get addSubpageOrChannel => 'Add Subpage / Channel';

  @override
  String get searchTopicsHint => 'Search topics, subjects or authors...';

  @override
  String searchTopicsInChannel(String channel) {
    return 'Search topics in $channel...';
  }

  @override
  String get loadingDiscussions => 'Loading discussions...';

  @override
  String get noDiscussionsFound => 'No discussions found';

  @override
  String get noDiscussionsInChannel => 'No discussions in this channel yet.';

  @override
  String noTopicsMatchQuery(String query) {
    return 'No topics match \"$query\"';
  }

  @override
  String get failedToLoadDiscussions => 'Failed to load discussions';

  @override
  String get newTopic => 'New Topic';

  @override
  String newTopicInChannel(String channel) {
    return 'New Topic in $channel';
  }

  @override
  String get topicTitleLabel => 'Topic Title';

  @override
  String get topicTitleHint => 'e.g. Proposal for new guideline';

  @override
  String get messageBodyLabel => 'Message Body (Wikitext supported)';

  @override
  String get messageBodyHint => 'Share your thoughts with the community...';

  @override
  String get publishTopicToWiki => 'Publish Topic to Wiki';

  @override
  String get selectChannelToView => 'Select a channel to view discussions';

  @override
  String commentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comments',
      one: '1 comment',
      zero: 'No comments',
    );
    return '$_temp0';
  }

  @override
  String authorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count authors',
      one: '1 author',
      zero: '0 authors',
    );
    return '$_temp0';
  }

  @override
  String commentsAndContributors(int comments, int authors) {
    return '$comments comments · $authors contributors';
  }

  @override
  String get noCommentsYetBeFirst =>
      'No comments in this thread yet. Be the first to reply!';

  @override
  String get createNewTopic => 'Create New Topic';

  @override
  String get topicSubjectTitle => 'Topic Subject / Title';

  @override
  String get topicTitleRequired => 'Topic title is required';

  @override
  String get topicMessageContent => 'Message Content';

  @override
  String get topicContentRequired => 'Message content is required';

  @override
  String get publishTopic => 'Publish Topic';

  @override
  String get topicCreatedSuccess => 'Topic published successfully!';

  @override
  String get selectTopicToRead => 'Select a discussion topic to start reading';

  @override
  String get noMessagesYet => 'No messages in this discussion yet.';

  @override
  String get reply => 'Reply';

  @override
  String replyingTo(String author) {
    return 'Replying to @$author';
  }

  @override
  String get cancelReply => 'Cancel reply';

  @override
  String get replyPlaceholder =>
      'Type a reply or message (wikitext supported)...';

  @override
  String get writeCommentOnWiki => 'Write a comment on-wiki...';

  @override
  String get bold => 'Bold';

  @override
  String get italic => 'Italic';

  @override
  String get link => 'Link';

  @override
  String get signature => 'Signature';

  @override
  String get send => 'Send';

  @override
  String get loginRequired => 'Login Required';

  @override
  String get loginRequiredMessage =>
      'You must log in with your Wikimedia account to post replies to this discussion.';

  @override
  String get logIn => 'Log In';

  @override
  String get loginRequiredToReply =>
      'Please log in with Wikimedia to post replies.';

  @override
  String get replySentSuccess => 'Reply posted successfully!';

  @override
  String get projectAndLanguage => 'Project & Language';

  @override
  String get wikimediaProject => 'Wikimedia Project';

  @override
  String get languageEdition => 'Language Edition';

  @override
  String get customLanguageCodeHint =>
      'Custom language code (e.g. su, min, bar)';

  @override
  String get customLanguage => 'Custom language';

  @override
  String get customLanguageCodeDialogTitle => 'Custom Language Code';

  @override
  String get isoLanguageCode => 'ISO Language Code';

  @override
  String targetDomain(String domain) {
    return 'Target Domain: $domain';
  }

  @override
  String get baseDiscussionPage => 'Base Discussion Page';

  @override
  String get baseDiscussionPageDesc =>
      'Village pump, forum, or discussion portal name in this language/project (e.g. \"Wikipedia:Village pump\", \"Wikipedia:Thảo luận\", or \"Wikipedia:Warung Kopi\").';

  @override
  String get basePageTitleLabel =>
      'Base page title (e.g. Wikipedia:Village pump)';

  @override
  String get basePageTitleHint => 'e.g. Wikipedia:Village pump';

  @override
  String get channelDescriptionHint =>
      'e.g. Proposals for new ideas from the community';

  @override
  String get subpageLabel => 'Subpage';

  @override
  String get customLanguageHint => 'e.g. th, vi, tet, tl';

  @override
  String get toolbarSupport => 'Support';

  @override
  String get toolbarSupportTooltip => 'Support badge';

  @override
  String get toolbarOppose => 'Oppose';

  @override
  String get toolbarOpposeTooltip => 'Oppose badge';

  @override
  String get toolbarMentionTooltip => 'Mention a user';

  @override
  String get userLabel => 'User';

  @override
  String timeMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String timeHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String timeDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get mainDiscussionBoardTitle => 'Main Discussion Board Title';

  @override
  String get applyTargetPageTitle => 'Apply Target Page Title';

  @override
  String get set => 'Set';

  @override
  String targetPageSetSnackBar(String title) {
    return 'Target page set to \"$title\"';
  }

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get resetToDefaultSnackBar => 'Reset to project default page title';

  @override
  String get channelsAndSubpages => 'Channels & Subpages';

  @override
  String get channelsSubpagesDesc =>
      'Configure subpages or dedicated discussion pages that appear as channels in the app.';

  @override
  String get noChannelsConfigured =>
      'No channels configured. Tap below to add.';

  @override
  String get noChannelsConfiguredFull =>
      'No channels configured.\nTap below to add a subpage or reset to defaults.';

  @override
  String get addDiscussionChannelTitle => 'Add Discussion Channel / Subpage';

  @override
  String get fullOnWikiPageTitle => 'Full On-Wiki Page Title';

  @override
  String get channelDescriptionOptional => 'Description (Optional)';

  @override
  String get channelIconLabel => 'Icon';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get accountAndAuthorization => 'Account & Authorization';

  @override
  String get wikimediaAccount => 'Wikimedia Account';

  @override
  String get guestNotice =>
      'You can browse public discussions freely as a guest. To post replies or start new topics, log in with your Wikimedia account.';

  @override
  String get connectedViaOAuth => 'Connected via Wikimedia OAuth 2.0';

  @override
  String get loggedOutNotice =>
      'Not logged in. You can read discussions freely. Log in to reply or create new topics.';

  @override
  String get loginWithWikimedia => 'Log in with Wikimedia';

  @override
  String get logOut => 'Log out';

  @override
  String get pageDescriptionOptional => 'Page Description (optional)';

  @override
  String get channelIcon => 'Channel Icon';

  @override
  String get aboutAppTitle => 'Wiki Talk v1.0.0';

  @override
  String get aboutAppDescription =>
      'Collaborative discussion reader and editor for Wikimedia community talk pages and village pumps.\n\nClassification: Tools / Reference & Productivity.\nStorage: All discussions are public on-wiki wikitext. Offline cache is stored in local device SQLite.\nPermissions: Strictly Internet for MediaWiki API.';

  @override
  String get wikimediaTargetHeader => 'WIKIMEDIA TARGET';

  @override
  String get targetDiscussionPageTitleHeader => 'TARGET DISCUSSION PAGE TITLE';

  @override
  String get channelsSubpagesHeader => 'CHANNELS & SUBPAGES';

  @override
  String get appearanceHeader => 'APPEARANCE';

  @override
  String get wikimediaAccountHeader => 'WIKIMEDIA ACCOUNT';

  @override
  String get aboutComplianceHeader => 'ABOUT & PLAY CONSOLE COMPLIANCE';

  @override
  String get captchaSecurityVerification => 'Security Verification (CAPTCHA)';

  @override
  String get captchaVerificationMessage =>
      'MediaWiki requires a quick verification before publishing this edit.';

  @override
  String get captchaEnterText => 'Enter CAPTCHA text';

  @override
  String get captchaAnswerLabel => 'Answer / Word';

  @override
  String get captchaRequired => 'CAPTCHA response is required';

  @override
  String get verifyAndSubmit => 'Verify & Submit';

  @override
  String get channelPolicy => 'Policy';

  @override
  String get channelPolicyDesc =>
      'Policy and guideline proposals, debates, and RFCs';

  @override
  String get channelTechnical => 'Technical';

  @override
  String get channelTechnicalDesc =>
      'MediaWiki technical issues, templates, and bots';

  @override
  String get channelProposals => 'Proposals';

  @override
  String get channelProposalsDesc =>
      'New proposals and ideas for the community';

  @override
  String get channelIdeaLab => 'Idea Lab';

  @override
  String get channelIdeaLabDesc => 'Incubate early-stage proposals before RFC';

  @override
  String get channelTeahouse => 'Teahouse';

  @override
  String get channelTeahouseDesc =>
      'Friendly space for new editors to ask questions';

  @override
  String get channelMisc => 'Miscellaneous';

  @override
  String get channelMiscDesc => 'General discussions not fitting other pumps';

  @override
  String get channelNews => 'News';

  @override
  String get channelNewsDesc =>
      'Project announcements, contests, and community news';

  @override
  String get channelLanguage => 'Language';

  @override
  String get channelLanguageDesc =>
      'Grammar, translation terms, and spelling rules';

  @override
  String get channelCommunityDiscussion => 'Community Discussion';

  @override
  String channelMainDiscussionBoard(String domain) {
    return 'Main discussion board on $domain';
  }

  @override
  String channelDiscussionPageOn(String domain) {
    return 'Discussion page on $domain';
  }

  @override
  String get failedToLoadCaptchaImage => 'Failed to load CAPTCHA image.';

  @override
  String get emptyComment => 'Empty comment';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get noInternetDescription =>
      'Discussions cannot be loaded without an internet connection. Please check your network and retry.';

  @override
  String get offlineWarning =>
      'You are currently offline. Check your internet connection.';

  @override
  String get offlineCachedNotice => 'Offline mode: Showing cached discussions.';

  @override
  String get openInBrowser => 'Open in Browser';

  @override
  String get openInBrowserTooltip => 'Open this page in external web browser';
}
