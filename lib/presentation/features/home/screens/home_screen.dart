import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../../core/error/async_value_error_extensions.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/home_provider.dart';
import '../providers/states/home_state.dart';
import 'home_contract.dart';
import 'widgets/states/home_failure_view.dart';
import 'widgets/states/home_skeleton_view.dart';

export 'home_contract.dart'
    show HomeNavigationItem, HomeScreenKeys, HomeScreenSemantics, HomeScreenText;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomeState> stateAsync = ref.watch(
      homeAsyncControllerProvider,
    );
    return LumosScreenTransition(
      switchKey: ValueKey<String>('home-${stateAsync.runtimeType}'),
      moveForward: true,
      child: stateAsync.whenWithLoading(
        loadingBuilder: (BuildContext context) => const HomeSkeletonView(),
        dataBuilder: (BuildContext context, HomeState state) {
          return _HomeScaffold(
            deviceType: context.deviceType,
            useNavigationRail: context.deviceType != DeviceType.mobile,
          );
        },
        errorBuilder: (BuildContext context, Failure failure) {
          return HomeFailureView(message: failure.message);
        },
      ),
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold({
    required this.deviceType,
    required this.useNavigationRail,
  });

  final DeviceType deviceType;
  final bool useNavigationRail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _HomeAppBar(),
      body: SafeArea(
        child: _HomeAdaptiveBody(
          deviceType: deviceType,
          useNavigationRail: useNavigationRail,
        ),
      ),
      bottomNavigationBar: useNavigationRail ? null : const _HomeBottomNav(),
    );
  }
}

class _HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = ref.watch(homeSelectedTitleProvider);
    return LumosAppBar(
      title: title,
      actions: <Widget>[
        LumosIconButton(
          onPressed: () {},
          icon: Icons.notifications_none_rounded,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAdaptiveBody extends ConsumerWidget {
  const _HomeAdaptiveBody({
    required DeviceType deviceType,
    required bool useNavigationRail,
  }) : _deviceType = deviceType,
       _useNavigationRail = useNavigationRail;

  final DeviceType _deviceType;
  final bool _useNavigationRail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedIndex = ref.watch(homeSelectedIndexProvider);
    final int previousIndex = ref.watch(homePreviousIndexProvider);
    final List<HomeNavigationItem> items = ref.watch(homeNavigationItemsProvider);
    final Widget page = ref.watch(homeTabPageProvider(selectedIndex));
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
            ref.read(homeAsyncControllerProvider.notifier).selectTab(newIndex);
          },
          extended: _deviceType == DeviceType.desktop,
          destinations: items
              .map(
                (HomeNavigationItem item) => NavigationRailDestination(
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
}

class _HomeBottomNav extends ConsumerWidget {
  const _HomeBottomNav();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedIndex = ref.watch(homeSelectedIndexProvider);
    final List<HomeNavigationItem> items = ref.watch(homeNavigationItemsProvider);
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int newIndex) {
        ref.read(homeAsyncControllerProvider.notifier).selectTab(newIndex);
      },
      destinations: items
          .map(
            (HomeNavigationItem item) => NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}
