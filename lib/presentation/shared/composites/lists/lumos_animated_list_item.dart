import 'package:flutter/material.dart';

import 'package:lumos/core/theme/foundation/app_motion.dart';

class LumosAnimatedListItem extends StatefulWidget {
  const LumosAnimatedListItem({
    super.key,
    required this.index,
    required this.child,
    this.duration = AppMotion.medium,
    this.staggerDelay =
        AppMotion.stagger,
    this.slideOffset = 0.04,
  });

  final int index;
  final Widget child;
  final Duration duration;
  final Duration staggerDelay;
  final double slideOffset;

  @override
  State<LumosAnimatedListItem> createState() => _LumosAnimatedListItemState();
}

class _LumosAnimatedListItemState extends State<LumosAnimatedListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.standardCurve,
    );
    _slideAnimation =
        Tween<Offset>(
          begin: Offset(0, widget.slideOffset),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _controller, curve: AppMotion.standardCurve),
        );
    _scheduleAnimation();
  }

  void _scheduleAnimation() {
    final Duration delay = widget.staggerDelay * widget.index;
    Future<void>.delayed(delay, () {
      if (!mounted) {
        return;
      }
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
