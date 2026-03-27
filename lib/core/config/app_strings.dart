abstract final class AppStrings {
  static const appName = 'lumos';
  static const splashTitle = 'Preparing your learning workspace';
  static const loading = 'Loading...';
  static const genericError = 'Something went wrong.';
  static const retry = 'Retry';
  static const navigationDashboardLabel = 'Dashboard';
  static const navigationFoldersLabel = 'Folders';
  static const navigationDecksLabel = 'Decks';
  static const navigationProgressLabel = 'Progress';
  static const navigationSettingsLabel = 'Settings';
  static const dashboardTitle = 'Dashboard';
  static const dashboardFoundationTitle = 'Dashboard foundation';
  static const dashboardFoundationDescription =
      'Architecture scaffold is ready for app, core, presentation, data, domain, and l10n.';
  static const dashboardRuntimeSnapshotTitle = 'Runtime snapshot';
  static const dashboardScreenClassLabel = 'Screen class';
  static const dashboardContentMaxWidthLabel = 'Content max width';
  static const dashboardHeadlineSubtitle =
      'Stay on pace with today\'s study plan and clear the next useful review block.';
  static const dashboardSummaryTitle = 'Today\'s overview';
  static const dashboardSummarySubtitle =
      'A quick read on workload, cadence, and study momentum.';
  static const dashboardSummaryDueDecksLabel = 'Due decks';
  static const dashboardSummaryDueCardsLabel = 'Cards today';
  static const dashboardSummaryReviewedLabel = 'Reviewed';
  static const dashboardSummaryFocusTimeLabel = 'Focus time';
  static const dashboardStreakTitle = 'Study streak';
  static const dashboardStreakSubtitle =
      'Consistency compounds when you keep short sessions moving.';
  static const dashboardDailyGoalLabel = 'Daily goal';
  static const dashboardQuickActionsTitle = 'Quick actions';
  static const dashboardQuickActionsSubtitle =
      'Jump straight into the next useful move.';
  static const dashboardDueDecksTitle = 'Due decks';
  static const dashboardDueDecksSubtitle =
      'Start with the decks carrying the heaviest review debt.';
  static const dashboardRefreshTooltip = 'Refresh dashboard';
  static const dashboardStartActionLabel = 'Start';
  static const dashboardOpenActionLabel = 'Open';
  static const dashboardLaterActionLabel = 'Later';
  static const dashboardReviewActionTitle = 'Start review';
  static const dashboardReviewActionSubtitle =
      'Focus on the decks with the highest due volume first.';
  static const dashboardCreateDeckActionTitle = 'Create deck';
  static const dashboardCreateDeckActionSubtitle =
      'Capture a new topic while the idea is still fresh.';
  static const dashboardImportCardsActionTitle = 'Import cards';
  static const dashboardImportCardsActionSubtitle =
      'Bring in prepared content and queue it for practice.';
  static const dashboardReviewFocusLabel = 'Review sprint';
  static const dashboardCaptureFocusLabel = 'Capture mode';
  static const dashboardImportFocusLabel = 'Import queue';
  static const dashboardCompleteFocusLabel = 'Inbox clear';
  static const dashboardLaterFocusLabel = 'Later queue';
  static const dashboardNoDueDecksSubtitle =
      'You have cleared every due deck in the current queue.';
  static const dashboardQuickActionsEmptyTitle = 'No quick actions right now';
  static const dashboardQuickActionsEmptySubtitle =
      'The current queue is stable, so you can stay with the active study flow.';
  static const dashboardTravelDeckTitle = 'Travel phrases';
  static const dashboardMedicalDeckTitle = 'Medical terminology';
  static const dashboardVerbsDeckTitle = 'Korean verbs';
  static const dashboardLanguageLabFolder = 'Language Lab';
  static const dashboardExamPrepFolder = 'Exam Prep';
  static const dashboardDailyPracticeFolder = 'Daily Practice';
  static const dashboardRecallModeLabel = 'Recall';
  static const dashboardReviewModeLabel = 'Review';
  static const dashboardSpeedModeLabel = 'Speed drill';
  static const foldersTitle = 'Folders';
  static const foldersPlaceholderTitle = 'Folder hub is ready';
  static const foldersPlaceholderMessage =
      'This root tab is wired into the shared app navigation. Folder-specific content can expand here next.';
  static const decksTitle = 'Decks';
  static const decksPlaceholderTitle = 'Deck library is ready';
  static const decksPlaceholderMessage =
      'This tab is now part of the common shell, so deck listing and filtering can grow without changing app navigation.';
  static const progressTitle = 'Progress';
  static const progressPlaceholderTitle = 'Progress workspace is ready';
  static const progressPlaceholderMessage =
      'Charts, streaks, and history can plug into this shared navigation slot when the feature slice is implemented.';
  static const settingsTitle = 'Settings';
  static const settingsPlaceholderTitle = 'Settings center is ready';
  static const settingsPlaceholderMessage =
      'App preferences already have a dedicated root tab, ready for theme, language, audio, and backup settings.';
  static const offlineTitle = 'You are offline';
  static const offlineMessage = 'Check your internet connection and try again.';
  static const offlineRetryLabel = 'Retry';
  static const maintenanceTitle = 'Maintenance';
  static const maintenanceMessage = 'The system is temporarily unavailable.';
  static const notFoundTitle = 'Page not found';
  static const notFoundMessage = 'The requested page does not exist.';
  static const clearSelectionTooltip = 'Clear selection';
  static const filterTooltip = 'Filter';
  static const sortTooltip = 'Sort';
  static const noResultsTitle = 'No results found';
  static const noResultsMessage = 'Try adjusting your filters or search terms.';
  static const accessRequiredTitle = 'Access required';
  static const signInMessage = 'Sign in to continue.';
  static const signInLabel = 'Sign in';
  static const clearDateTooltip = 'Clear date';
  static const clearTimeTooltip = 'Clear time';
  static const clearSearchTooltip = 'Clear search';
  static const selectDateLabel = 'Select date';
  static const selectTimeLabel = 'Select time';
  static const searchLabel = 'Search';
  static const requiredFieldMark = ' *';
  static const cancelLabel = 'Cancel';
  static const confirmLabel = 'Confirm';
  static const saveLabel = 'Save';
  static const developmentLabel = 'DEV';
  static const stagingLabel = 'STAGE';
  static const productionLabel = 'PROD';

  static String dashboardScreenClassMessage(String screenClass) {
    return '$dashboardScreenClassLabel: $screenClass';
  }

  static String dashboardContentMaxWidthMessage(String contentMaxWidth) {
    return '$dashboardContentMaxWidthLabel: $contentMaxWidth';
  }

  static String dashboardFocusChipLabel(String focusLabel) {
    return 'Focus: $focusLabel';
  }

  static String dashboardDueDeckChipLabel(String dueDeckCount) {
    return '$dueDeckCount decks due';
  }

  static String dashboardDueCardChipLabel(String dueCardCount) {
    return '$dueCardCount cards today';
  }

  static String dashboardDueDeckValue(String dueDeckCount) {
    return '$dueDeckCount decks';
  }

  static String dashboardDueCardValue(String dueCardCount) {
    return '$dueCardCount cards';
  }

  static String dashboardReviewedValue(String reviewedCount) {
    return '$reviewedCount cards';
  }

  static String dashboardStudyMinutesValue(String minutes) {
    return '$minutes min';
  }

  static String dashboardStreakValue(String days) {
    return '$days days';
  }

  static String dashboardGoalProgressMessage(String reviewed, String goal) {
    return '$reviewed / $goal cards reviewed today';
  }

  static String dashboardGoalRemainingMessage(String remaining) {
    return '$remaining cards left to hit today\'s goal';
  }

  static String dashboardDeckMeta(String folderName, String modeLabel) {
    return '$folderName • $modeLabel';
  }

  static String dashboardDeckStatusMessage(
    String folderName,
    String modeLabel,
    String mastery,
  ) {
    return '$folderName • $modeLabel • $mastery% mastered';
  }

  static String dashboardDueCountLabel(String dueCount) {
    return '$dueCount due';
  }
}
