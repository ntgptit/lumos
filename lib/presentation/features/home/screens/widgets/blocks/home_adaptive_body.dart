import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/states/home_state.dart';
import '../../../extensions/home_tab_id_l10n_extension.dart';

class HomeAdaptiveBody extends ConsumerWidget {
  const HomeAdaptiveBody({
    required DeviceType deviceType,
    required bool useNavigationRail,
    super.key,
  }) : _deviceType = deviceType,
       _useNavigationRail = useNavigationRail;

  final DeviceType _deviceType;
  final bool _useNavigationRail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final int selectedIndex = ref.watch(homeSelectedIndexProvider);
    final int previousIndex = ref.watch(homePreviousIndexProvider);
    final HomeTabId selectedTab = ref.watch(homeSelectedTabProvider);
    final List<HomeNavigationItem> items = ref.watch(
      homeNavigationItemsProvider,
    );
    final HomePageBuilder pageBuilder = ref.watch(
      homeTabPageProvider(selectedTab),
    );
    final Widget page = pageBuilder(context);
    final Widget transitionedBody = LumosScreenTransition(
      switchKey: ValueKey<int>(selectedIndex),
      moveForward: selectedIndex >= previousIndex,
      child: page,
    );
    if (!_useNavigationRail) {
      return transitionedBody;
    }
    return Row(
      children: <Widget>[
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int newIndex) {
            ref.read(homeControllerProvider.notifier).selectTab(newIndex);
          },
          extended: _deviceType == DeviceType.desktop,
          destinations: items
              .map(
                (HomeNavigationItem item) => NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: Text(item.tabId.toLocalizedLabel(l10n)),
                ),
              )
              .toList(),
        ),
        const VerticalDivider(width: Insets.spacing0),
        Expanded(child: transitionedBody),
      ],
    );
  }
}
