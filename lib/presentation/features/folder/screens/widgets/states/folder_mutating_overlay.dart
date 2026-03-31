import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class FolderMutatingOverlay extends StatelessWidget {
  const FolderMutatingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final double overlayWidth = context.compactValue(
      baseValue:
          96 *
          2,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double overlayPadding = context.compactValue(
      baseValue: context.spacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double skeletonSize = context.compactValue(
      baseValue:
          20,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double labelGap = context.compactValue(
      baseValue: context.spacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Center(
      child: Container(
        width: overlayWidth,
        padding: EdgeInsets.all(overlayPadding),
        decoration: BoxDecoration(
          borderRadius: context.shapes.card,
          color: context.theme.colorScheme.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LumosSkeletonBox(
              width: skeletonSize,
              height: skeletonSize,
              borderRadius: context.shapes.card,
            ),
            SizedBox(height: labelGap),
            LumosSkeletonBox(height: labelGap),
          ],
        ),
      ),
    );
  }
}
