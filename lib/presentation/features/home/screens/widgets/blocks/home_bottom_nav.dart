import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int newIndex) {
        ref.read(homeControllerProvider.notifier).selectTab(newIndex);
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
}
