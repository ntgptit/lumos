import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

class LumosShimmer extends StatelessWidget {
  const LumosShimmer({
    required this.child,
    super.key,
    this.duration = MotionDurations.animationMedium,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(
        begin: WidgetOpacities.shimmerStart,
        end: WidgetOpacities.shimmerEnd,
      ),
      builder: (BuildContext context, double animatedOpacity, Widget? child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                colorScheme.surfaceContainerHighest.withValues(
                  alpha: animatedOpacity,
                ),
                colorScheme.surfaceContainerHigh.withValues(
                  alpha:
                      animatedOpacity + WidgetOpacities.shimmerHighlightOffset,
                ),
                colorScheme.surfaceContainerHighest.withValues(
                  alpha: animatedOpacity,
                ),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: child,
    );
  }
}

class LumosSkeletonBox extends StatelessWidget {
  const LumosSkeletonBox({
    super.key,
    this.height = Insets.spacing16,
    this.width = double.infinity,
    this.borderRadius = BorderRadii.medium,
  });

  final double height;
  final double width;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest;
    return LumosShimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: baseColor, borderRadius: borderRadius),
      ),
    );
  }
}
