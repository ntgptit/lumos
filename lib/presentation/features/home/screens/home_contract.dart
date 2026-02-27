import 'package:flutter/material.dart';

class HomeScreenText {
  const HomeScreenText._();

  static const String title = 'Lumos';
  static const String greeting = 'Good evening, Learner';
  static const String heroTitle = 'Build fluency with momentum';
  static const String heroBody =
      'Daily sessions, focused practice, and visual progress in one modern workspace.';
  static const String primaryAction = 'Start Session';
  static const String secondaryAction = 'Review Deck';
  static const String streakLabel = 'Streak';
  static const String accuracyLabel = 'Accuracy';
  static const String xpLabel = 'Weekly XP';
  static const String focusTitle = 'Today\'s Focus';
  static const String activityTitle = 'Recent Activity';
  static const String tabHome = 'Home';
  static const String tabLibrary = 'Library';
  static const String tabFolders = 'Folders';
  static const String tabProgress = 'Progress';
  static const String tabProfile = 'Profile';
}

class HomeScreenSemantics {
  const HomeScreenSemantics._();

  static const String heroCard = 'home-hero-card';
  static const String sectionCard = 'home-section-card';
}

class HomeScreenKeys {
  const HomeScreenKeys._();

  static const ValueKey<String> mobileLayout = ValueKey<String>(
    'home-layout-mobile',
  );
  static const ValueKey<String> tabletLayout = ValueKey<String>(
    'home-layout-tablet',
  );
  static const ValueKey<String> desktopLayout = ValueKey<String>(
    'home-layout-desktop',
  );
}

class HomeNavigationItem {
  const HomeNavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
