import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/themes/foundation/app_foundation.dart';

abstract final class LumosHorizontalPagerConst {
  LumosHorizontalPagerConst._();

  static const double wheelDeltaThreshold = AppSpacing.sm;
  static const Duration pageAnimationDuration = AppDurations.medium;
}

class LumosHorizontalPager extends StatelessWidget {
  const LumosHorizontalPager({
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.onPageChanged,
    this.autofocus = true,
  });

  final PageController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<int>? onPageChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: autofocus,
      onKeyEvent: _handleKeyEvent,
      child: Listener(
        onPointerSignal: _handlePointerSignal,
        child: ScrollConfiguration(
          behavior: const _LumosHorizontalPagerScrollBehavior(),
          child: PageView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(parent: PageScrollPhysics()),
            itemCount: itemCount,
            onPageChanged: onPageChanged,
            itemBuilder: itemBuilder,
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _goToNextPage();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _goToPreviousPage();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) {
      return;
    }
    final double deltaX = event.scrollDelta.dx;
    final double deltaY = event.scrollDelta.dy;
    final double horizontalIntent = deltaX.abs();
    final double verticalIntent = deltaY.abs();
    if (horizontalIntent < LumosHorizontalPagerConst.wheelDeltaThreshold &&
        verticalIntent < LumosHorizontalPagerConst.wheelDeltaThreshold) {
      return;
    }
    if (horizontalIntent >= verticalIntent) {
      _scrollByDelta(deltaX);
      return;
    }
    _scrollByDelta(deltaY);
  }

  void _scrollByDelta(double delta) {
    if (delta > AppSpacing.none) {
      _goToNextPage();
      return;
    }
    _goToPreviousPage();
  }

  void _goToNextPage() {
    final int currentPage = _resolvedPage;
    if (currentPage >= itemCount - 1) {
      return;
    }
    controller.animateToPage(
      currentPage + 1,
      duration: LumosHorizontalPagerConst.pageAnimationDuration,
      curve: Curves.easeOutCubic,
    );
  }

  void _goToPreviousPage() {
    final int currentPage = _resolvedPage;
    if (currentPage <= 0) {
      return;
    }
    controller.animateToPage(
      currentPage - 1,
      duration: LumosHorizontalPagerConst.pageAnimationDuration,
      curve: Curves.easeOutCubic,
    );
  }

  int get _resolvedPage {
    if (!controller.hasClients) {
      return controller.initialPage;
    }
    return controller.page?.round() ?? controller.initialPage;
  }
}

class _LumosHorizontalPagerScrollBehavior extends MaterialScrollBehavior {
  const _LumosHorizontalPagerScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices {
    return <PointerDeviceKind>{
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.trackpad,
      PointerDeviceKind.stylus,
      PointerDeviceKind.unknown,
    };
  }
}
