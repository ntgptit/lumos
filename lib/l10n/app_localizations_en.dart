// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lumos';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSortBy => 'Sort by';

  @override
  String get commonDirection => 'Direction';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonRename => 'Rename';

  @override
  String get folderNewFolder => 'New Folder';

  @override
  String get folderCreateTitle => 'Create folder';

  @override
  String get folderRenameTitle => 'Rename folder';

  @override
  String get folderDeleteTitle => 'Delete folder';

  @override
  String get folderNameLabel => 'Folder name';

  @override
  String get folderDescriptionLabel => 'Description';

  @override
  String get folderDescriptionHint => 'Enter folder description';

  @override
  String get folderColorLabel => 'Color';

  @override
  String get folderManagerTitle => 'Folder Manager';

  @override
  String get folderManagerSubtitle => 'Browse tree, create, rename, and soft-delete folders.';

  @override
  String get deckManagerTitle => 'Deck Manager';

  @override
  String get deckManagerSubtitle => 'Manage decks in this folder.';

  @override
  String get folderSearchHint => 'Search folders';

  @override
  String get folderSearchClearTooltip => 'Clear search';

  @override
  String get deckSearchHint => 'Search decks';

  @override
  String get deckSearchClearTooltip => 'Clear deck search';

  @override
  String get folderOpenParentTooltip => 'Open parent folder';

  @override
  String get folderSortTitle => 'Sort folders';

  @override
  String get folderSortByName => 'Name';

  @override
  String get folderSortByCreatedAt => 'Created time';

  @override
  String get folderSortNameAscending => 'Name A-Z';

  @override
  String get folderSortNameDescending => 'Name Z-A';

  @override
  String get folderSortCreatedNewest => 'Newest created';

  @override
  String get folderSortCreatedOldest => 'Oldest created';

  @override
  String get folderRoot => 'Root';

  @override
  String get folderEmptyTitle => 'No folders here yet.';

  @override
  String get folderEmptySubtitle => 'Create one to start organizing content.';

  @override
  String get folderSearchEmptyTitle => 'No folders match your search.';

  @override
  String get folderSearchEmptySubtitle => 'Try a different keyword.';

  @override
  String get folderNameRequiredValidation => 'Folder name is required.';

  @override
  String folderNameMinLengthValidation(int min) {
    return 'Folder name must be at least $min character(s).';
  }

  @override
  String folderNameMaxLengthValidation(int max) {
    return 'Folder name must be at most $max character(s).';
  }

  @override
  String folderDescriptionMaxLengthValidation(int max) {
    return 'Description must be at most $max character(s).';
  }

  @override
  String get folderColorInvalidValidation => 'Folder color is invalid.';

  @override
  String folderDeleteConfirm(Object name) {
    return 'Delete \"$name\" and all subfolders?';
  }

  @override
  String folderDepth(int depth) {
    return 'Depth $depth';
  }

  @override
  String get deckNewDeck => 'New Deck';

  @override
  String get deckCreateTitle => 'Create deck';

  @override
  String get deckRenameTitle => 'Rename deck';

  @override
  String get deckDeleteTitle => 'Delete deck';

  @override
  String get deckSortTitle => 'Sort decks';

  @override
  String get deckSortByName => 'Name';

  @override
  String get deckSortNameAscending => 'Name A-Z';

  @override
  String get deckSortNameDescending => 'Name Z-A';

  @override
  String get deckNameLabel => 'Deck name';

  @override
  String get deckDescriptionLabel => 'Description';

  @override
  String get deckDescriptionHint => 'Enter deck description';

  @override
  String get deckEmptyTitle => 'No decks here yet.';

  @override
  String get deckEmptySubtitle => 'Create a deck to start organizing cards.';

  @override
  String get deckSearchEmptyTitle => 'No decks match your search.';

  @override
  String get deckSearchEmptySubtitle => 'Try a different keyword.';

  @override
  String get deckNameRequiredValidation => 'Deck name is required.';

  @override
  String deckNameMinLengthValidation(int min) {
    return 'Deck name must be at least $min character(s).';
  }

  @override
  String deckNameMaxLengthValidation(int max) {
    return 'Deck name must be at most $max character(s).';
  }

  @override
  String deckDescriptionMaxLengthValidation(int max) {
    return 'Description must be at most $max character(s).';
  }

  @override
  String deckDeleteConfirm(Object name) {
    return 'Delete deck \"$name\"?';
  }

  @override
  String deckFlashcardCount(int count) {
    return '$count cards';
  }

  @override
  String deckCount(int count) {
    return '$count deck(s)';
  }

  @override
  String get flashcardTitle => 'Flashcards';

  @override
  String get flashcardCreateButton => 'New Card';

  @override
  String get flashcardCreateTitle => 'Create flashcard';

  @override
  String get flashcardEditTitle => 'Edit flashcard';

  @override
  String get flashcardDeleteTitle => 'Delete flashcard';

  @override
  String flashcardDeleteConfirm(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get flashcardSearchHint => 'Search flashcards';

  @override
  String get flashcardSearchClearTooltip => 'Clear flashcard search';

  @override
  String get flashcardToggleSearchTooltip => 'Toggle flashcard search';

  @override
  String get flashcardSortButtonTooltip => 'Sort flashcards';

  @override
  String get flashcardSortSheetTitle => 'Sort flashcards';

  @override
  String get flashcardSortByCreatedAt => 'Created time';

  @override
  String get flashcardSortByUpdatedAt => 'Updated time';

  @override
  String get flashcardSortByFrontText => 'Front text';

  @override
  String get flashcardSortDirectionDesc => 'Newest first';

  @override
  String get flashcardSortDirectionAsc => 'Oldest first';

  @override
  String get flashcardSortDirectionAz => 'A-Z';

  @override
  String get flashcardSortDirectionZa => 'Z-A';

  @override
  String get flashcardSortSaveButton => 'Apply sort';

  @override
  String get flashcardCardSectionTitle => 'Cards';

  @override
  String get flashcardEmptyTitle => 'No flashcards yet.';

  @override
  String get flashcardEmptySubtitle => 'Create your first card to start learning.';

  @override
  String get flashcardSearchEmptyTitle => 'No matching flashcards.';

  @override
  String get flashcardSearchEmptySubtitle => 'Try another keyword.';

  @override
  String get flashcardFrontLabel => 'Front text';

  @override
  String get flashcardFrontHint => 'Enter front text';

  @override
  String get flashcardBackLabel => 'Back text';

  @override
  String get flashcardBackHint => 'Enter back text';

  @override
  String get flashcardFrontRequiredValidation => 'Front text is required.';

  @override
  String flashcardFrontMaxLengthValidation(int max) {
    return 'Front text must be at most $max character(s).';
  }

  @override
  String get flashcardBackRequiredValidation => 'Back text is required.';

  @override
  String flashcardBackMaxLengthValidation(int max) {
    return 'Back text must be at most $max character(s).';
  }

  @override
  String get flashcardOwnerFallback => 'Owner';

  @override
  String get flashcardPlusBadge => 'Plus';

  @override
  String get flashcardUpdatedRecentlyLabel => 'Updated recently';

  @override
  String flashcardTotalLabel(int count) {
    return '$count card(s)';
  }

  @override
  String get flashcardExpandPreviewTooltip => 'Open card study';

  @override
  String get flashcardPreviewPlaceholder => 'No preview available';

  @override
  String get flashcardReviewActionLabel => 'Flashcards';

  @override
  String get flashcardFlipActionLabel => 'Flip cards';

  @override
  String get flashcardLearnActionLabel => 'Learn';

  @override
  String get flashcardQuizActionLabel => 'Quiz';

  @override
  String get flashcardMatchActionLabel => 'Match';

  @override
  String get flashcardBlastActionLabel => 'Blast';

  @override
  String get flashcardProgressTitle => 'Your progress';

  @override
  String get flashcardProgressDescription => 'Your progress is based on your last two study attempts across every mode, excluding games.';

  @override
  String get flashcardProgressNotStartedLabel => 'Not started';

  @override
  String get flashcardProgressLearningLabel => 'Learning';

  @override
  String get flashcardProgressMasteredLabel => 'Mastered';

  @override
  String get flashcardStudyDeckButton => 'Study this deck';

  @override
  String get flashcardPlayAudioTooltip => 'Play audio';

  @override
  String get flashcardBookmarkTooltip => 'Bookmark';

  @override
  String get flashcardEditTooltip => 'Edit card';

  @override
  String get flashcardDeleteTooltip => 'Delete card';

  @override
  String get flashcardShareButtonTooltip => 'Share deck';

  @override
  String get flashcardMoreButtonTooltip => 'More options';

  @override
  String flashcardAudioPlayToast(Object text) {
    return 'Playing: $text';
  }

  @override
  String get flashcardBookmarkToast => 'Card bookmarked';

  @override
  String get flashcardUnbookmarkToast => 'Bookmark removed';

  @override
  String get flashcardShareComingSoonToast => 'Sharing will be available soon.';

  @override
  String get flashcardMoreOptionsComingSoonToast => 'More options will be available soon.';

  @override
  String get flashcardStudyUnavailableToast => 'No cards available for study.';

  @override
  String get flashcardStudyCompletedToast => 'Study session completed.';

  @override
  String get flashcardCloseTooltip => 'Close study';

  @override
  String get flashcardPreviousButton => 'Previous';

  @override
  String get flashcardNextButton => 'Next';

  @override
  String get homeGreeting => 'Good evening, Learner';

  @override
  String get homeGoalProgress => 'You are 78% closer to your weekly goal.';

  @override
  String get homeHeroTitle => 'Build fluency with momentum';

  @override
  String get homeHeroBody => 'Daily sessions, focused practice, and visual progress in one modern workspace.';

  @override
  String get homeAiLearningPath => 'AI Learning Path';

  @override
  String get homePrimaryAction => 'Start Session';

  @override
  String get homeSecondaryAction => 'Review Deck';

  @override
  String get homeStreakLabel => 'Streak';

  @override
  String get homeAccuracyLabel => 'Accuracy';

  @override
  String get homeXpLabel => 'Weekly XP';

  @override
  String get homeStatStreakValue => '12 days';

  @override
  String get homeStatAccuracyValue => '94%';

  @override
  String get homeStatXpValue => '2,460';

  @override
  String get homeFocusTitle => 'Today\'s Focus';

  @override
  String get homeTaskShadowListeningTitle => 'Shadow listening - 15 min';

  @override
  String get homeTaskVocabularyTitle => 'Vocabulary sprint - 20 words';

  @override
  String get homeTaskPronunciationTitle => 'Pronunciation drill - 10 min';

  @override
  String get homeActivityTitle => 'Recent Activity';

  @override
  String get homeActivitySpanishTitle => 'Spanish Travel Pack';

  @override
  String get homeActivitySpanishSubtitle => 'Completed 18 cards';

  @override
  String get homeActivitySpanishTrailing => '+120 XP';

  @override
  String get homeActivityGrammarTitle => 'Grammar: Present Perfect';

  @override
  String get homeActivityGrammarSubtitle => 'Scored 9/10';

  @override
  String get homeActivityGrammarTrailing => '+60 XP';

  @override
  String get homeActivitySpeakingTitle => 'Speaking Challenge';

  @override
  String get homeActivitySpeakingSubtitle => 'New best streak: 5';

  @override
  String get homeActivitySpeakingTrailing => 'Badge';

  @override
  String get homeTabHome => 'Home';

  @override
  String get homeTabLibrary => 'Library';

  @override
  String get homeTabFolders => 'Folders';

  @override
  String get homeTabProgress => 'Progress';

  @override
  String get homeTabProfile => 'Profile';

  @override
  String get homeProfileQuickName => 'Learner';

  @override
  String get homeLibrarySubtitle => 'Your decks, lessons, and curated packs.';

  @override
  String get homeProgressSubtitle => 'Track streaks, XP trends, and weak skills.';

  @override
  String get homeProfileSubtitle => 'Manage your goals and learning preferences.';

  @override
  String get profileThemeSectionTitle => 'Appearance';

  @override
  String get profileThemeSectionSubtitle => 'Choose how the app theme is displayed.';

  @override
  String get profileThemeSystem => 'Follow system';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileThemeToggleToLight => 'Quick switch to light mode';

  @override
  String get profileThemeToggleToDark => 'Quick switch to dark mode';
}
