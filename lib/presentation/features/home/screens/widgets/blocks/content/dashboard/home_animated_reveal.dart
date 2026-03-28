import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class HomeAnimatedReveal extends StatelessWidget {
  const HomeAnimatedReveal({
    required this.order,
    required this.child,
    super.key,
  });

  final int order;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final int durationMs = 420 + (order * 120);
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: durationMs),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? animatedChild) {
        final double dy = LumosSpacing.lg * (1 - value);
        return Transform.translate(
          offset: Offset(LumosSpacing.none, dy),
          child: animatedChild,
        );
      },
      child: child,
    );
  }
}

