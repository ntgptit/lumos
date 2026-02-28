import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

abstract final class LumosCardConst {
  LumosCardConst._();

  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(
    Insets.paddingScreen,
  );

  // Selected state: slight elevation boost to lift card above siblings.
  static const double selectedElevationBoost = 1.0;

  // Animation duration for selected state transition.
  static const Duration selectionAnimationDuration = AppDurations.medium;

  // Responsive border radius override for tablet/desktop.
  static const BorderRadius borderRadiusTablet = BorderRadii.large; // 12dp
}

// ---------------------------------------------------------------------------
// Variant enum
// ---------------------------------------------------------------------------

enum LumosCardVariant { elevated, filled, outlined }

// ---------------------------------------------------------------------------
// LumosCard
// ---------------------------------------------------------------------------

/// A themed card widget supporting all [LumosCardVariant] styles,
/// selection state with animation, loading skeleton, long press,
/// and responsive border radius via [DeviceType].
///
/// Selection model:
///   Single select  → manage [isSelected] from parent, pass [onTap] to toggle.
///   Multi select   → same pattern, each card owns its own [isSelected] state.
///
/// Loading skeleton:
///   Pass [isLoading: true] to render a shimmer placeholder instead of [child].
///   Skeleton respects [variant] and [borderRadius] for visual consistency.
///
/// Responsive radius:
///   Pass [deviceType] to automatically use [radiusLarge] on tablet/desktop.
///
/// Example:
/// ```dart
/// LumosCard(
///   variant: LumosCardVariant.outlined,
///   isSelected: _selected,
///   deviceType: context.deviceType,
///   onTap: () => setState(() => _selected = !_selected),
///   onLongPress: () => _showContextMenu(),
///   child: PostContent(),
/// )
/// ```
class LumosCard extends StatefulWidget {
  const LumosCard({
    required this.child,
    super.key,
    this.onTap,
    this.onLongPress,
    this.padding = LumosCardConst.defaultPadding,
    this.elevation,
    this.borderRadius,
    this.isSelected = false,
    this.isLoading = false,
    this.margin,
    this.variant = LumosCardVariant.elevated,
    this.deviceType = DeviceType.mobile,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool isSelected;
  final bool isLoading;
  final EdgeInsetsGeometry? margin;
  final LumosCardVariant variant;
  final DeviceType deviceType;

  @override
  State<LumosCard> createState() => _LumosCardState();
}

class _LumosCardState extends State<LumosCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _selectionController;
  late final Animation<double> _selectionAnimation;

  @override
  void initState() {
    super.initState();
    _selectionController = AnimationController(
      vsync: this,
      duration: LumosCardConst.selectionAnimationDuration,
      value: widget.isSelected ? 1.0 : 0.0,
    );
    _selectionAnimation = CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(LumosCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected == widget.isSelected) return;
    widget.isSelected
        ? _selectionController.forward()
        : _selectionController.reverse();
  }

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    if (widget.isLoading) {
      return _LumosCardSkeleton(
        variant: widget.variant,
        borderRadius: _resolvedBorderRadius,
        margin: widget.margin ?? theme.cardTheme.margin,
        padding: widget.padding,
      );
    }

    return AnimatedBuilder(
      animation: _selectionAnimation,
      builder: (context, child) => _buildCard(
        theme: theme,
        colorScheme: colorScheme,
        selectionProgress: _selectionAnimation.value,
        child: child!,
      ),
      child: widget.child,
    );
  }

  // ---------------------------------------------------------------------------
  // Card assembly
  // ---------------------------------------------------------------------------

  Widget _buildCard({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required double selectionProgress,
    required Widget child,
  }) {
    final BorderRadius borderRadius = _resolvedBorderRadius;
    final BorderSide? borderSide = _resolveBorderSide(
      colorScheme: colorScheme,
      selectionProgress: selectionProgress,
    );
    final ShapeBorder shape = _resolveShape(
      borderRadius: borderRadius,
      borderSide: borderSide,
    );
    final Color? color = _resolveCardColor(
      colorScheme: colorScheme,
      selectionProgress: selectionProgress,
    );
    final double elevation = _resolveElevation(
      theme: theme,
      selectionProgress: selectionProgress,
    );

    final Widget themedChild = _buildThemedContent(
      theme: theme,
      colorScheme: colorScheme,
      selectionProgress: selectionProgress,
      content: Padding(padding: widget.padding, child: child),
    );

    final Widget tappableChild = _buildTappableContent(
      colorScheme: colorScheme,
      borderRadius: borderRadius,
      content: themedChild,
    );

    return _buildVariantCard(
      theme: theme,
      elevation: elevation,
      color: color,
      shape: shape,
      child: tappableChild,
    );
  }

