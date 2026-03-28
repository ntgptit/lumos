import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

class LumosShimmer extends StatefulWidget {
  const LumosShimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.baseColor,
    this.highlightColor,
    this.borderRadius,
    this.duration = AppMotionTokens.slow,
  });

  final Widget child;
  final bool enabled;
  final Color? baseColor;
  final Color? highlightColor;
  final BorderRadius? borderRadius;
  final Duration duration;

  @override
  State<LumosShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<LumosShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant LumosShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      if (widget.enabled) {
        _controller.repeat();
      }
    }
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final baseColor =
        widget.baseColor ?? context.colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? context.colorScheme.surface;
    final shimmer = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final width = bounds.width;
            final offset = _controller.value * (width * 2) - width;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.25, 0.5, 0.75],
              transform: _ShimmerGradientTransform(offset),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );

    if (widget.borderRadius == null) {
      return shimmer;
    }

    return ClipRRect(borderRadius: widget.borderRadius!, child: shimmer);
  }
}

class _ShimmerGradientTransform extends GradientTransform {
  const _ShimmerGradientTransform(this.dx);

  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(dx, 0, 0);
  }
}
