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

  /// No description provided for @folderDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get folderDescriptionLabel;

  /// No description provided for @folderDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter folder description'**
  String get folderDescriptionHint;

  /// No description provided for @folderColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get folderColorLabel;

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

  /// No description provided for @deckManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck Manager'**
  String get deckManagerTitle;

  /// No description provided for @deckManagerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage decks in this folder.'**
  String get deckManagerSubtitle;

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

  /// No description provided for @deckSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search decks'**
  String get deckSearchHint;

  /// No description provided for @deckSearchClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear deck search'**
  String get deckSearchClearTooltip;

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

  /// No description provided for @folderDescriptionMaxLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Description must be at most {max} character(s).'**
  String folderDescriptionMaxLengthValidation(int max);

  /// No description provided for @folderColorInvalidValidation.
  ///
  /// In en, this message translates to:
  /// **'Folder color is invalid.'**
  String get folderColorInvalidValidation;

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

  /// No description provided for @deckNewDeck.
  ///
  /// In en, this message translates to:
  /// **'New Deck'**
  String get deckNewDeck;

  /// No description provided for @deckCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create deck'**
  String get deckCreateTitle;

  /// No description provided for @deckRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename deck'**
  String get deckRenameTitle;

  /// No description provided for @deckDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete deck'**
  String get deckDeleteTitle;

  /// No description provided for @deckNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Deck name'**
  String get deckNameLabel;

  /// No description provided for @deckDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get deckDescriptionLabel;

  /// No description provided for @deckDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter deck description'**
  String get deckDescriptionHint;

  /// No description provided for @deckEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No decks here yet.'**
  String get deckEmptyTitle;

  /// No description provided for @deckEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a deck to start organizing cards.'**
  String get deckEmptySubtitle;

  /// No description provided for @deckSearchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No decks match your search.'**
  String get deckSearchEmptyTitle;

  /// No description provided for @deckSearchEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different keyword.'**
  String get deckSearchEmptySubtitle;

  /// No description provided for @deckNameRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'Deck name is required.'**
  String get deckNameRequiredValidation;

  /// No description provided for @deckNameMinLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Deck name must be at least {min} character(s).'**
  String deckNameMinLengthValidation(int min);

  /// No description provided for @deckNameMaxLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Deck name must be at most {max} character(s).'**
  String deckNameMaxLengthValidation(int max);

  /// No description provided for @deckDescriptionMaxLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Description must be at most {max} character(s).'**
  String deckDescriptionMaxLengthValidation(int max);

  /// No description provided for @deckDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete deck \"{name}\"?'**
  String deckDeleteConfirm(Object name);

  /// No description provided for @deckFlashcardCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String deckFlashcardCount(int count);

  /// No description provided for @deckCount.
  ///
  /// In en, this message translates to:
  /// **'{count} deck(s)'**
  String deckCount(int count);

  /// No description provided for @flashcardTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcardTitle;

  /// No description provided for @flashcardCreateButton.
  ///
  /// In en, this message translates to:
  /// **'New Card'**
  String get flashcardCreateButton;

  /// No description provided for @flashcardCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create flashcard'**
  String get flashcardCreateTitle;

  /// No description provided for @flashcardEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit flashcard'**
  String get flashcardEditTitle;

  /// No description provided for @flashcardDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete flashcard'**
  String get flashcardDeleteTitle;

  /// No description provided for @flashcardDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String flashcardDeleteConfirm(Object name);

  /// No description provided for @flashcardSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search flashcards'**
  String get flashcardSearchHint;

  /// No description provided for @flashcardSearchClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear flashcard search'**
  String get flashcardSearchClearTooltip;

  /// No description provided for @flashcardToggleSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle flashcard search'**
  String get flashcardToggleSearchTooltip;

  /// No description provided for @flashcardSortButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort flashcards'**
  String get flashcardSortButtonTooltip;

  /// No description provided for @flashcardSortSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort flashcards'**
  String get flashcardSortSheetTitle;

  /// No description provided for @flashcardSortByCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created time'**
  String get flashcardSortByCreatedAt;

  /// No description provided for @flashcardSortByUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated time'**
  String get flashcardSortByUpdatedAt;

  /// No description provided for @flashcardSortByFrontText.
  ///
  /// In en, this message translates to:
  /// **'Front text'**
  String get flashcardSortByFrontText;

  /// No description provided for @flashcardSortDirectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get flashcardSortDirectionDesc;

  /// No description provided for @flashcardSortDirectionAsc.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get flashcardSortDirectionAsc;

  /// No description provided for @flashcardSortDirectionAz.
  ///
  /// In en, this message translates to:
  /// **'A-Z'**
  String get flashcardSortDirectionAz;

  /// No description provided for @flashcardSortDirectionZa.
  ///
  /// In en, this message translates to:
  /// **'Z-A'**
  String get flashcardSortDirectionZa;

  /// No description provided for @flashcardSortSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Apply sort'**
  String get flashcardSortSaveButton;

  /// No description provided for @flashcardCardSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get flashcardCardSectionTitle;

  /// No description provided for @flashcardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No flashcards yet.'**
  String get flashcardEmptyTitle;

  /// No description provided for @flashcardEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first card to start learning.'**
  String get flashcardEmptySubtitle;

  /// No description provided for @flashcardSearchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching flashcards.'**
  String get flashcardSearchEmptyTitle;

  /// No description provided for @flashcardSearchEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another keyword.'**
  String get flashcardSearchEmptySubtitle;

  /// No description provided for @flashcardFrontLabel.
  ///
  /// In en, this message translates to:
  /// **'Front text'**
  String get flashcardFrontLabel;

  /// No description provided for @flashcardFrontHint.
  ///
  /// In en, this message translates to:
  /// **'Enter front text'**
  String get flashcardFrontHint;

  /// No description provided for @flashcardBackLabel.
  ///
  /// In en, this message translates to:
  /// **'Back text'**
  String get flashcardBackLabel;

  /// No description provided for @flashcardBackHint.
  ///
  /// In en, this message translates to:
  /// **'Enter back text'**
  String get flashcardBackHint;

  /// No description provided for @flashcardFrontRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'Front text is required.'**
  String get flashcardFrontRequiredValidation;

  /// No description provided for @flashcardFrontMaxLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Front text must be at most {max} character(s).'**
  String flashcardFrontMaxLengthValidation(int max);

  /// No description provided for @flashcardBackRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'Back text is required.'**
  String get flashcardBackRequiredValidation;

  /// No description provided for @flashcardBackMaxLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Back text must be at most {max} character(s).'**
  String flashcardBackMaxLengthValidation(int max);

  /// No description provided for @flashcardOwnerFallback.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get flashcardOwnerFallback;

  /// No description provided for @flashcardUpdatedRecentlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated recently'**
  String get flashcardUpdatedRecentlyLabel;

  /// No description provided for @flashcardTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} card(s)'**
  String flashcardTotalLabel(int count);

  /// No description provided for @flashcardExpandPreviewTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open card study'**
  String get flashcardExpandPreviewTooltip;

  /// No description provided for @flashcardPreviewPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No preview available'**
  String get flashcardPreviewPlaceholder;

  /// No description provided for @flashcardFlipActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Flip cards'**
  String get flashcardFlipActionLabel;

  /// No description provided for @flashcardLearnActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get flashcardLearnActionLabel;

  /// No description provided for @flashcardPlayAudioTooltip.
  ///
  /// In en, this message translates to:
  /// **'Play audio'**
  String get flashcardPlayAudioTooltip;

  /// No description provided for @flashcardBookmarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get flashcardBookmarkTooltip;

  /// No description provided for @flashcardEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit card'**
  String get flashcardEditTooltip;

  /// No description provided for @flashcardDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete card'**
  String get flashcardDeleteTooltip;

  /// No description provided for @flashcardAudioPlayToast.
  ///
  /// In en, this message translates to:
  /// **'Playing: {text}'**
  String flashcardAudioPlayToast(Object text);

  /// No description provided for @flashcardBookmarkToast.
  ///
  /// In en, this message translates to:
  /// **'Card bookmarked'**
  String get flashcardBookmarkToast;

  /// No description provided for @flashcardUnbookmarkToast.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get flashcardUnbookmarkToast;

  /// No description provided for @flashcardStudyUnavailableToast.
  ///
  /// In en, this message translates to:
  /// **'No cards available for study.'**
  String get flashcardStudyUnavailableToast;

  /// No description provided for @flashcardStudyCompletedToast.
  ///
  /// In en, this message translates to:
  /// **'Study session completed.'**
  String get flashcardStudyCompletedToast;

  /// No description provided for @flashcardCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close study'**
  String get flashcardCloseTooltip;

  /// No description provided for @flashcardPreviousButton.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get flashcardPreviousButton;

  /// No description provided for @flashcardNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get flashcardNextButton;

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
