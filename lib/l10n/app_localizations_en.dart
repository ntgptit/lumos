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
  String get folderManagerTitle => 'Folder Manager';

  @override
  String get folderManagerSubtitle => 'Browse tree, create, rename, and soft-delete folders.';

  @override
  String get folderSearchHint => 'Search folders';

  @override
  String get folderSearchClearTooltip => 'Clear search';

  @override
  String get folderSortTitle => 'Sort folders';

  @override
  String get folderSortNameAscending => 'Name A-Z';

  @override
  String get folderSortNameDescending => 'Name Z-A';

  @override
  String get folderRoot => 'Root';

  @override
  String get folderEmptyTitle => 'No folders here yet.';

  @override
  String get folderEmptySubtitle => 'Create one to start organizing content.';

  @override
  String folderDeleteConfirm(Object name) {
    return 'Delete \"$name\" and all subfolders?';
  }

  @override
  String folderDepth(int depth) {
    return 'Depth $depth';
  }

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
