import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../../folder/screens/folder_management_screen.dart';
import '../widgets/home_content_widget.dart';
import '../widgets/home_placeholder_tab.dart';

part 'home_screen.g.dart';

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

class _HomeNavigationItem {
  const _HomeNavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class HomeTabState {
  const HomeTabState({
    required this.selectedIndex,
    required this.previousIndex,
  });

  final int selectedIndex;
  final int previousIndex;

  factory HomeTabState.initial() {
    return const HomeTabState(selectedIndex: 0, previousIndex: 0);
  }
}

@Riverpod(keepAlive: true)
class HomeTabController extends _$HomeTabController {
  @override
  HomeTabState build() {
    return HomeTabState.initial();
  }

  void selectTab(int newIndex) {
    if (state.selectedIndex == newIndex) {
      return;
    }
    state = HomeTabState(
      selectedIndex: newIndex,
      previousIndex: state.selectedIndex,
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const List<_HomeNavigationItem> _navigationItems =
      <_HomeNavigationItem>[
        _HomeNavigationItem(
          label: HomeScreenText.tabHome,
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
        ),
        _HomeNavigationItem(
          label: HomeScreenText.tabLibrary,
          icon: Icons.auto_stories_outlined,
          selectedIcon: Icons.auto_stories_rounded,
        ),
        _HomeNavigationItem(
          label: HomeScreenText.tabFolders,
          icon: Icons.folder_open_outlined,
          selectedIcon: Icons.folder_open_rounded,
        ),
        _HomeNavigationItem(
          label: HomeScreenText.tabProgress,
          icon: Icons.insights_outlined,
          selectedIcon: Icons.insights_rounded,
        ),
        _HomeNavigationItem(
          label: HomeScreenText.tabProfile,
          icon: Icons.person_outline_rounded,
          selectedIcon: Icons.person_rounded,
        ),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeTabState tabState = ref.watch(homeTabControllerProvider);
    final DeviceType deviceType = context.deviceType;
    final bool useNavigationRail = deviceType != DeviceType.mobile;
    return Scaffold(
      appBar: LumosAppBar(
        title: _navigationItems[tabState.selectedIndex].label,
        actions: <Widget>[
          LumosIconButton(
            onPressed: () {},
            icon: Icons.notifications_none_rounded,
          ),
        ],
      ),
      body: SafeArea(
        child: _buildAdaptiveBody(
          ref: ref,
          tabState: tabState,
          deviceType: deviceType,
          useNavigationRail: useNavigationRail,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        ref: ref,
        tabState: tabState,
        useNavigationRail: useNavigationRail,
      ),
    );
  }

  Widget _buildAdaptiveBody({
    required WidgetRef ref,
    required HomeTabState tabState,
    required DeviceType deviceType,
    required bool useNavigationRail,
  }) {
    final Widget transitionedBody = _buildTransitionedBody(
      tabState: tabState,
      deviceType: deviceType,
    );
    if (!useNavigationRail) {
      return transitionedBody;
    }
    return Row(
      children: <Widget>[
        NavigationRail(
          selectedIndex: tabState.selectedIndex,
          onDestinationSelected: (int newIndex) {
            _onDestinationSelected(ref: ref, newIndex: newIndex);
          },
          extended: deviceType == DeviceType.desktop,
          destinations: _navigationItems
              .map(
                (_HomeNavigationItem item) => NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: Text(item.label),
                ),
              )
              .toList(),
        ),
        const VerticalDivider(width: Insets.spacing0),
        Expanded(child: transitionedBody),
      ],
    );
  }

  Widget _buildTransitionedBody({
    required HomeTabState tabState,
    required DeviceType deviceType,
  }) {
    return LumosScreenTransition(
      switchKey: ValueKey<int>(tabState.selectedIndex),
      moveForward: tabState.selectedIndex >= tabState.previousIndex,
      child: _buildBody(
        selectedIndex: tabState.selectedIndex,
        deviceType: deviceType,
      ),
    );
  }

  Widget? _buildBottomNavigationBar({
    required WidgetRef ref,
    required HomeTabState tabState,
    required bool useNavigationRail,
  }) {
    if (useNavigationRail) {
      return null;
    }
    return NavigationBar(
      selectedIndex: tabState.selectedIndex,
      onDestinationSelected: (int newIndex) {
        _onDestinationSelected(ref: ref, newIndex: newIndex);
      },
      destinations: _navigationItems
          .map(
            (_HomeNavigationItem item) => NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }

  Widget _buildBody({
    required int selectedIndex,
    required DeviceType deviceType,
  }) {
    if (selectedIndex == 0) {
      return HomeContent(deviceType: deviceType);
    }
    if (selectedIndex == 1) {
      return const HomePlaceholderTab(
        title: HomeScreenText.tabLibrary,
        subtitle: 'Your decks, lessons, and curated packs.',
        icon: Icons.auto_stories_rounded,
      );
    }
    if (selectedIndex == 2) {
      return const FolderManagementScreen();
    }
    if (selectedIndex == 3) {
      return const HomePlaceholderTab(
        title: HomeScreenText.tabProgress,
        subtitle: 'Track streaks, XP trends, and weak skills.',
        icon: Icons.insights_rounded,
      );
    }
    return const HomePlaceholderTab(
      title: HomeScreenText.tabProfile,
      subtitle: 'Manage your goals and learning preferences.',
      icon: Icons.person_rounded,
    );
  }

  void _onDestinationSelected({required WidgetRef ref, required int newIndex}) {
    ref.read(homeTabControllerProvider.notifier).selectTab(newIndex);
  }
}
