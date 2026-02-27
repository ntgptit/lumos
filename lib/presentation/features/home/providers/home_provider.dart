// feature-architecture-guard: allow_ui_di
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../folder/screens/folder_screen.dart';
import '../screens/home_content.dart';
import '../screens/home_contract.dart';
import '../screens/widgets/blocks/home_placeholder_tab.dart';
import 'states/home_state.dart';

part 'home_provider.g.dart';

@Riverpod(keepAlive: true)
class HomeAsyncController extends _$HomeAsyncController {
  @override
  Future<HomeState> build() async {
    return HomeState.initial();
  }

  void selectTab(int newIndex) {
    final HomeState current = state.asData?.value ?? HomeState.initial();
    if (current.selectedIndex == newIndex) {
      return;
    }
    state = AsyncData<HomeState>(
      HomeState(
        selectedIndex: newIndex,
        previousIndex: current.selectedIndex,
      ),
    );
  }
}

@Riverpod(keepAlive: true)
List<HomeNavigationItem> homeNavigationItems(Ref ref) {
  return const <HomeNavigationItem>[
    HomeNavigationItem(
      label: HomeScreenText.tabHome,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    HomeNavigationItem(
      label: HomeScreenText.tabLibrary,
      icon: Icons.auto_stories_outlined,
      selectedIcon: Icons.auto_stories_rounded,
    ),
    HomeNavigationItem(
      label: HomeScreenText.tabFolders,
      icon: Icons.folder_open_outlined,
      selectedIcon: Icons.folder_open_rounded,
    ),
    HomeNavigationItem(
      label: HomeScreenText.tabProgress,
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights_rounded,
    ),
    HomeNavigationItem(
      label: HomeScreenText.tabProfile,
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];
}

@Riverpod(keepAlive: true)
int homeSelectedIndex(Ref ref) {
  final AsyncValue<HomeState> stateAsync = ref.watch(homeAsyncControllerProvider);
  if (stateAsync.hasValue) {
    return stateAsync.requireValue.selectedIndex;
  }
  return HomeState.initial().selectedIndex;
}

@Riverpod(keepAlive: true)
int homePreviousIndex(Ref ref) {
  final AsyncValue<HomeState> stateAsync = ref.watch(homeAsyncControllerProvider);
  if (stateAsync.hasValue) {
    return stateAsync.requireValue.previousIndex;
  }
  return HomeState.initial().previousIndex;
}

@Riverpod(keepAlive: true)
String homeSelectedTitle(Ref ref) {
  final int selectedIndex = ref.watch(homeSelectedIndexProvider);
  final List<HomeNavigationItem> items = ref.watch(homeNavigationItemsProvider);
  return items[selectedIndex].label;
}

@Riverpod(keepAlive: true)
Widget homeTabPage(Ref ref, int selectedIndex) {
  return switch (selectedIndex) {
    0 => const HomeContent(),
    1 => const HomePlaceholderTab(
      title: HomeScreenText.tabLibrary,
      subtitle: 'Your decks, lessons, and curated packs.',
      icon: Icons.auto_stories_rounded,
    ),
    2 => const FolderScreen(),
    3 => const HomePlaceholderTab(
      title: HomeScreenText.tabProgress,
      subtitle: 'Track streaks, XP trends, and weak skills.',
      icon: Icons.insights_rounded,
    ),
    _ => const HomePlaceholderTab(
      title: HomeScreenText.tabProfile,
      subtitle: 'Manage your goals and learning preferences.',
      icon: Icons.person_rounded,
    ),
  };
}
