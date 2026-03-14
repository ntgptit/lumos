import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';

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
        final double dy = AppSpacing.lg * (1 - value);
        return Transform.translate(
          offset: Offset(AppSpacing.none, dy),
          child: animatedChild,
        );
      },
      child: child,
    );
  }
}