  Widget _buildVariantCard({
    required ThemeData theme,
    required double elevation,
    required Color? color,
    required ShapeBorder shape,
    required Widget child,
  }) {
    return switch (widget.variant) {
      LumosCardVariant.filled => Card.filled(
        elevation: elevation,
        color: color,
        margin: widget.margin ?? theme.cardTheme.margin,
        surfaceTintColor: theme.cardTheme.surfaceTintColor,
        clipBehavior: Clip.antiAlias,
        shape: shape,
        child: child,
      ),
      LumosCardVariant.outlined => Card.outlined(
        elevation: elevation,
        color: color,
        margin: widget.margin ?? theme.cardTheme.margin,
        surfaceTintColor: theme.cardTheme.surfaceTintColor,
        clipBehavior: Clip.antiAlias,
        shape: shape,
        child: child,
      ),
      LumosCardVariant.elevated => Card(
        elevation: elevation,
        color: color,
        margin: widget.margin ?? theme.cardTheme.margin,
        surfaceTintColor: theme.cardTheme.surfaceTintColor,
        clipBehavior: Clip.antiAlias,
        shape: shape,
        child: child,
      ),
    };
  }

  // ---------------------------------------------------------------------------
  // Shape resolution
  // ---------------------------------------------------------------------------

  BorderRadius get _resolvedBorderRadius {
    if (widget.borderRadius != null) return widget.borderRadius!;
    return switch (widget.deviceType) {
      DeviceType.mobile => BorderRadii.medium, // 8dp
      DeviceType.tablet => LumosCardConst.borderRadiusTablet, // 12dp
      DeviceType.desktop => LumosCardConst.borderRadiusTablet, // 12dp
    };
  }

