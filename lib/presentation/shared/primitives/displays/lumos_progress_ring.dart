import 'package:flutter/material.dart';

import 'package:lumos/core/theme/foundation/widget_sizes.dart';

class LumosProgressRing extends StatelessWidget {
  const LumosProgressRing({
    super.key,
    this.value,
    this.progress,
    this.size = WidgetSizes.avatarMedium,
    this.strokeWidth = WidgetSizes.progressTrackHeight,
    this.centerChild,
  });

  final double? value;
  final double? progress;
  final double size;
  final double strokeWidth;
  final Widget? centerChild;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress ?? value,
            strokeWidth: strokeWidth,
          ),
          if (centerChild != null) centerChild!,
        ],
      ),
    );
  }
}
