// feature-architecture-guard: allow_ui_di
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../l10n/app_localizations.dart';
import '../../folder/providers/folder_ui_signal_provider.dart';
import '../../folder/screens/folder_screen.dart';
import '../../profile/screens/profile_content.dart';
import '../../progress/screens/study_progress_screen.dart';
import '../screens/home_content.dart';
import '../screens/widgets/blocks/content/shell/home_placeholder_tab.dart';
import 'states/home_state.dart';

part 'home_provider.g.dart';

abstract final class HomeProviderConst {
  HomeProviderConst._();

  static const Duration tabSwitchLoadingDuration = AppDurations.medium;
}

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {
  Timer? _tabSwitchLoadingTimer;

  @override
  HomeState build() {
    ref.onDispose(() {
      _tabSwitchLoadingTimer?.cancel();
      _tabSwitchLoadingTimer = null;
    });
    return HomeState.initial();
  }

  void selectTab(int newIndex) {
    final HomeState current = state;
    if (current.selectedIndex == newIndex) {
      return;
    }
    final List<int> nextVisitedTabIndices = _addVisitedIndex(
      currentIndices: current.visitedTabIndices,
      nextIndex: newIndex,
    );
    _tabSwitchLoadingTimer?.cancel();
    state = HomeState(
      selectedIndex: newIndex,
      previousIndex: current.selectedIndex,
      visitedTabIndices: nextVisitedTabIndices,
      isSwitchLoading: true,
    );
    _tabSwitchLoadingTimer = Timer(
      HomeProviderConst.tabSwitchLoadingDuration,
      _finishTabLoadingMask,
    );
  }

  void onTabDestinationSelected({
    required int newIndex,
    required HomeTabId tabId,
  }) {
    final HomeState current = state;
    if (current.selectedIndex != newIndex) {
      selectTab(newIndex);
      return;
    }
    _handleTabReselection(tabId: tabId);
  }

  bool _containsIndex({required List<int> indices, required int index}) {
    return indices.contains(index);
  }

  List<int> _addVisitedIndex({
    required List<int> currentIndices,
    required int nextIndex,
  }) {
    if (_containsIndex(indices: currentIndices, index: nextIndex)) {
      return currentIndices;
    }
    return <int>[...currentIndices, nextIndex];
  }

  void _finishTabLoadingMask() {
    if (!ref.mounted) {
      return;
    }
    final HomeState current = state;
    if (!current.isSwitchLoading) {
      return;
    }
    state = current.copyWith(isSwitchLoading: false);
  }

  void _handleTabReselection({required HomeTabId tabId}) {
    if (tabId != HomeTabId.folders) {
      return;
    }
    ref.read(folderUiSignalControllerProvider.notifier).requestScrollToTop();
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
List<int> homeVisitedTabIndices(Ref ref) {
  final HomeState state = ref.watch(homeControllerProvider);
  return state.visitedTabIndices;
}

@Riverpod(keepAlive: true)
bool homeIsSwitchLoading(Ref ref) {
  final HomeState state = ref.watch(homeControllerProvider);
  return state.isSwitchLoading;
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
      return const StudyProgressScreen();
    },
    HomeTabId.profile => (BuildContext context) => const ProfileContent(),
  };
}
