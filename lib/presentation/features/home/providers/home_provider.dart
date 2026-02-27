// feature-architecture-guard: allow_ui_di
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../l10n/app_localizations.dart';
import '../../folder/screens/folder_screen.dart';
import '../screens/home_content.dart';
import '../screens/widgets/blocks/home_placeholder_tab.dart';
import 'states/home_state.dart';

part 'home_provider.g.dart';

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {
  @override
  HomeState build() {
    return HomeState.initial();
  }

  void selectTab(int newIndex) {
    final HomeState current = state;
    if (current.selectedIndex == newIndex) {
      return;
    }
    state = HomeState(
      selectedIndex: newIndex,
      previousIndex: current.selectedIndex,
    );
  }
}

@Riverpod(keepAlive: true)
List<HomeNavigationItem> homeNavigationItems(Ref ref) {
  return const <HomeNavigationItem>[
    HomeNavigationItem(
      tabId: HomeTabId.home,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    HomeNavigationItem(
      tabId: HomeTabId.library,
      icon: Icons.auto_stories_outlined,
      selectedIcon: Icons.auto_stories_rounded,
    ),
    HomeNavigationItem(
      tabId: HomeTabId.folders,
      icon: Icons.folder_open_outlined,
      selectedIcon: Icons.folder_open_rounded,
    ),
    HomeNavigationItem(
      tabId: HomeTabId.progress,
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights_rounded,
    ),
    HomeNavigationItem(
      tabId: HomeTabId.profile,
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];
}

@Riverpod(keepAlive: true)
int homeSelectedIndex(Ref ref) {
  final HomeState state = ref.watch(homeControllerProvider);
  return state.selectedIndex;
}

@Riverpod(keepAlive: true)
int homePreviousIndex(Ref ref) {
  final HomeState state = ref.watch(homeControllerProvider);
  return state.previousIndex;
}

@Riverpod(keepAlive: true)
HomeTabId homeSelectedTab(Ref ref) {
  final int selectedIndex = ref.watch(homeSelectedIndexProvider);
  final List<HomeNavigationItem> items = ref.watch(homeNavigationItemsProvider);
  return items[selectedIndex].tabId;
}

typedef HomePageBuilder = Widget Function(BuildContext context);

@Riverpod(keepAlive: true)
HomePageBuilder homeTabPage(Ref ref, HomeTabId selectedTab) {
  return switch (selectedTab) {
    HomeTabId.home => (BuildContext context) => const HomeContent(),
    HomeTabId.library => (BuildContext context) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      return HomePlaceholderTab(
        title: l10n.homeTabLibrary,
        subtitle: l10n.homeLibrarySubtitle,
        icon: Icons.auto_stories_rounded,
      );
    },
    HomeTabId.folders => (BuildContext context) => const FolderScreen(),
    HomeTabId.progress => (BuildContext context) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      return HomePlaceholderTab(
        title: l10n.homeTabProgress,
        subtitle: l10n.homeProgressSubtitle,
        icon: Icons.insights_rounded,
      );
    },
    HomeTabId.profile => (BuildContext context) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      return HomePlaceholderTab(
        title: l10n.homeTabProfile,
        subtitle: l10n.homeProfileSubtitle,
        icon: Icons.person_rounded,
      );
    },
  };
}
