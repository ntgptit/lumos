import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderMutatingOverlay extends StatelessWidget {
  const FolderMutatingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final double overlayWidth = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.canvas * 2,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double overlayPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double skeletonSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.page,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double labelGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Center(
      child: Container(
        width: overlayWidth,
        padding: EdgeInsets.all(overlayPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadii.large,
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LumosSkeletonBox(
              width: skeletonSize,
              height: skeletonSize,
              borderRadius: BorderRadii.large,
            ),
            SizedBox(height: labelGap),
            LumosSkeletonBox(height: labelGap),
          ],
        ),
      ),
    );
  }
}
