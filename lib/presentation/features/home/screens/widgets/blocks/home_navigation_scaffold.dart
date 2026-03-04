import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import 'home_adaptive_body.dart';
import 'home_app_bar.dart';
import 'home_bottom_nav.dart';

abstract final class HomeNavigationScaffoldConst {
  HomeNavigationScaffoldConst._();

  static const double topBlobSize = AppSpacing.canvas * 3;
  static const double sideBlobSize = AppSpacing.canvas * 2.2;
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
        child: Stack(
          children: <Widget>[
            LumosDecorativeBackground(
              gradientColors: <Color>[
                colorScheme.surfaceContainerLow,
                colorScheme.surfaceDim,
              ],
              blobs: <LumosDecorativeBlob>[
                LumosDecorativeBlob(
                  top: -AppSpacing.canvas,
                  right: -AppSpacing.canvas,
                  fill: colorScheme.primaryContainer,
                  size: HomeNavigationScaffoldConst.topBlobSize,
                ),
                LumosDecorativeBlob(
                  left: -AppSpacing.page,
                  top: AppSpacing.canvas * 2,
                  fill: colorScheme.secondaryContainer,
                  size: HomeNavigationScaffoldConst.sideBlobSize,
                ),
              ],
            ),
            HomeAdaptiveBody(
              deviceType: deviceType,
              useNavigationRail: useNavigationRail,
            ),
          ],
        ),
      ),
      bottomNavigationBar: useNavigationRail ? null : const HomeBottomNav(),
    );
  }
}
