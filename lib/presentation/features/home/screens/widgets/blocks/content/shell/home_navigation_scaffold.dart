import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
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
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SafeArea(
        child: ColoredBox(
          color: colorScheme.surface,
          child: HomeAdaptiveBody(
            deviceType: deviceType,
            useNavigationRail: useNavigationRail,
          ),
        ),
      ),
      bottomNavigationBar: useNavigationRail ? null : const HomeBottomNav(),
    );
  }
}
