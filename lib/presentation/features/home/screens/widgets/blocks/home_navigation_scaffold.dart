import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import 'home_adaptive_body.dart';
import 'home_app_bar.dart';
import 'home_bottom_nav.dart';

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
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: const HomeAppBar(),
      body: SafeArea(
        child: HomeAdaptiveBody(
          deviceType: deviceType,
          useNavigationRail: useNavigationRail,
        ),
      ),
      bottomNavigationBar: useNavigationRail ? null : const HomeBottomNav(),
    );
  }
}
