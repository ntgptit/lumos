import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../constants/home_contract.dart';
import 'home_adaptive_body.dart';
import '../../footer/home_bottom_nav.dart';
import '../../header/home_app_bar.dart';

abstract final class HomeNavigationScaffoldConst {
  HomeNavigationScaffoldConst._();
}

class HomeNavigationScaffold extends StatelessWidget {
  const HomeNavigationScaffold({
    required this.deviceType,
    required this.useNavigationRail,
    super.key,
  });

  final DeviceType deviceType;
  final bool useNavigationRail;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool compactMobileScaffold =
        context.deviceType == DeviceType.mobile && !useNavigationRail;
    return Scaffold(
      extendBody: compactMobileScaffold,
      appBar: const HomeAppBar(),
      body: SafeArea(
        bottom: !compactMobileScaffold,
        child: ColoredBox(
          color: colorScheme.surface,
          child: HomeAdaptiveBody(
            key: _layoutKey(),
            deviceType: deviceType,
            useNavigationRail: useNavigationRail,
          ),
        ),
      ),
      bottomNavigationBar: useNavigationRail ? null : const HomeBottomNav(),
    );
  }

  Key _layoutKey() {
    if (deviceType == DeviceType.mobile) {
      return HomeScreenKeys.mobileLayout;
    }
    if (deviceType == DeviceType.tablet) {
      return HomeScreenKeys.tabletLayout;
    }
    return HomeScreenKeys.desktopLayout;
  }
}

