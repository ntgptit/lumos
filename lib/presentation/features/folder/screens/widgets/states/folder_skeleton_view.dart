import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/presentation/shared/composites/feedback/lumos_skeleton_list_item.dart';

class FolderSkeletonView extends StatelessWidget {
  const FolderSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    final double heroHeight = context.compactValue(
      baseValue:
          96,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double sectionGap = context.compactValue(
      baseValue: context.spacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double itemGap = context.compactValue(
      baseValue: context.spacing.sm,
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
                  child: const LumosSkeletonListItem(showTrailing: true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
