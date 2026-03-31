import 'package:flutter/material.dart';

import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_shimmer.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_skeleton_box.dart';

class LumosSkeletonText extends StatelessWidget {
  const LumosSkeletonText({
    super.key,
    this.lines = 3,
    this.lineHeight = 12,
    this.lineSpacing = 8,
    this.lastLineWidthFraction = 0.6,
    this.enabled = true,
  });

  final int lines;
  final double lineHeight;
  final double lineSpacing;
  final double lastLineWidthFraction;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = context.shapes.control;
    return LumosShimmer(
      enabled: enabled,
      borderRadius: radius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(lines, (int index) {
          final bool isLast = index == lines - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : lineSpacing),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: isLast ? lastLineWidthFraction : 1.0,
              child: LumosSkeletonBox(height: lineHeight, borderRadius: radius),
            ),
          );
        }),
      ),
    );
  }
}
