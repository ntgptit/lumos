import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosNavigationRail extends StatelessWidget {
  const LumosNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.leading,
    this.trailing,
    this.extended = false,
    this.labelType = NavigationRailLabelType.all,
    this.groupAlignment,
  });

  final List<NavigationRailDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget? leading;
  final Widget? trailing;
  final bool extended;
  final NavigationRailLabelType labelType;
  final double? groupAlignment;

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) {
      return const SizedBox.shrink();
    }

    final railWidth = context.component.navigationRailWidth;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      leading: leading,
      trailing: trailing,
      extended: extended,
      groupAlignment: groupAlignment,
      labelType: extended ? NavigationRailLabelType.none : labelType,
      minWidth: railWidth,
      minExtendedWidth: railWidth * 2.75,
      destinations: destinations,
    );
  }
}