  ShapeBorder _resolveShape({
    required BorderRadius borderRadius,
    required BorderSide? borderSide,
  }) {
    return RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: borderSide ?? BorderSide.none,
    );
  }

  // ---------------------------------------------------------------------------
  // Animated border — interpolates color from outlineVariant → primary
  // ---------------------------------------------------------------------------

  BorderSide? _resolveBorderSide({
    required ColorScheme colorScheme,
    required double selectionProgress,
  }) {
    if (widget.variant == LumosCardVariant.elevated && !widget.isSelected) {
      return null;
    }

    final Color unselectedColor = widget.variant == LumosCardVariant.outlined
        ? colorScheme.outlineVariant
        : colorScheme.surface.withValues(alpha: WidgetOpacities.transparent);

    final Color resolvedColor = Color.lerp(
      unselectedColor,
      colorScheme.primary,
      selectionProgress,
    )!;

    return BorderSide(
      color: resolvedColor,
      width: WidgetSizes.borderWidthRegular,
    );
  }

  // ---------------------------------------------------------------------------
  // Animated color — interpolates surface → primaryContainer
  // ---------------------------------------------------------------------------

  Color? _resolveCardColor({
    required ColorScheme colorScheme,
    required double selectionProgress,
  }) {
    final Color unselectedColor = switch (widget.variant) {
      LumosCardVariant.elevated => colorScheme.surfaceContainerLowest,
      LumosCardVariant.filled => colorScheme.surfaceContainerHighest,
      LumosCardVariant.outlined => colorScheme.surfaceContainerLowest,
    };

    return Color.lerp(
      unselectedColor,
      colorScheme.primaryContainer,
      selectionProgress,
    );
  }

  // ---------------------------------------------------------------------------
  // Animated elevation
  // ---------------------------------------------------------------------------

  double _resolveElevation({
    required ThemeData theme,
    required double selectionProgress,
  }) {
    final double base = switch (widget.variant) {
      LumosCardVariant.elevated =>
        widget.elevation ?? theme.cardTheme.elevation ?? WidgetSizes.none,
      LumosCardVariant.filled => WidgetSizes.none,
      LumosCardVariant.outlined => WidgetSizes.none,
    };

    return base + (LumosCardConst.selectedElevationBoost * selectionProgress);
  }

  // ---------------------------------------------------------------------------
  // Scoped theme for selected state — text/icon colors follow primaryContainer
  // ---------------------------------------------------------------------------

  Widget _buildThemedContent({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required double selectionProgress,
    required Widget content,
  }) {
    // Interpolate text/icon color: onSurfaceVariant → onPrimaryContainer
    final Color iconTextColor = Color.lerp(
      colorScheme.onSurfaceVariant,
      colorScheme.onPrimaryContainer,
      selectionProgress,
    )!;

    return DefaultTextStyle.merge(
      style: TextStyle(color: iconTextColor),
      child: IconTheme(
        data: IconThemeData(color: iconTextColor),
        child: content,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tappable content — InkWell with selection-aware ripple
  // ---------------------------------------------------------------------------

  Widget _buildTappableContent({
    required ColorScheme colorScheme,
    required BorderRadius borderRadius,
    required Widget content,
  }) {
    if (widget.onTap == null && widget.onLongPress == null) return content;

    return InkWell(
      borderRadius: borderRadius,
      splashColor: colorScheme.primary.withValues(
        alpha: WidgetOpacities.statePress, // 0.12
      ),
      highlightColor: colorScheme.primary.withValues(
        alpha: WidgetOpacities.stateHover, // 0.08
      ),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: content,
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton / shimmer placeholder
// Renders a pulsing shimmer in place of card content while loading.
// ---------------------------------------------------------------------------

class _LumosCardSkeleton extends StatefulWidget {
  const _LumosCardSkeleton({
    required this.variant,
    required this.borderRadius,
    required this.padding,
    this.margin,
  });

  final LumosCardVariant variant;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;

  @override
  State<_LumosCardSkeleton> createState() => _LumosCardSkeletonState();
}

class _LumosCardSkeletonState extends State<_LumosCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: AppDurations.medium,
    )..repeat(reverse: true);

    _shimmerAnimation =
        Tween<double>(
          begin: WidgetOpacities.scrimLight,
          end: WidgetOpacities.scrimDark,
        ).animate(
          CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color shimmerColor = colorScheme.onSurface;
    final ShapeBorder skeletonShape = _buildSkeletonShape(
      colorScheme: colorScheme,
    );

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, _) {
        return Card(
          elevation: WidgetSizes.none,
          margin: widget.margin,
          clipBehavior: Clip.antiAlias,
          shape: skeletonShape,
          child: Padding(
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _shimmerLine(
                  color: shimmerColor,
                  opacity: _shimmerAnimation.value,
                  widthFactor: 0.6,
                  height: Insets.spacing16,
                ),
                const SizedBox(height: Insets.spacing8),
                _shimmerLine(
                  color: shimmerColor,
                  opacity: _shimmerAnimation.value * 0.7,
                  widthFactor: 1.0,
                  height: Insets.spacing12,
                ),
                const SizedBox(height: Insets.spacing4),
                _shimmerLine(
                  color: shimmerColor,
                  opacity: _shimmerAnimation.value * 0.5,
                  widthFactor: 0.8,
                  height: Insets.spacing12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ShapeBorder _buildSkeletonShape({required ColorScheme colorScheme}) {
    return RoundedRectangleBorder(
      borderRadius: widget.borderRadius,
      side: _resolveSkeletonBorderSide(colorScheme: colorScheme),
    );
  }

  BorderSide _resolveSkeletonBorderSide({required ColorScheme colorScheme}) {
    if (widget.variant == LumosCardVariant.outlined) {
      return BorderSide(
        color: colorScheme.outlineVariant,
        width: WidgetSizes.borderWidthRegular,
      );
    }
    return BorderSide.none;
  }

  Widget _shimmerLine({
    required Color color,
    required double opacity,
    required double widthFactor,
    required double height,
  }) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color.withValues(alpha: opacity),
          borderRadius: BorderRadii.medium,
        ),
      ),
    );
  }
}
