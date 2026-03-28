import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/core/theme/foundation/app_motion.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_banner.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';

enum LumosToastPosition { top, bottom }

class LumosToastListener extends StatefulWidget {
  const LumosToastListener({
    super.key,
    required this.message,
    required this.child,
    this.title,
    this.type = SnackbarType.info,
    this.duration = AppDurations.toast,
    this.position = LumosToastPosition.bottom,
  });

  final String? message;
  final String? title;
  final SnackbarType type;
  final Duration duration;
  final Widget child;
  final LumosToastPosition position;

  @override
  State<LumosToastListener> createState() => _AppToastListenerState();
}

class _AppToastListenerState extends State<LumosToastListener>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  Timer? _hideTimer;
  String? _lastShownMessage;
  String? _scheduledMessage;
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: AppMotion.standardCurve,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rebuildSlideAnimation();
    _maybeShow();
  }

  @override
  void didUpdateWidget(covariant LumosToastListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _rebuildSlideAnimation();
    }
    _maybeShow();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _rebuildSlideAnimation() {
    final beginOffset = switch (widget.position) {
      LumosToastPosition.bottom => const Offset(0, 1),
      LumosToastPosition.top => const Offset(0, -1),
    };
    _slideAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: AppMotion.standardCurve,
            reverseCurve: Curves.easeIn,
          ),
        );
  }

  void _maybeShow() {
    final message = widget.message;
    if (message == null || message.isEmpty || message == _lastShownMessage) {
      return;
    }

    if (_scheduledMessage == message) {
      return;
    }

    _scheduledMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final overlay = Overlay.maybeOf(context, rootOverlay: true);
      if (overlay == null) {
        _scheduledMessage = null;
        return;
      }

      _lastShownMessage = message;
      _scheduledMessage = null;
      _removeOverlay();
      _overlayEntry = OverlayEntry(
        builder: (context) {
          final positioned = switch (widget.position) {
            LumosToastPosition.bottom => Positioned(
              left: LumosSpacing.md,
              right: LumosSpacing.md,
              bottom: LumosSpacing.lg,
              child: _buildAnimatedBanner(message),
            ),
            LumosToastPosition.top => Positioned(
              left: LumosSpacing.md,
              right: LumosSpacing.md,
              top: LumosSpacing.lg,
              child: _buildAnimatedBanner(message),
            ),
          };
          return positioned;
        },
      );
      overlay.insert(_overlayEntry!);
      _animationController.forward();
      _hideTimer?.cancel();
      _hideTimer = Timer(widget.duration, _dismissOverlay);
    });
  }

  Widget _buildAnimatedBanner(String message) {
    return SafeArea(
      top: widget.position == LumosToastPosition.top,
      bottom: widget.position == LumosToastPosition.bottom,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: LumosBanner(
              message: message,
              title: widget.title,
              type: widget.type,
              dense: true,
            ),
          ),
        ),
      ),
    );
  }

  void _dismissOverlay() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _animationController.reverse().then((_) {
      if (!mounted) {
        return;
      }
      _removeOverlay();
    });
  }

  void _removeOverlay() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
