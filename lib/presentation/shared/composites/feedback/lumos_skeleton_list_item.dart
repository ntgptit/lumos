import 'package:flutter/material.dart';

import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/foundation/widget_sizes.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_shimmer.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_skeleton_box.dart';

const double _primaryLineWidthFactor = 0.7;
const double _secondaryLineWidthFactor = 0.45;

class LumosSkeletonListItem extends StatelessWidget {
  const LumosSkeletonListItem({
    super.key,
    this.showLeading = true,
    this.showSubtitle = true,
    this.showTrailing = false,
    this.leadingSize = WidgetSizes.avatarMedium,
    this.enabled = true,
  });

  final bool showLeading;
  final bool showSubtitle;
  final bool showTrailing;
  final double leadingSize;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = context.shapes.control;
    return LumosShimmer(
      enabled: enabled,
      borderRadius: radius,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.md,
          vertical: context.spacing.md,
        ),
        child: Row(
          children: <Widget>[
            if (showLeading) ...[
              LumosSkeletonBox(
                width: leadingSize,
                height: leadingSize,
                borderRadius: context.shapes.card,
              ),
              SizedBox(width: context.spacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _primaryLineWidthFactor,
                    child: LumosSkeletonBox(
                      height: context.spacing.md,
                      borderRadius: radius,
                    ),
                  ),
                  if (showSubtitle) ...[
                    SizedBox(height: context.spacing.xs),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _secondaryLineWidthFactor,
                      child: LumosSkeletonBox(
                        height: context.spacing.sm,
                        borderRadius: radius,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showTrailing) ...[
              SizedBox(width: context.spacing.md),
              LumosSkeletonBox(
                width: context.spacing.xl,
                height: context.spacing.md,
                borderRadius: radius,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
