import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';
import '../../../../providers/home_provider.dart';
import '../../../../providers/states/home_state.dart';
import '../../../../extensions/home_tab_id_l10n_extension.dart';

class HomeBottomNav extends ConsumerWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double navigationBarHeight = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: WidgetSizes.navigationBarHeight,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final int selectedIndex = ref.watch(homeSelectedIndexProvider);
    final List<HomeNavigationItem> items = ref.watch(
      homeNavigationItemsProvider,
    );
    final bool isOnHomeRoute = _isOnHomeRoute(context);
    return NavigationBar(
      height: navigationBarHeight,
      labelBehavior: context.deviceType == DeviceType.mobile
          ? NavigationDestinationLabelBehavior.alwaysShow
          : NavigationDestinationLabelBehavior.onlyShowSelected,
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
        const DashboardRouteData().go(context);
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
      return currentPath == const DashboardRouteData().location;
    } catch (_) {
      return true;
    }
  }
}

