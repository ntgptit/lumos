import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.labelBehavior = NavigationDestinationLabelBehavior.alwaysShow,
  });

  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final NavigationDestinationLabelBehavior labelBehavior;

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) {
      return const SizedBox.shrink();
    }

    return NavigationBar(
      height: context.component.bottomBarHeight,
      selectedIndex: selectedIndex,
      labelBehavior: labelBehavior,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
    );
  }
}
