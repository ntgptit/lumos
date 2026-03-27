import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/core/config/app_icons.dart';
import 'package:lumos/core/theme/extensions/screen_context_ext.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/navigation/app_bottom_navigation.dart';
import 'package:lumos/presentation/shared/composites/navigation/app_navigation_rail.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = <_AppShellDestination>[
    _AppShellDestination(
      section: _AppShellSection.dashboard,
      icon: AppIcons.dashboard,
      selectedIcon: Icons.space_dashboard,
    ),
    _AppShellDestination(
      section: _AppShellSection.folders,
      icon: AppIcons.folders,
      selectedIcon: Icons.folder,
    ),
    _AppShellDestination(
      section: _AppShellSection.decks,
      icon: AppIcons.decks,
      selectedIcon: Icons.layers,
    ),
    _AppShellDestination(
      section: _AppShellSection.progress,
      icon: AppIcons.progress,
      selectedIcon: Icons.insert_chart_rounded,
    ),
    _AppShellDestination(
      section: _AppShellSection.settings,
      icon: AppIcons.settings,
      selectedIcon: Icons.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (context.screenClass.canUseSplitView) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.layout.pageVerticalPadding,
                ),
                child: AppNavigationRail(
                  destinations: [
                    for (final destination in _destinations)
                      NavigationRailDestination(
                        icon: Icon(destination.icon),
                        selectedIcon: Icon(destination.selectedIcon),
                        label: Text(destination.label(l10n)),
                      ),
                  ],
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onSelectDestination,
                  extended: context.screenClass.isLarge,
                  labelType: NavigationRailLabelType.all,
                ),
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: context.colorScheme.outlineVariant,
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavigation(
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label(l10n),
            ),
        ],
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onSelectDestination,
      ),
    );
  }

  void _onSelectDestination(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _AppShellDestination {
  const _AppShellDestination({
    required this.section,
    required this.icon,
    required this.selectedIcon,
  });

  final _AppShellSection section;
  final IconData icon;
  final IconData selectedIcon;

  String label(AppLocalizations l10n) {
    switch (section) {
      case _AppShellSection.dashboard:
        return l10n.navigationDashboardLabel;
      case _AppShellSection.folders:
        return l10n.navigationFoldersLabel;
      case _AppShellSection.decks:
        return l10n.navigationDecksLabel;
      case _AppShellSection.progress:
        return l10n.navigationProgressLabel;
      case _AppShellSection.settings:
        return l10n.navigationSettingsLabel;
    }
  }
}

enum _AppShellSection { dashboard, folders, decks, progress, settings }
