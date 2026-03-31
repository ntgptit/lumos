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

  /// Short application name used in shared shells and splash UI
  ///
  /// In en, this message translates to:
  /// **'Lumos'**
  String get appName;

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

  /// No description provided for @commonSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get commonSortBy;

  /// No description provided for @commonDirection.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get commonDirection;

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

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get commonShowPassword;

  /// No description provided for @commonHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get commonHidePassword;

  /// No description provided for @commonSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonSomethingWentWrong;

  /// No description provided for @commonCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get commonCorrect;

  /// No description provided for @commonIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get commonIncorrect;

  /// No description provided for @commonResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get commonResult;

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

  /// No description provided for @deckSearchResultsFor.
  ///
  /// In en, this message translates to:
  /// **'Search results for: {query}'**
  String deckSearchResultsFor(Object query);

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

  /// No description provided for @folderSortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get folderSortByName;

  /// No description provided for @folderSortByCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created time'**
  String get folderSortByCreatedAt;

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

  /// No description provided for @folderSubfolderCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 subfolders} =1 {1 subfolder} other {{count} subfolders}}'**
  String folderSubfolderCount(int count);

  /// No description provided for @folderDeckCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 decks} =1 {1 deck} other {{count} decks}}'**
  String folderDeckCount(int count);

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

  /// No description provided for @deckSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort decks'**
  String get deckSortTitle;

  /// No description provided for @deckSortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get deckSortByName;

  /// No description provided for @deckSortNameAscending.
  ///
  /// In en, this message translates to:
  /// **'Name A-Z'**
  String get deckSortNameAscending;

  /// No description provided for @deckSortNameDescending.
  ///
  /// In en, this message translates to:
  /// **'Name Z-A'**
  String get deckSortNameDescending;

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

  /// No description provided for @deckLibraryEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Decks live inside folders.'**
  String get deckLibraryEntryTitle;

  /// No description provided for @deckLibraryEntryMessage.
  ///
  /// In en, this message translates to:
  /// **'Open your folders to create, search, and manage decks in context.'**
  String get deckLibraryEntryMessage;

  /// No description provided for @deckLibraryEntryAction.
  ///
  /// In en, this message translates to:
  /// **'Open folders'**
  String get deckLibraryEntryAction;

  /// No description provided for @libraryRootFolderCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No root folders} =1 {# root folder} other {# root folders}}'**
  String libraryRootFolderCount(int count);

  /// No description provided for @librarySearchEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another keyword or open Folders to browse the full tree.'**
  String get librarySearchEmptyMessage;

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

  /// No description provided for @flashcardHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Study, review, and manage cards in this deck.'**
  String get flashcardHeroSubtitle;

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

  /// No description provided for @flashcardPlusBadge.
  ///
  /// In en, this message translates to:
  /// **'Plus'**
  String get flashcardPlusBadge;

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

  /// No description provided for @flashcardReviewActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcardReviewActionLabel;

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

  /// No description provided for @flashcardQuizActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get flashcardQuizActionLabel;

  /// No description provided for @flashcardMatchActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get flashcardMatchActionLabel;

  /// No description provided for @flashcardBlastActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Blast'**
  String get flashcardBlastActionLabel;

  /// No description provided for @flashcardStudyModesTitle.
  ///
  /// In en, this message translates to:
  /// **'Study modes'**
  String get flashcardStudyModesTitle;

  /// No description provided for @flashcardProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get flashcardProgressTitle;

  /// No description provided for @flashcardProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'Your progress is based on your last two study attempts across every mode, excluding games.'**
  String get flashcardProgressDescription;

  /// No description provided for @flashcardProgressNotStartedLabel.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get flashcardProgressNotStartedLabel;

  /// No description provided for @flashcardProgressLearningLabel.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get flashcardProgressLearningLabel;

  /// No description provided for @flashcardProgressMasteredLabel.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get flashcardProgressMasteredLabel;

  /// No description provided for @flashcardStudyDeckButton.
  ///
  /// In en, this message translates to:
  /// **'Study this deck'**
  String get flashcardStudyDeckButton;

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

  /// No description provided for @flashcardShareButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share deck'**
  String get flashcardShareButtonTooltip;

  /// No description provided for @flashcardMoreButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get flashcardMoreButtonTooltip;

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

  /// No description provided for @flashcardShareComingSoonToast.
  ///
  /// In en, this message translates to:
  /// **'Sharing will be available soon.'**
  String get flashcardShareComingSoonToast;

  /// No description provided for @flashcardMoreOptionsComingSoonToast.
  ///
  /// In en, this message translates to:
  /// **'More options will be available soon.'**
  String get flashcardMoreOptionsComingSoonToast;

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

  /// No description provided for @flashcardLearnSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your study path'**
  String get flashcardLearnSheetTitle;

  /// No description provided for @flashcardLearnSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the session you want to start for this deck.'**
  String get flashcardLearnSheetSubtitle;

  /// No description provided for @flashcardLearnContinueOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get flashcardLearnContinueOptionTitle;

  /// No description provided for @flashcardLearnContinueOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Study vocabulary that is still new or not yet passed.'**
  String get flashcardLearnContinueOptionSubtitle;

  /// No description provided for @flashcardLearnReviewOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Review due cards'**
  String get flashcardLearnReviewOptionTitle;

  /// No description provided for @flashcardLearnReviewOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review vocabulary that has reached its SRS deadline.'**
  String get flashcardLearnReviewOptionSubtitle;

  /// No description provided for @flashcardLearnResetOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset study progress'**
  String get flashcardLearnResetOptionTitle;

  /// No description provided for @flashcardLearnResetOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the learning progress for this deck and start again.'**
  String get flashcardLearnResetOptionSubtitle;

  /// No description provided for @flashcardLearnContinueUnavailableToast.
  ///
  /// In en, this message translates to:
  /// **'No new or unfinished vocabulary is available right now.'**
  String get flashcardLearnContinueUnavailableToast;

  /// No description provided for @flashcardLearnReviewUnavailableToast.
  ///
  /// In en, this message translates to:
  /// **'No vocabulary is currently due for review.'**
  String get flashcardLearnReviewUnavailableToast;

  /// No description provided for @flashcardLearnResetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset study progress?'**
  String get flashcardLearnResetConfirmTitle;

  /// No description provided for @flashcardLearnResetConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will reset the learning progress for the current deck.'**
  String get flashcardLearnResetConfirmMessage;

  /// No description provided for @flashcardLearnResetConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Reset progress'**
  String get flashcardLearnResetConfirmAction;

  /// No description provided for @flashcardLearnResetSuccessToast.
  ///
  /// In en, this message translates to:
  /// **'Study progress has been reset.'**
  String get flashcardLearnResetSuccessToast;

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

  /// No description provided for @homeProfileQuickName.
  ///
  /// In en, this message translates to:
  /// **'Learner'**
  String get homeProfileQuickName;

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

  /// No description provided for @profileAccountSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccountSectionTitle;

  /// No description provided for @profileAccountSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review the identity and status for your current signed-in account.'**
  String get profileAccountSectionSubtitle;

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

  /// No description provided for @commonLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get commonLogout;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get commonCheck;

  /// No description provided for @commonReplay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get commonReplay;

  /// No description provided for @navigationDashboardLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationDashboardLabel;

  /// No description provided for @navigationFoldersLabel.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get navigationFoldersLabel;

  /// No description provided for @navigationDecksLabel.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navigationDecksLabel;

  /// No description provided for @navigationProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navigationProgressLabel;

  /// No description provided for @navigationSettingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navigationSettingsLabel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparing your learning workspace'**
  String get splashTitle;

  /// No description provided for @clearSelectionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelectionTooltip;

  /// No description provided for @selectionCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectionCountLabel(int count);

  /// No description provided for @filterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTooltip;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortTooltip;

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsTitle;

  /// No description provided for @noResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search terms.'**
  String get noResultsMessage;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offlineTitle;

  /// No description provided for @offlineMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get offlineMessage;

  /// No description provided for @offlineRetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get offlineRetryLabel;

  /// No description provided for @accessRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Access required'**
  String get accessRequiredTitle;

  /// No description provided for @signInMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue.'**
  String get signInMessage;

  /// No description provided for @signInLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLabel;

  /// No description provided for @selectDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDateLabel;

  /// No description provided for @clearDateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get clearDateTooltip;

  /// No description provided for @requiredFieldMark.
  ///
  /// In en, this message translates to:
  /// **' *'**
  String get requiredFieldMark;

  /// No description provided for @searchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchLabel;

  /// No description provided for @clearSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearchTooltip;

  /// No description provided for @selectTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTimeLabel;

  /// No description provided for @clearTimeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear time'**
  String get clearTimeTooltip;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'The system is temporarily unavailable.'**
  String get maintenanceMessage;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @notFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The requested page does not exist.'**
  String get notFoundMessage;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Lumos'**
  String get authTitle;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Authenticate first, then resume study from canonical backend state.'**
  String get authSubtitle;

  /// No description provided for @authLoginTab.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginTab;

  /// No description provided for @authRegisterTab.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegisterTab;

  /// No description provided for @authSignInAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInAction;

  /// No description provided for @authCreateAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccountAction;

  /// No description provided for @authUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsernameLabel;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authUsernameOrEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get authUsernameOrEmailLabel;

  /// No description provided for @authShowPasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPasswordTooltip;

  /// No description provided for @authHidePasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePasswordTooltip;

  /// No description provided for @profileSpeechSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Speech preference'**
  String get profileSpeechSectionTitle;

  /// No description provided for @profileSpeechSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the default reading voice for this device and test it before studying.'**
  String get profileSpeechSectionSubtitle;

  /// No description provided for @profileSpeechEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable Korean speech'**
  String get profileSpeechEnabledLabel;

  /// No description provided for @profileSpeechAutoPlayLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto play current item'**
  String get profileSpeechAutoPlayLabel;

  /// No description provided for @profileSpeechAdapterLabel.
  ///
  /// In en, this message translates to:
  /// **'Speech engine'**
  String get profileSpeechAdapterLabel;

  /// No description provided for @profileSpeechAdapterFlutterTtsLabel.
  ///
  /// In en, this message translates to:
  /// **'Device TTS (Flutter TTS)'**
  String get profileSpeechAdapterFlutterTtsLabel;

  /// No description provided for @profileSpeechVoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get profileSpeechVoiceLabel;

  /// No description provided for @profileSpeechVoiceDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Device default voice'**
  String get profileSpeechVoiceDefaultLabel;

  /// No description provided for @profileSpeechSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get profileSpeechSpeedLabel;

  /// No description provided for @profileSpeechPitchLabel.
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get profileSpeechPitchLabel;

  /// No description provided for @profileSpeechPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice preview'**
  String get profileSpeechPreviewTitle;

  /// No description provided for @profileSpeechPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit the sample text below and listen with the current voice, speed, and pitch.'**
  String get profileSpeechPreviewSubtitle;

  /// No description provided for @profileSpeechPreviewTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview text'**
  String get profileSpeechPreviewTextLabel;

  /// No description provided for @profileSpeechPreviewPlayLabel.
  ///
  /// In en, this message translates to:
  /// **'Play preview'**
  String get profileSpeechPreviewPlayLabel;

  /// No description provided for @profileSpeechPreviewStopLabel.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get profileSpeechPreviewStopLabel;

  /// No description provided for @profileSpeechPreviewDefaultText.
  ///
  /// In en, this message translates to:
  /// **'안녕하세요. 이 문장은 현재 음성과 속도, 음높이를 테스트하기 위한 예시입니다.'**
  String get profileSpeechPreviewDefaultText;

  /// No description provided for @profileSpeechPreviewPlaybackError.
  ///
  /// In en, this message translates to:
  /// **'The device could not play the preview audio.'**
  String get profileSpeechPreviewPlaybackError;

  /// No description provided for @profileLogoutSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out on this device without affecting your saved learning data.'**
  String get profileLogoutSectionSubtitle;

  /// No description provided for @profileStudySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Study preference'**
  String get profileStudySectionTitle;

  /// No description provided for @profileStudySectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set how many new cards a FIRST_LEARNING session can load from the backend.'**
  String get profileStudySectionSubtitle;

  /// No description provided for @profileStudyFirstLearningLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'New cards per FIRST_LEARNING session'**
  String get profileStudyFirstLearningLimitLabel;

  /// No description provided for @profileStudyFirstLearningLimitValue.
  ///
  /// In en, this message translates to:
  /// **'{count} card(s)'**
  String profileStudyFirstLearningLimitValue(int count);

  /// No description provided for @profileStudyReviewHint.
  ///
  /// In en, this message translates to:
  /// **'REVIEW sessions always include every due card.'**
  String get profileStudyReviewHint;

  /// No description provided for @studyProgressMomentumTitle.
  ///
  /// In en, this message translates to:
  /// **'Study momentum'**
  String get studyProgressMomentumTitle;

  /// No description provided for @studyProgressMomentumSummary.
  ///
  /// In en, this message translates to:
  /// **'Due {dueCount} | Overdue {overdueCount} | Escalation {escalationLevel}'**
  String studyProgressMomentumSummary(int dueCount, int overdueCount, Object escalationLevel);

  /// No description provided for @studyProgressRecommendedReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended review'**
  String get studyProgressRecommendedReviewTitle;

  /// No description provided for @studyProgressRecommendedReviewSummary.
  ///
  /// In en, this message translates to:
  /// **'{deckName} · {dueCount} due items'**
  String studyProgressRecommendedReviewSummary(Object deckName, int dueCount);

  /// No description provided for @studyProgressStartReviewAction.
  ///
  /// In en, this message translates to:
  /// **'Start review'**
  String get studyProgressStartReviewAction;

  /// No description provided for @studyProgressBoxDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'7-box distribution'**
  String get studyProgressBoxDistributionTitle;

  /// No description provided for @studyProgressBoxLabel.
  ///
  /// In en, this message translates to:
  /// **'Box {boxIndex}'**
  String studyProgressBoxLabel(int boxIndex);

  /// No description provided for @studyMatchCheckAction.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get studyMatchCheckAction;

  /// No description provided for @studyMatchCompletedItemLabel.
  ///
  /// In en, this message translates to:
  /// **'Matched · {label}'**
  String studyMatchCompletedItemLabel(Object label);

  /// No description provided for @studySpeechPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Text to speech · {locale}'**
  String studySpeechPanelTitle(Object locale);

  /// No description provided for @studySpeechPanelVoiceSummary.
  ///
  /// In en, this message translates to:
  /// **'Voice: {voice} · Speed: {speed}x'**
  String studySpeechPanelVoiceSummary(Object voice, Object speed);

  /// No description provided for @studySpeechPlayAction.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get studySpeechPlayAction;

  /// No description provided for @studySpeechPlayingAction.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get studySpeechPlayingAction;

  /// No description provided for @studySpeechReplayAction.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get studySpeechReplayAction;

  /// No description provided for @studyReviewFirstCardToast.
  ///
  /// In en, this message translates to:
  /// **'This is the first card.'**
  String get studyReviewFirstCardToast;

  /// No description provided for @studyResetCurrentModeAction.
  ///
  /// In en, this message translates to:
  /// **'Reset current mode'**
  String get studyResetCurrentModeAction;

  /// No description provided for @studyResetCurrentModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset current mode?'**
  String get studyResetCurrentModeTitle;

  /// No description provided for @studyResetCurrentModeMessage.
  ///
  /// In en, this message translates to:
  /// **'This will clear all progress in the current mode and start that mode again from the first item.'**
  String get studyResetCurrentModeMessage;

  /// No description provided for @studyResetCurrentModeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reset mode'**
  String get studyResetCurrentModeConfirm;

  /// No description provided for @deckEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit deck'**
  String get deckEditTooltip;

  /// No description provided for @deckDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete deck'**
  String get deckDeleteTooltip;

  /// No description provided for @flashcardAgainAction.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get flashcardAgainAction;

  /// No description provided for @flashcardKnownAction.
  ///
  /// In en, this message translates to:
  /// **'Known'**
  String get flashcardKnownAction;

  /// No description provided for @exerciseMatchPairsTitle.
  ///
  /// In en, this message translates to:
  /// **'Match pairs'**
  String get exerciseMatchPairsTitle;

  /// No description provided for @exerciseCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get exerciseCompletedLabel;

  /// No description provided for @exerciseSubmitMatchesLabel.
  ///
  /// In en, this message translates to:
  /// **'Submit matches'**
  String get exerciseSubmitMatchesLabel;

  /// No description provided for @exerciseReorderWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder words'**
  String get exerciseReorderWordsTitle;

  /// No description provided for @exerciseCheckOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Check order'**
  String get exerciseCheckOrderLabel;

  /// No description provided for @exerciseListeningTitle.
  ///
  /// In en, this message translates to:
  /// **'Listening exercise'**
  String get exerciseListeningTitle;

  /// No description provided for @feedbackGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get feedbackGreatJob;

  /// No description provided for @feedbackResultSummaryCorrect.
  ///
  /// In en, this message translates to:
  /// **'{correctCount} / {totalCount} correct'**
  String feedbackResultSummaryCorrect(int correctCount, int totalCount);

  /// No description provided for @feedbackResultSummaryXpEarned.
  ///
  /// In en, this message translates to:
  /// **'XP earned: {xpEarned}'**
  String feedbackResultSummaryXpEarned(int xpEarned);

  /// No description provided for @feedbackResultSummaryStreakBonus.
  ///
  /// In en, this message translates to:
  /// **'Streak bonus: +{streakBonus} XP'**
  String feedbackResultSummaryStreakBonus(int streakBonus);

  /// No description provided for @gamificationLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String gamificationLevelLabel(int level);

  /// No description provided for @gamificationXpLabel.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String gamificationXpLabel(int xp);

  /// No description provided for @gamificationDailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get gamificationDailyGoalTitle;

  /// No description provided for @gamificationDailyGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'{current}/{goal} {unit}'**
  String gamificationDailyGoalProgress(int current, int goal, Object unit);

  /// No description provided for @learningReviewProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {total} reviewed'**
  String learningReviewProgressLabel(int completed, int total);

  /// No description provided for @learningEstimateMinutesLeft.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left'**
  String learningEstimateMinutesLeft(int minutes);

  /// No description provided for @learningStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get learningStatisticsTitle;

  /// No description provided for @learningStatisticsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {count}'**
  String learningStatisticsTotal(int count);

  /// No description provided for @learningStatisticsMastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered: {count}'**
  String learningStatisticsMastered(int count);

  /// No description provided for @learningStatisticsLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning: {count}'**
  String learningStatisticsLearning(int count);

  /// No description provided for @learningStatisticsDue.
  ///
  /// In en, this message translates to:
  /// **'Due: {count}'**
  String learningStatisticsDue(int count);

  /// No description provided for @learningReviewQueueDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today: {count}'**
  String learningReviewQueueDueToday(int count);

  /// No description provided for @learningReviewQueueSize.
  ///
  /// In en, this message translates to:
  /// **'Queue size: {count}'**
  String learningReviewQueueSize(int count);

  /// No description provided for @learningStartReviewAction.
  ///
  /// In en, this message translates to:
  /// **'Start review'**
  String get learningStartReviewAction;

  /// No description provided for @onboardingPlacementTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Placement Test'**
  String get onboardingPlacementTestTitle;

  /// No description provided for @onboardingQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String onboardingQuestionCount(int count);

  /// No description provided for @onboardingCompleteTestAction.
  ///
  /// In en, this message translates to:
  /// **'Complete test'**
  String get onboardingCompleteTestAction;

  /// No description provided for @formAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer'**
  String get formAnswerHint;

  /// No description provided for @studyFillAnswerRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'Answer is required.'**
  String get studyFillAnswerRequiredValidation;

  /// No description provided for @formTapToSpeakAction.
  ///
  /// In en, this message translates to:
  /// **'Tap to speak'**
  String get formTapToSpeakAction;

  /// No description provided for @formFillBlankHint.
  ///
  /// In en, this message translates to:
  /// **'Fill the blank'**
  String get formFillBlankHint;

  /// No description provided for @placeholderForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get placeholderForgotPasswordTitle;

  /// No description provided for @placeholderForgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Password recovery flow has not been wired back yet.'**
  String get placeholderForgotPasswordMessage;

  /// No description provided for @placeholderDeckListTitle.
  ///
  /// In en, this message translates to:
  /// **'Decks'**
  String get placeholderDeckListTitle;

  /// No description provided for @placeholderDeckListMessage.
  ///
  /// In en, this message translates to:
  /// **'Deck list adapter is active.'**
  String get placeholderDeckListMessage;

  /// No description provided for @placeholderDeckListInFolderMessage.
  ///
  /// In en, this message translates to:
  /// **'Deck list adapter is active for folder {folderId}.'**
  String placeholderDeckListInFolderMessage(int folderId);

  /// No description provided for @placeholderOnboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get placeholderOnboardingTitle;

  /// No description provided for @placeholderPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get placeholderPermissionsTitle;

  /// No description provided for @placeholderStudyGoalSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Goal Setup'**
  String get placeholderStudyGoalSetupTitle;

  /// No description provided for @placeholderDeckProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck Progress'**
  String get placeholderDeckProgressTitle;

  /// No description provided for @placeholderDeckProgressMessage.
  ///
  /// In en, this message translates to:
  /// **'Deck {deckId} progress adapter is active.'**
  String placeholderDeckProgressMessage(int deckId);

  /// No description provided for @placeholderStudyCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Calendar'**
  String get placeholderStudyCalendarTitle;

  /// No description provided for @placeholderReminderPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Preview'**
  String get placeholderReminderPreviewTitle;

  /// No description provided for @placeholderReminderSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Settings'**
  String get placeholderReminderSettingsTitle;

  /// No description provided for @placeholderReminderTimeSlotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time Slots'**
  String get placeholderReminderTimeSlotsTitle;

  /// No description provided for @placeholderAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get placeholderAboutTitle;

  /// No description provided for @placeholderAudioSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio Settings'**
  String get placeholderAudioSettingsTitle;

  /// No description provided for @placeholderBackupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get placeholderBackupRestoreTitle;

  /// No description provided for @placeholderLanguageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get placeholderLanguageSettingsTitle;

  /// No description provided for @placeholderThemeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get placeholderThemeSettingsTitle;

  /// No description provided for @placeholderStudyHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Study History'**
  String get placeholderStudyHistoryTitle;

  /// No description provided for @placeholderStudyModePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Mode Picker'**
  String get placeholderStudyModePickerTitle;

  /// No description provided for @placeholderStudyModePickerReviewAction.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get placeholderStudyModePickerReviewAction;

  /// No description provided for @placeholderStudyResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Result'**
  String get placeholderStudyResultTitle;

  /// No description provided for @placeholderStudyResultRestartAction.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get placeholderStudyResultRestartAction;

  /// No description provided for @placeholderStudyResultHistoryAction.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get placeholderStudyResultHistoryAction;

  /// No description provided for @placeholderStudyResultReturnAction.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get placeholderStudyResultReturnAction;

  /// No description provided for @placeholderStudySessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Session'**
  String get placeholderStudySessionTitle;

  /// No description provided for @placeholderStudySessionModePickerAction.
  ///
  /// In en, this message translates to:
  /// **'Mode Picker'**
  String get placeholderStudySessionModePickerAction;

  /// No description provided for @placeholderStudySessionFinishAction.
  ///
  /// In en, this message translates to:
  /// **'Finish Session'**
  String get placeholderStudySessionFinishAction;

  /// No description provided for @placeholderStudySessionExitAction.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get placeholderStudySessionExitAction;

  /// No description provided for @placeholderStudySetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Setup'**
  String get placeholderStudySetupTitle;

  /// No description provided for @placeholderStudySetupStartAction.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get placeholderStudySetupStartAction;

  /// No description provided for @placeholderStudySetupModePickerAction.
  ///
  /// In en, this message translates to:
  /// **'Mode Picker'**
  String get placeholderStudySetupModePickerAction;

  /// No description provided for @placeholderStudySetupHistoryAction.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get placeholderStudySetupHistoryAction;
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
