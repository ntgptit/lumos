import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/presentation/shared/composites/feedback/lumos_skeleton_list_item.dart';

abstract final class DeckLoadingViewConst {
  DeckLoadingViewConst._();

  static const int skeletonCount = 5;
}

class DeckLoadingView extends StatelessWidget {
  const DeckLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final double itemSpacing = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(DeckLoadingViewConst.skeletonCount, (
        int index,
      ) {
        final double bottomSpacing =
            index == DeckLoadingViewConst.skeletonCount - 1
            ? 0
            : itemSpacing;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomSpacing),
          child: const LumosSkeletonListItem(showTrailing: true),
        );
      }),
    );
  }
}
