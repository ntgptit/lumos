import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/constants/route_names.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/states/home_state.dart';
import '../../../extensions/home_tab_id_l10n_extension.dart';

class HomeBottomNav extends ConsumerWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final int selectedIndex = ref.watch(homeSelectedIndexProvider);
    final List<HomeNavigationItem> items = ref.watch(
      homeNavigationItemsProvider,
    );
    final bool isOnHomeRoute = _isOnHomeRoute(context);
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int newIndex) {
        final HomeNavigationItem selectedItem = items[newIndex];
        ref
            .read(homeControllerProvider.notifier)
            .onTabDestinationSelected(
              newIndex: newIndex,
              tabId: selectedItem.tabId,
            );
        if (isOnHomeRoute) {
          return;
        }
        context.goNamed(AppRouteName.home);
      },
      destinations: items
          .map(
            (HomeNavigationItem item) => NavigationDestination(
              icon: LumosIcon(item.icon),
              selectedIcon: LumosIcon(item.selectedIcon),
              label: item.tabId.toLocalizedLabel(l10n),
            ),
          )
          .toList(),
    );
  }

  bool _isOnHomeRoute(BuildContext context) {
    try {
      final String currentPath = GoRouterState.of(context).uri.path;
      return currentPath == AppRoutePath.home;
    } catch (_) {
      return true;
    }
  }
}
