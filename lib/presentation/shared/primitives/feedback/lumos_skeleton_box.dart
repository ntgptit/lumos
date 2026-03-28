import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class LumosSkeletonBox extends StatelessWidget {
  const LumosSkeletonBox({
    super.key,
    this.width,
    this.height = LumosSpacing.md,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius ?? BorderRadii.small,
      ),
    );
  }
}
