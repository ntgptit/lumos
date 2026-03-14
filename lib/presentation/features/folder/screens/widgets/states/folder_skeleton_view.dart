import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderSkeletonView extends StatelessWidget {
  const FolderSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    final double heroHeight = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.canvas,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double itemGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        LumosScreenFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LumosSkeletonBox(height: heroHeight),
              SizedBox(height: sectionGap),
              ...List<Widget>.generate(
                6,
                (int index) => Padding(
                  padding: EdgeInsets.only(bottom: itemGap),
                  child: LumosSkeletonBox(height: heroHeight),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
