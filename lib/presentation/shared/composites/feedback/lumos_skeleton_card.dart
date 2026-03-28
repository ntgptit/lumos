import 'package:flutter/material.dart';

import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_shimmer.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_skeleton_box.dart';

class LumosSkeletonCard extends StatelessWidget {
  const LumosSkeletonCard({
    super.key,
    this.height,
    this.titleWidth = 0.5,
    this.subtitleWidth = 0.35,
    this.showSubtitle = true,
    this.enabled = true,
  });

  final double? height;
  final double titleWidth;
  final double subtitleWidth;
  final bool showSubtitle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(context.radius.xs);
    return LumosCard(
      variant: LumosCardVariant.filled,
      child: LumosShimmer(
        enabled: enabled,
        borderRadius: radius,
        child: SizedBox(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: titleWidth,
                child: LumosSkeletonBox(
                  height: context.spacing.md,
                  borderRadius: radius,
                ),
              ),
              if (showSubtitle) ...[
                SizedBox(height: context.spacing.sm),
                FractionallySizedBox(
                  widthFactor: subtitleWidth,
                  child: LumosSkeletonBox(
                    height: context.spacing.sm,
                    borderRadius: radius,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
