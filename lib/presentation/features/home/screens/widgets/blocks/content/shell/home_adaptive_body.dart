import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../extensions/home_tab_id_l10n_extension.dart';
import '../../../../../providers/home_provider.dart';
import '../../../../../providers/states/home_state.dart';

abstract final class HomeAdaptiveBodyConst {
  HomeAdaptiveBodyConst._();

  static const Duration loadingMaskFadeDuration = AppMotion.fast;
  static const EdgeInsets tabLoadingMaskPadding = EdgeInsets.fromLTRB(
    24,
    12,
    24,
    0,
  );
  static const double tabLoadingMaskHeight = 6;
  static const double railDividerWidth = 0;
}

class HomeAdaptiveBody extends ConsumerStatefulWidget {
  const HomeAdaptiveBody({
    required DeviceType deviceType,
    required bool useNavigationRail,
    super.key,
  }) : _deviceType = deviceType,
       _useNavigationRail = useNavigationRail;

  final DeviceType _deviceType;
  final bool _useNavigationRail;

  @override
  ConsumerState<HomeAdaptiveBody> createState() => _HomeAdaptiveBodyState();
}

class _HomeAdaptiveBodyState extends ConsumerState<HomeAdaptiveBody> {
  final Map<HomeTabId, Widget> _pageCacheByTab = <HomeTabId, Widget>{};
  Locale? _cachedLocale;

  @override
  Widget build(BuildContext context) {
    _syncPageCacheForLocale(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final EdgeInsets loadingMaskPadding = context.compactInsets(
      baseInsets: EdgeInsets.fromLTRB(
        context.spacing.lg,
        context.spacing.sm,
        context.spacing.lg,
        0,
      ),
    );
    final double loadingMaskHeight = context.compactValue(
      baseValue: HomeAdaptiveBodyConst.tabLoadingMaskHeight,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final int selectedIndex = ref.watch(homeSelectedIndexProvider);
    final List<int> visitedTabIndices = ref.watch(
      homeVisitedTabIndicesProvider,
    );
    final bool isSwitchLoading = ref.watch(homeIsSwitchLoadingProvider);
    final List<HomeNavigationItem> items = ref.watch(
      homeNavigationItemsProvider,
    );
    final List<Widget> tabChildren = items
        .asMap()
        .entries
        .map((entry) {
          final int index = entry.key;
          final HomeNavigationItem item = entry.value;
          if (!_shouldBuildTab(
            index: index,
            selectedIndex: selectedIndex,
            visitedTabIndices: visitedTabIndices,
          )) {
            return const SizedBox.shrink();
          }
          final HomeTabId tabId = item.tabId;
          final Widget? cachedPage = _pageCacheByTab[tabId];
          if (cachedPage != null) {
            return cachedPage;
          }
          final HomePageBuilder pageBuilder = ref.read(
            homeTabPageProvider(tabId),
          );
          final Widget page = KeyedSubtree(
            key: PageStorageKey<String>('home-tab-${tabId.name}'),
            child: pageBuilder(context),
          );
          _pageCacheByTab[tabId] = page;
          return page;
        })
        .toList(growable: false);
    final Widget tabbedBody = Stack(
      children: <Widget>[
        IndexedStack(index: selectedIndex, children: tabChildren),
        IgnorePointer(
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: HomeAdaptiveBodyConst.loadingMaskFadeDuration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              child: isSwitchLoading
                  ? Padding(
                      key: const ValueKey<String>('home-tab-loading-mask'),
                      padding: loadingMaskPadding,
                      child: ClipRRect(
                        borderRadius: context.shapes.control,
                        child: LumosLoadingIndicator(
                          isLinear: true,
                          size: loadingMaskHeight,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
    if (!widget._useNavigationRail) {
      return tabbedBody;
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool extendedRail =
            widget._deviceType == DeviceType.desktop &&
            constraints.maxWidth >= 1180;
        final double railMinWidth = context.compactValue(
          baseValue: 72,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
        final double railMinExtendedWidth = context.compactValue(
          baseValue: 220,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
        return Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: selectedIndex,
              minWidth: railMinWidth,
              minExtendedWidth: railMinExtendedWidth,
              onDestinationSelected: (int newIndex) {
                final HomeNavigationItem selectedItem = items[newIndex];
                ref
                    .read(homeControllerProvider.notifier)
                    .onTabDestinationSelected(
                      newIndex: newIndex,
                      tabId: selectedItem.tabId,
                    );
              },
              extended: extendedRail,
              destinations: items
                  .map(
                    (HomeNavigationItem item) => NavigationRailDestination(
                      icon: LumosIcon(item.icon),
                      selectedIcon: LumosIcon(item.selectedIcon),
                      label: LumosInlineText(item.tabId.toLocalizedLabel(l10n)),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: HomeAdaptiveBodyConst.railDividerWidth),
            Expanded(child: tabbedBody),
          ],
        );
      },
    );
  }

  bool _shouldBuildTab({
    required int index,
    required int selectedIndex,
    required List<int> visitedTabIndices,
  }) {
    if (index == selectedIndex) {
      return true;
    }
    return visitedTabIndices.contains(index);
  }

  void _syncPageCacheForLocale(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    if (locale == _cachedLocale) {
      return;
    }
    _cachedLocale = locale;
    _pageCacheByTab.clear();
  }
}
