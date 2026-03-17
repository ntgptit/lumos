import 'package:flutter/material.dart';

import '../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../core/themes/foundation/app_foundation.dart';

enum LumosSwipeSurfaceTone { neutral, positive, critical }

class LumosSwipeSurfaceAction {
  const LumosSwipeSurfaceAction({
    required this.icon,
    this.tone = LumosSwipeSurfaceTone.neutral,
  });

  final IconData icon;
  final LumosSwipeSurfaceTone tone;
}

class LumosSwipeActionSurface extends StatelessWidget {
  const LumosSwipeActionSurface({
    required this.child,
    required this.dragExtent,
    required this.isDragging,
    super.key,
    this.leftAction,
    this.rightAction,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
  });

  final Widget child;
  final double dragExtent;
  final bool isDragging;
  final LumosSwipeSurfaceAction? leftAction;
  final LumosSwipeSurfaceAction? rightAction;
  final ValueChanged<DragUpdateDetails>? onHorizontalDragUpdate;
  final ValueChanged<DragEndDetails>? onHorizontalDragEnd;

  @override
  Widget build(BuildContext context) {
    final LumosSwipeSurfaceAction? activeAction = _resolvedAction();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _SwipeActionBackground(
              action: activeAction,
              dragExtent: dragExtent,
            ),
            RepaintBoundary(
              child: AnimatedContainer(
                duration: isDragging ? Duration.zero : AppDurations.fast,
                curve: Curves.easeOutCubic,
                transform: Matrix4.translationValues(
                  dragExtent,
                  AppSpacing.none,
                  AppSpacing.none,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LumosSwipeSurfaceAction? _resolvedAction() {
    if (dragExtent.isNegative) {
      return leftAction;
    }
    if (dragExtent > AppSpacing.none) {
      return rightAction;
    }
    return null;
  }
}

class _SwipeActionBackground extends StatelessWidget {
  const _SwipeActionBackground({
    required this.action,
    required this.dragExtent,
  });

  final LumosSwipeSurfaceAction? action;
  final double dragExtent;

  @override
  Widget build(BuildContext context) {
    final LumosSwipeSurfaceAction? resolvedAction = action;
    if (resolvedAction == null) {
      return const SizedBox.shrink();
    }
    final _SwipeActionPalette palette = _resolvePalette(
      context: context,
      tone: resolvedAction.tone,
    );
    final Alignment alignment = dragExtent.isNegative
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final double horizontalInset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double iconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: IconSizes.iconMedium,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double borderRadius = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.xl,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.backgroundColor,
        borderRadius: BorderRadii.circular(borderRadius),
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalInset),
          child: Icon(
            resolvedAction.icon,
            color: palette.foregroundColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  _SwipeActionPalette _resolvePalette({
    required BuildContext context,
    required LumosSwipeSurfaceTone tone,
  }) {
    final ColorScheme colorScheme = context.colorScheme;
    return switch (tone) {
      LumosSwipeSurfaceTone.neutral => _SwipeActionPalette(
        backgroundColor: colorScheme.surfaceContainerHigh,
        foregroundColor: colorScheme.onSurfaceVariant,
      ),
      LumosSwipeSurfaceTone.positive => _SwipeActionPalette(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      LumosSwipeSurfaceTone.critical => _SwipeActionPalette(
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
      ),
    };
  }
}

class _SwipeActionPalette {
  const _SwipeActionPalette({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
}
