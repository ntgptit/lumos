import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// Default application title
  ///
  /// In en, this message translates to:
  /// **'Lumos'**
  String get appTitle;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get commonRename;

  /// No description provided for @folderNewFolder.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get folderNewFolder;

  /// No description provided for @folderCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get folderCreateTitle;

  /// No description provided for @folderRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get folderRenameTitle;

  /// No description provided for @folderDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get folderDeleteTitle;

  /// No description provided for @folderNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderNameLabel;

  /// No description provided for @folderManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Folder Manager'**
  String get folderManagerTitle;

  /// No description provided for @folderManagerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse tree, create, rename, and soft-delete folders.'**
  String get folderManagerSubtitle;

  /// No description provided for @folderSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search folders'**
  String get folderSearchHint;

  /// No description provided for @folderSearchClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get folderSearchClearTooltip;

  /// No description provided for @folderOpenParentTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open parent folder'**
  String get folderOpenParentTooltip;

  /// No description provided for @folderSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort folders'**
  String get folderSortTitle;

  /// No description provided for @folderSortNameAscending.
  ///
  /// In en, this message translates to:
  /// **'Name A-Z'**
  String get folderSortNameAscending;

  /// No description provided for @folderSortNameDescending.
  ///
  /// In en, this message translates to:
  /// **'Name Z-A'**
  String get folderSortNameDescending;

  /// No description provided for @folderSortCreatedNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest created'**
  String get folderSortCreatedNewest;

  /// No description provided for @folderSortCreatedOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest created'**
  String get folderSortCreatedOldest;

  /// No description provided for @folderRoot.
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get folderRoot;

  /// No description provided for @folderEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No folders here yet.'**
  String get folderEmptyTitle;

  /// No description provided for @folderEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create one to start organizing content.'**
  String get folderEmptySubtitle;

  /// No description provided for @folderSearchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No folders match your search.'**
  String get folderSearchEmptyTitle;

  /// No description provided for @folderSearchEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different keyword.'**
  String get folderSearchEmptySubtitle;

  /// No description provided for @folderNameRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'Folder name is required.'**
  String get folderNameRequiredValidation;

  /// No description provided for @folderNameMinLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Folder name must be at least {min} character(s).'**
  String folderNameMinLengthValidation(int min);

  /// No description provided for @folderNameMaxLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Folder name must be at most {max} character(s).'**
  String folderNameMaxLengthValidation(int max);

  /// No description provided for @folderDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\" and all subfolders?'**
  String folderDeleteConfirm(Object name);

  /// No description provided for @folderDepth.
  ///
  /// In en, this message translates to:
  /// **'Depth {depth}'**
  String folderDepth(int depth);

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good evening, Learner'**
  String get homeGreeting;

  /// No description provided for @homeGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'You are 78% closer to your weekly goal.'**
  String get homeGoalProgress;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Build fluency with momentum'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Daily sessions, focused practice, and visual progress in one modern workspace.'**
  String get homeHeroBody;

  /// No description provided for @homeAiLearningPath.
  ///
  /// In en, this message translates to:
  /// **'AI Learning Path'**
  String get homeAiLearningPath;

  /// No description provided for @homePrimaryAction.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get homePrimaryAction;

  /// No description provided for @homeSecondaryAction.
  ///
  /// In en, this message translates to:
  /// **'Review Deck'**
  String get homeSecondaryAction;

  /// No description provided for @homeStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get homeStreakLabel;

  /// No description provided for @homeAccuracyLabel.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get homeAccuracyLabel;

  /// No description provided for @homeXpLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly XP'**
  String get homeXpLabel;

  /// No description provided for @homeStatStreakValue.
  ///
  /// In en, this message translates to:
  /// **'12 days'**
  String get homeStatStreakValue;

  /// No description provided for @homeStatAccuracyValue.
  ///
  /// In en, this message translates to:
  /// **'94%'**
  String get homeStatAccuracyValue;

  /// No description provided for @homeStatXpValue.
  ///
  /// In en, this message translates to:
  /// **'2,460'**
  String get homeStatXpValue;

  /// No description provided for @homeFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Focus'**
  String get homeFocusTitle;

  /// No description provided for @homeTaskShadowListeningTitle.
  ///
  /// In en, this message translates to:
  /// **'Shadow listening - 15 min'**
  String get homeTaskShadowListeningTitle;

  /// No description provided for @homeTaskVocabularyTitle.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary sprint - 20 words'**
  String get homeTaskVocabularyTitle;

  /// No description provided for @homeTaskPronunciationTitle.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation drill - 10 min'**
  String get homeTaskPronunciationTitle;

  /// No description provided for @homeActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get homeActivityTitle;

  /// No description provided for @homeActivitySpanishTitle.
  ///
  /// In en, this message translates to:
  /// **'Spanish Travel Pack'**
  String get homeActivitySpanishTitle;

  /// No description provided for @homeActivitySpanishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed 18 cards'**
  String get homeActivitySpanishSubtitle;

  /// No description provided for @homeActivitySpanishTrailing.
  ///
  /// In en, this message translates to:
  /// **'+120 XP'**
  String get homeActivitySpanishTrailing;

  /// No description provided for @homeActivityGrammarTitle.
  ///
  /// In en, this message translates to:
  /// **'Grammar: Present Perfect'**
  String get homeActivityGrammarTitle;

  /// No description provided for @homeActivityGrammarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scored 9/10'**
  String get homeActivityGrammarSubtitle;

  /// No description provided for @homeActivityGrammarTrailing.
  ///
  /// In en, this message translates to:
  /// **'+60 XP'**
  String get homeActivityGrammarTrailing;

  /// No description provided for @homeActivitySpeakingTitle.
  ///
  /// In en, this message translates to:
  /// **'Speaking Challenge'**
  String get homeActivitySpeakingTitle;

  /// No description provided for @homeActivitySpeakingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New best streak: 5'**
  String get homeActivitySpeakingSubtitle;

  /// No description provided for @homeActivitySpeakingTrailing.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get homeActivitySpeakingTrailing;

  /// No description provided for @homeTabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTabHome;

  /// No description provided for @homeTabLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get homeTabLibrary;

  /// No description provided for @homeTabFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get homeTabFolders;

  /// No description provided for @homeTabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get homeTabProgress;

  /// No description provided for @homeTabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeTabProfile;

  /// No description provided for @homeLibrarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your decks, lessons, and curated packs.'**
  String get homeLibrarySubtitle;

  /// No description provided for @homeProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track streaks, XP trends, and weak skills.'**
  String get homeProgressSubtitle;

  /// No description provided for @homeProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your goals and learning preferences.'**
  String get homeProfileSubtitle;

  /// No description provided for @profileThemeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileThemeSectionTitle;

  /// No description provided for @profileThemeSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how the app theme is displayed.'**
  String get profileThemeSectionSubtitle;

  /// No description provided for @profileThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get profileThemeSystem;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profileThemeDark;

  /// No description provided for @profileThemeToggleToLight.
  ///
  /// In en, this message translates to:
  /// **'Quick switch to light mode'**
  String get profileThemeToggleToLight;

  /// No description provided for @profileThemeToggleToDark.
  ///
  /// In en, this message translates to:
  /// **'Quick switch to dark mode'**
  String get profileThemeToggleToDark;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
