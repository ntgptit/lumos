import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../extensions/home_tab_id_l10n_extension.dart';
import '../../../../../providers/home_provider.dart';
import '../../../../../providers/states/home_state.dart';

abstract final class HomeAdaptiveBodyConst {
  HomeAdaptiveBodyConst._();

  static const Duration loadingMaskFadeDuration = AppDurations.fast;
  static const EdgeInsets tabLoadingMaskPadding = EdgeInsets.fromLTRB(
    AppSpacing.lg,
    AppSpacing.sm,
    AppSpacing.lg,
    AppSpacing.none,
  );
  static const double tabLoadingMaskHeight = WidgetSizes.progressTrackHeight;
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
    final EdgeInsets loadingMaskPadding = ResponsiveDimensions.compactInsets(
      context: context,
      baseInsets: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.none,
      ),
    );
    final double loadingMaskHeight = ResponsiveDimensions.compactValue(
      context: context,
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
                        borderRadius: BorderRadii.medium,
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
        final double railMinWidth = ResponsiveDimensions.compactValue(
          context: context,
          baseValue: 72,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
        final double railMinExtendedWidth = ResponsiveDimensions.compactValue(
          context: context,
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
            const VerticalDivider(width: AppSpacing.none),
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
