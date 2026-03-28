import 'package:flutter/material.dart';
import 'package:lumos/core/theme/foundation/app_motion.dart';

class LumosScreenTransition extends StatelessWidget {
  const LumosScreenTransition({
    super.key,
    required this.child,
    this.switchKey,
    this.moveForward = true,
  });

  final Widget child;
  final Key? switchKey;
  final bool moveForward;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.medium,
      switchInCurve: AppMotion.standardCurve,
      switchOutCurve: AppMotion.standardCurve,
      transitionBuilder: (child, animation) {
        final offsetTween = Tween<Offset>(
          begin: Offset(moveForward ? 0.04 : -0.04, 0),
          end: Offset.zero,
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(offsetTween),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(key: switchKey, child: child),
    );
  }
}
