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
  String get flashcardLearnSheetTitle => 'Choose your study path';

  @override
  String get flashcardLearnSheetSubtitle => 'Pick the session you want to start for this deck.';

  @override
  String get flashcardLearnContinueOptionTitle => 'Continue learning';

  @override
  String get flashcardLearnContinueOptionSubtitle => 'Study vocabulary that is still new or not yet passed.';

  @override
  String get flashcardLearnReviewOptionTitle => 'Review due cards';

  @override
  String get flashcardLearnReviewOptionSubtitle => 'Review vocabulary that has reached its SRS deadline.';

  @override
  String get flashcardLearnResetOptionTitle => 'Reset study progress';

  @override
  String get flashcardLearnResetOptionSubtitle => 'Clear the learning progress for this deck and start again.';

  @override
  String get flashcardLearnContinueUnavailableToast => 'No new or unfinished vocabulary is available right now.';

  @override
  String get flashcardLearnReviewUnavailableToast => 'No vocabulary is currently due for review.';

  @override
  String get flashcardLearnResetConfirmTitle => 'Reset study progress?';

  @override
  String get flashcardLearnResetConfirmMessage => 'This will reset the learning progress for the current deck.';

  @override
  String get flashcardLearnResetConfirmAction => 'Reset progress';

  @override
  String get flashcardLearnResetSuccessToast => 'Study progress has been reset.';

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

  @override
  String get commonLogout => 'Logout';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonCheck => 'Check';

  @override
  String get commonReplay => 'Replay';

  @override
  String get authTitle => 'Lumos';

  @override
  String get authSubtitle => 'Authenticate first, then resume study from canonical backend state.';

  @override
  String get authLoginTab => 'Login';

  @override
  String get authRegisterTab => 'Register';

  @override
  String get authSignInAction => 'Sign in';

  @override
  String get authCreateAccountAction => 'Create account';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authUsernameOrEmailLabel => 'Username or email';

  @override
  String get authShowPasswordTooltip => 'Show password';

  @override
  String get authHidePasswordTooltip => 'Hide password';

  @override
  String get profileSpeechSectionTitle => 'Speech preference';

  @override
  String get profileSpeechEnabledLabel => 'Enable Korean speech';

  @override
  String get profileSpeechAutoPlayLabel => 'Auto play current item';

  @override
  String get profileSpeechVoiceLabel => 'Voice';

  @override
  String get profileSpeechSpeedLabel => 'Speed';

  @override
  String get studyProgressMomentumTitle => 'Study momentum';

  @override
  String studyProgressMomentumSummary(int dueCount, int overdueCount, Object escalationLevel) {
    return 'Due $dueCount | Overdue $overdueCount | Escalation $escalationLevel';
  }

  @override
  String get studyProgressRecommendedReviewTitle => 'Recommended review';

  @override
  String studyProgressRecommendedReviewSummary(Object deckName, int dueCount) {
    return '$deckName · $dueCount due items';
  }

  @override
  String get studyProgressStartReviewAction => 'Start review';

  @override
  String get studyProgressBoxDistributionTitle => '7-box distribution';

  @override
  String studyProgressBoxLabel(int boxIndex) {
    return 'Box $boxIndex';
  }

  @override
  String get studyMatchCheckAction => 'Check';

  @override
  String studyMatchCompletedItemLabel(Object label) {
    return 'Matched · $label';
  }

  @override
  String studySpeechPanelTitle(Object locale) {
    return 'Text to speech · $locale';
  }

  @override
  String studySpeechPanelVoiceSummary(Object voice, Object speed) {
    return 'Voice: $voice · Speed: ${speed}x';
  }

  @override
  String get studySpeechPlayAction => 'Listen';

  @override
  String get studySpeechPlayingAction => 'Playing';

  @override
  String get studySpeechReplayAction => 'Replay';

  @override
  String get studyResetCurrentModeAction => 'Reset current mode';

  @override
  String get studyResetCurrentModeTitle => 'Reset current mode?';

  @override
  String get studyResetCurrentModeMessage => 'This will clear all progress in the current mode and start that mode again from the first item.';

  @override
  String get studyResetCurrentModeConfirm => 'Reset mode';

  @override
  String get deckEditTooltip => 'Edit deck';

  @override
  String get deckDeleteTooltip => 'Delete deck';

  @override
  String get flashcardAgainAction => 'Again';

  @override
  String get flashcardKnownAction => 'Known';

  @override
  String get exerciseMatchPairsTitle => 'Match pairs';

  @override
  String get exerciseCompletedLabel => 'Completed';

  @override
  String get exerciseSubmitMatchesLabel => 'Submit matches';

  @override
  String get exerciseReorderWordsTitle => 'Reorder words';

  @override
  String get exerciseCheckOrderLabel => 'Check order';

  @override
  String get exerciseListeningTitle => 'Listening exercise';

  @override
  String get feedbackGreatJob => 'Great job!';

  @override
  String feedbackResultSummaryCorrect(int correctCount, int totalCount) {
    return '$correctCount / $totalCount correct';
  }

  @override
  String feedbackResultSummaryXpEarned(int xpEarned) {
    return 'XP earned: $xpEarned';
  }

  @override
  String feedbackResultSummaryStreakBonus(int streakBonus) {
    return 'Streak bonus: +$streakBonus XP';
  }

  @override
  String gamificationLevelLabel(int level) {
    return 'Level $level';
  }

  @override
  String gamificationXpLabel(int xp) {
    return '$xp XP';
  }

  @override
  String get gamificationDailyGoalTitle => 'Daily Goal';

  @override
  String gamificationDailyGoalProgress(int current, int goal, Object unit) {
    return '$current/$goal $unit';
  }

  @override
  String learningReviewProgressLabel(int completed, int total) {
    return '$completed / $total reviewed';
  }

  @override
  String learningEstimateMinutesLeft(int minutes) {
    return '$minutes min left';
  }

  @override
  String get learningStatisticsTitle => 'Statistics';

  @override
  String learningStatisticsTotal(int count) {
    return 'Total: $count';
  }

  @override
  String learningStatisticsMastered(int count) {
    return 'Mastered: $count';
  }

  @override
  String learningStatisticsLearning(int count) {
    return 'Learning: $count';
  }

  @override
  String learningStatisticsDue(int count) {
    return 'Due: $count';
  }

  @override
  String learningReviewQueueDueToday(int count) {
    return 'Due today: $count';
  }

  @override
  String learningReviewQueueSize(int count) {
    return 'Queue size: $count';
  }

  @override
  String get learningStartReviewAction => 'Start review';

  @override
  String get onboardingPlacementTestTitle => 'Placement Test';

  @override
  String onboardingQuestionCount(int count) {
    return '$count questions';
  }

  @override
  String get onboardingCompleteTestAction => 'Complete test';

  @override
  String get formAnswerHint => 'Type your answer';

  @override
  String get formTapToSpeakAction => 'Tap to speak';

  @override
  String get formFillBlankHint => 'Fill the blank';
}
