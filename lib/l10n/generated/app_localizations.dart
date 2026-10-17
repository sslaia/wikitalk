import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Wiki Talk'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @channels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get channels;

  /// No description provided for @addChannel.
  ///
  /// In en, this message translates to:
  /// **'Add Channel'**
  String get addChannel;

  /// No description provided for @addCustomTalkPage.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Talk Page'**
  String get addCustomTalkPage;

  /// No description provided for @wikiPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Wiki Page Title'**
  String get wikiPageTitle;

  /// No description provided for @wikiPageTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Pembicaraan:Indonesia or WP:Kedutaan'**
  String get wikiPageTitleHint;

  /// No description provided for @channelDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Channel Display Name'**
  String get channelDisplayName;

  /// No description provided for @channelDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Indonesia Talk'**
  String get channelDisplayNameHint;

  /// No description provided for @pageTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Page title is required'**
  String get pageTitleRequired;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @customTalkPage.
  ///
  /// In en, this message translates to:
  /// **'Custom talk page'**
  String get customTalkPage;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedIn;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @tapToLogIn.
  ///
  /// In en, this message translates to:
  /// **'Tap to log in'**
  String get tapToLogIn;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @resetDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset Defaults'**
  String get resetDefaults;

  /// No description provided for @resetChannelsSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Reset channels to project defaults'**
  String get resetChannelsSnackBar;

  /// No description provided for @customBadge.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM'**
  String get customBadge;

  /// No description provided for @removeChannel.
  ///
  /// In en, this message translates to:
  /// **'Remove channel'**
  String get removeChannel;

  /// No description provided for @removedChannelSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Removed \"{name}\"'**
  String removedChannelSnackBar(String name);

  /// No description provided for @addedChannelSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Added channel \"{name}\"'**
  String addedChannelSnackBar(String name);

  /// No description provided for @addSubpageOrChannel.
  ///
  /// In en, this message translates to:
  /// **'Add Subpage / Channel'**
  String get addSubpageOrChannel;

  /// No description provided for @searchTopicsHint.
  ///
  /// In en, this message translates to:
  /// **'Search topics, subjects or authors...'**
  String get searchTopicsHint;

  /// No description provided for @searchTopicsInChannel.
  ///
  /// In en, this message translates to:
  /// **'Search topics in {channel}...'**
  String searchTopicsInChannel(String channel);

  /// No description provided for @loadingDiscussions.
  ///
  /// In en, this message translates to:
  /// **'Loading discussions...'**
  String get loadingDiscussions;

  /// No description provided for @noDiscussionsFound.
  ///
  /// In en, this message translates to:
  /// **'No discussions found'**
  String get noDiscussionsFound;

  /// No description provided for @noDiscussionsInChannel.
  ///
  /// In en, this message translates to:
  /// **'No discussions in this channel yet.'**
  String get noDiscussionsInChannel;

  /// No description provided for @noTopicsMatchQuery.
  ///
  /// In en, this message translates to:
  /// **'No topics match \"{query}\"'**
  String noTopicsMatchQuery(String query);

  /// No description provided for @failedToLoadDiscussions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load discussions'**
  String get failedToLoadDiscussions;

  /// No description provided for @newTopic.
  ///
  /// In en, this message translates to:
  /// **'New Topic'**
  String get newTopic;

  /// No description provided for @newTopicInChannel.
  ///
  /// In en, this message translates to:
  /// **'New Topic in {channel}'**
  String newTopicInChannel(String channel);

  /// No description provided for @topicTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic Title'**
  String get topicTitleLabel;

  /// No description provided for @topicTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Proposal for new guideline'**
  String get topicTitleHint;

  /// No description provided for @messageBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Message Body (Wikitext supported)'**
  String get messageBodyLabel;

  /// No description provided for @messageBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts with the community...'**
  String get messageBodyHint;

  /// No description provided for @publishTopicToWiki.
  ///
  /// In en, this message translates to:
  /// **'Publish Topic to Wiki'**
  String get publishTopicToWiki;

  /// No description provided for @selectChannelToView.
  ///
  /// In en, this message translates to:
  /// **'Select a channel to view discussions'**
  String get selectChannelToView;

  /// No description provided for @commentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No comments} =1{1 comment} other{{count} comments}}'**
  String commentsCount(int count);

  /// No description provided for @authorsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 authors} =1{1 author} other{{count} authors}}'**
  String authorsCount(int count);

  /// No description provided for @commentsAndContributors.
  ///
  /// In en, this message translates to:
  /// **'{comments} comments · {authors} contributors'**
  String commentsAndContributors(int comments, int authors);

  /// No description provided for @noCommentsYetBeFirst.
  ///
  /// In en, this message translates to:
  /// **'No comments in this thread yet. Be the first to reply!'**
  String get noCommentsYetBeFirst;

  /// No description provided for @createNewTopic.
  ///
  /// In en, this message translates to:
  /// **'Create New Topic'**
  String get createNewTopic;

  /// No description provided for @topicSubjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Topic Subject / Title'**
  String get topicSubjectTitle;

  /// No description provided for @topicTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Topic title is required'**
  String get topicTitleRequired;

  /// No description provided for @topicMessageContent.
  ///
  /// In en, this message translates to:
  /// **'Message Content'**
  String get topicMessageContent;

  /// No description provided for @topicContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Message content is required'**
  String get topicContentRequired;

  /// No description provided for @publishTopic.
  ///
  /// In en, this message translates to:
  /// **'Publish Topic'**
  String get publishTopic;

  /// No description provided for @topicCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Topic published successfully!'**
  String get topicCreatedSuccess;

  /// No description provided for @selectTopicToRead.
  ///
  /// In en, this message translates to:
  /// **'Select a discussion topic to start reading'**
  String get selectTopicToRead;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages in this discussion yet.'**
  String get noMessagesYet;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to @{author}'**
  String replyingTo(String author);

  /// No description provided for @cancelReply.
  ///
  /// In en, this message translates to:
  /// **'Cancel reply'**
  String get cancelReply;

  /// No description provided for @replyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type a reply or message (wikitext supported)...'**
  String get replyPlaceholder;

  /// No description provided for @writeCommentOnWiki.
  ///
  /// In en, this message translates to:
  /// **'Write a comment on-wiki...'**
  String get writeCommentOnWiki;

  /// No description provided for @bold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// No description provided for @italic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get italic;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequired;

  /// No description provided for @loginRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'You must log in with your Wikimedia account to post replies to this discussion.'**
  String get loginRequiredMessage;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @loginRequiredToReply.
  ///
  /// In en, this message translates to:
  /// **'Please log in with Wikimedia to post replies.'**
  String get loginRequiredToReply;

  /// No description provided for @replySentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reply posted successfully!'**
  String get replySentSuccess;

  /// No description provided for @projectAndLanguage.
  ///
  /// In en, this message translates to:
  /// **'Project & Language'**
  String get projectAndLanguage;

  /// No description provided for @wikimediaProject.
  ///
  /// In en, this message translates to:
  /// **'Wikimedia Project'**
  String get wikimediaProject;

  /// No description provided for @languageEdition.
  ///
  /// In en, this message translates to:
  /// **'Language Edition'**
  String get languageEdition;

  /// No description provided for @customLanguageCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Custom language code (e.g. su, min, bar)'**
  String get customLanguageCodeHint;

  /// No description provided for @customLanguage.
  ///
  /// In en, this message translates to:
  /// **'Custom language'**
  String get customLanguage;

  /// No description provided for @customLanguageCodeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Language Code'**
  String get customLanguageCodeDialogTitle;

  /// No description provided for @isoLanguageCode.
  ///
  /// In en, this message translates to:
  /// **'ISO Language Code'**
  String get isoLanguageCode;

  /// No description provided for @targetDomain.
  ///
  /// In en, this message translates to:
  /// **'Target Domain: {domain}'**
  String targetDomain(String domain);

  /// No description provided for @baseDiscussionPage.
  ///
  /// In en, this message translates to:
  /// **'Base Discussion Page'**
  String get baseDiscussionPage;

  /// No description provided for @baseDiscussionPageDesc.
  ///
  /// In en, this message translates to:
  /// **'Village pump, forum, or discussion portal name in this language/project (e.g. \"Wikipedia:Village pump\", \"Wikipedia:Thảo luận\", or \"Wikipedia:Warung Kopi\").'**
  String get baseDiscussionPageDesc;

  /// No description provided for @basePageTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Base page title (e.g. Wikipedia:Village pump)'**
  String get basePageTitleLabel;

  /// No description provided for @basePageTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Wikipedia:Village pump'**
  String get basePageTitleHint;

  /// No description provided for @channelDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Proposals for new ideas from the community'**
  String get channelDescriptionHint;

  /// No description provided for @subpageLabel.
  ///
  /// In en, this message translates to:
  /// **'Subpage'**
  String get subpageLabel;

  /// No description provided for @customLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. th, vi, tet, tl'**
  String get customLanguageHint;

  /// No description provided for @toolbarSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get toolbarSupport;

  /// No description provided for @toolbarSupportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Support badge'**
  String get toolbarSupportTooltip;

  /// No description provided for @toolbarOppose.
  ///
  /// In en, this message translates to:
  /// **'Oppose'**
  String get toolbarOppose;

  /// No description provided for @toolbarOpposeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Oppose badge'**
  String get toolbarOpposeTooltip;

  /// No description provided for @toolbarMentionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mention a user'**
  String get toolbarMentionTooltip;

  /// No description provided for @userLabel.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userLabel;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String timeDaysAgo(int count);

  /// No description provided for @mainDiscussionBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Main Discussion Board Title'**
  String get mainDiscussionBoardTitle;

  /// No description provided for @applyTargetPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply Target Page Title'**
  String get applyTargetPageTitle;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @targetPageSetSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Target page set to \"{title}\"'**
  String targetPageSetSnackBar(String title);

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @resetToDefaultSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Reset to project default page title'**
  String get resetToDefaultSnackBar;

  /// No description provided for @channelsAndSubpages.
  ///
  /// In en, this message translates to:
  /// **'Channels & Subpages'**
  String get channelsAndSubpages;

  /// No description provided for @channelsSubpagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure subpages or dedicated discussion pages that appear as channels in the app.'**
  String get channelsSubpagesDesc;

  /// No description provided for @noChannelsConfigured.
  ///
  /// In en, this message translates to:
  /// **'No channels configured. Tap below to add.'**
  String get noChannelsConfigured;

  /// No description provided for @noChannelsConfiguredFull.
  ///
  /// In en, this message translates to:
  /// **'No channels configured.\nTap below to add a subpage or reset to defaults.'**
  String get noChannelsConfiguredFull;

  /// No description provided for @addDiscussionChannelTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Discussion Channel / Subpage'**
  String get addDiscussionChannelTitle;

  /// No description provided for @fullOnWikiPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Full On-Wiki Page Title'**
  String get fullOnWikiPageTitle;

  /// No description provided for @channelDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get channelDescriptionOptional;

  /// No description provided for @channelIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get channelIconLabel;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @accountAndAuthorization.
  ///
  /// In en, this message translates to:
  /// **'Account & Authorization'**
  String get accountAndAuthorization;

  /// No description provided for @wikimediaAccount.
  ///
  /// In en, this message translates to:
  /// **'Wikimedia Account'**
  String get wikimediaAccount;

  /// No description provided for @guestNotice.
  ///
  /// In en, this message translates to:
  /// **'You can browse public discussions freely as a guest. To post replies or start new topics, log in with your Wikimedia account.'**
  String get guestNotice;

  /// No description provided for @connectedViaOAuth.
  ///
  /// In en, this message translates to:
  /// **'Connected via Wikimedia OAuth 2.0'**
  String get connectedViaOAuth;

  /// No description provided for @loggedOutNotice.
  ///
  /// In en, this message translates to:
  /// **'Not logged in. You can read discussions freely. Log in to reply or create new topics.'**
  String get loggedOutNotice;

  /// No description provided for @loginWithWikimedia.
  ///
  /// In en, this message translates to:
  /// **'Log in with Wikimedia'**
  String get loginWithWikimedia;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @pageDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Page Description (optional)'**
  String get pageDescriptionOptional;

  /// No description provided for @channelIcon.
  ///
  /// In en, this message translates to:
  /// **'Channel Icon'**
  String get channelIcon;

  /// No description provided for @aboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Wiki Talk v1.0.0'**
  String get aboutAppTitle;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Collaborative discussion reader and editor for Wikimedia community talk pages and village pumps.\n\nClassification: Tools / Reference & Productivity.\nStorage: All discussions are public on-wiki wikitext. Offline cache is stored in local device SQLite.\nPermissions: Strictly Internet for MediaWiki API.'**
  String get aboutAppDescription;

  /// No description provided for @wikimediaTargetHeader.
  ///
  /// In en, this message translates to:
  /// **'WIKIMEDIA TARGET'**
  String get wikimediaTargetHeader;

  /// No description provided for @targetDiscussionPageTitleHeader.
  ///
  /// In en, this message translates to:
  /// **'TARGET DISCUSSION PAGE TITLE'**
  String get targetDiscussionPageTitleHeader;

  /// No description provided for @channelsSubpagesHeader.
  ///
  /// In en, this message translates to:
  /// **'CHANNELS & SUBPAGES'**
  String get channelsSubpagesHeader;

  /// No description provided for @appearanceHeader.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get appearanceHeader;

  /// No description provided for @wikimediaAccountHeader.
  ///
  /// In en, this message translates to:
  /// **'WIKIMEDIA ACCOUNT'**
  String get wikimediaAccountHeader;

  /// No description provided for @aboutComplianceHeader.
  ///
  /// In en, this message translates to:
  /// **'ABOUT & PLAY CONSOLE COMPLIANCE'**
  String get aboutComplianceHeader;

  /// No description provided for @captchaSecurityVerification.
  ///
  /// In en, this message translates to:
  /// **'Security Verification (CAPTCHA)'**
  String get captchaSecurityVerification;

  /// No description provided for @captchaVerificationMessage.
  ///
  /// In en, this message translates to:
  /// **'MediaWiki requires a quick verification before publishing this edit.'**
  String get captchaVerificationMessage;

  /// No description provided for @captchaEnterText.
  ///
  /// In en, this message translates to:
  /// **'Enter CAPTCHA text'**
  String get captchaEnterText;

  /// No description provided for @captchaAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Answer / Word'**
  String get captchaAnswerLabel;

  /// No description provided for @captchaRequired.
  ///
  /// In en, this message translates to:
  /// **'CAPTCHA response is required'**
  String get captchaRequired;

  /// No description provided for @verifyAndSubmit.
  ///
  /// In en, this message translates to:
  /// **'Verify & Submit'**
  String get verifyAndSubmit;

  /// No description provided for @channelPolicy.
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get channelPolicy;

  /// No description provided for @channelPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Policy and guideline proposals, debates, and RFCs'**
  String get channelPolicyDesc;

  /// No description provided for @channelTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get channelTechnical;

  /// No description provided for @channelTechnicalDesc.
  ///
  /// In en, this message translates to:
  /// **'MediaWiki technical issues, templates, and bots'**
  String get channelTechnicalDesc;

  /// No description provided for @channelProposals.
  ///
  /// In en, this message translates to:
  /// **'Proposals'**
  String get channelProposals;

  /// No description provided for @channelProposalsDesc.
  ///
  /// In en, this message translates to:
  /// **'New proposals and ideas for the community'**
  String get channelProposalsDesc;

  /// No description provided for @channelIdeaLab.
  ///
  /// In en, this message translates to:
  /// **'Idea Lab'**
  String get channelIdeaLab;

  /// No description provided for @channelIdeaLabDesc.
  ///
  /// In en, this message translates to:
  /// **'Incubate early-stage proposals before RFC'**
  String get channelIdeaLabDesc;

  /// No description provided for @channelTeahouse.
  ///
  /// In en, this message translates to:
  /// **'Teahouse'**
  String get channelTeahouse;

  /// No description provided for @channelTeahouseDesc.
  ///
  /// In en, this message translates to:
  /// **'Friendly space for new editors to ask questions'**
  String get channelTeahouseDesc;

  /// No description provided for @channelMisc.
  ///
  /// In en, this message translates to:
  /// **'Miscellaneous'**
  String get channelMisc;

  /// No description provided for @channelMiscDesc.
  ///
  /// In en, this message translates to:
  /// **'General discussions not fitting other pumps'**
  String get channelMiscDesc;

  /// No description provided for @channelNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get channelNews;

  /// No description provided for @channelNewsDesc.
  ///
  /// In en, this message translates to:
  /// **'Project announcements, contests, and community news'**
  String get channelNewsDesc;

  /// No description provided for @channelLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get channelLanguage;

  /// No description provided for @channelLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Grammar, translation terms, and spelling rules'**
  String get channelLanguageDesc;

  /// No description provided for @channelCommunityDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Community Discussion'**
  String get channelCommunityDiscussion;

  /// No description provided for @channelMainDiscussionBoard.
  ///
  /// In en, this message translates to:
  /// **'Main discussion board on {domain}'**
  String channelMainDiscussionBoard(String domain);

  /// No description provided for @channelDiscussionPageOn.
  ///
  /// In en, this message translates to:
  /// **'Discussion page on {domain}'**
  String channelDiscussionPageOn(String domain);

  /// No description provided for @failedToLoadCaptchaImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load CAPTCHA image.'**
  String get failedToLoadCaptchaImage;

  /// No description provided for @emptyComment.
  ///
  /// In en, this message translates to:
  /// **'Empty comment'**
  String get emptyComment;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @noInternetDescription.
  ///
  /// In en, this message translates to:
  /// **'Discussions cannot be loaded without an internet connection. Please check your network and retry.'**
  String get noInternetDescription;

  /// No description provided for @offlineWarning.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline. Check your internet connection.'**
  String get offlineWarning;

  /// No description provided for @offlineCachedNotice.
  ///
  /// In en, this message translates to:
  /// **'Offline mode: Showing cached discussions.'**
  String get offlineCachedNotice;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get openInBrowser;

  /// No description provided for @openInBrowserTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open this page in external web browser'**
  String get openInBrowserTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
