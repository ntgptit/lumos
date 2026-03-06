import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import 'lumos_card_variant.dart';
import 'lumos_card_variant_card_builder.dart';

export 'lumos_card_variant.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

abstract final class LumosCardConst {
  LumosCardConst._();

  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(
    AppSpacing.lg,
  );

  // Selected state: slight elevation boost to lift card above siblings.
  static const double selectedElevationBoost =
      WidgetSizes.selectionElevationBoost;

  // Animation duration for selected state transition.
  static const Duration selectionAnimationDuration = AppDurations.medium;

  // Responsive border radius override for tablet/desktop.
  static const BorderRadius borderRadiusTablet = BorderRadii.large; // 12dp

  // Dark mode lift to keep cards slightly brighter than deep surfaces.
  static const double darkModeSurfaceLiftBlend = 0.35;
}

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
    this.backgroundColor,
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
  final Color? backgroundColor;

  @override
  State<LumosCard> createState() => _LumosCardState();
}

class _LumosCardState extends State<LumosCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _selectionController;
  Animation<double>? _selectionAnimation;

  @override
  void initState() {
    super.initState();
    _ensureSelectionAnimationControllerIfNeeded();
  }

  @override
  void didUpdateWidget(LumosCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected == widget.isSelected) {
      return;
    }
    if (widget.isSelected) {
      _ensureSelectionAnimationControllerIfNeeded();
      _selectionController?.forward();
      return;
    }
    _selectionController?.reverse();
  }

  @override
  void dispose() {
    _selectionController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final ColorScheme colorScheme = theme.colorScheme;

    if (widget.isLoading) {
      final Color skeletonBackgroundColor = _resolveUnselectedColor(
        colorScheme: colorScheme,
      );
      return _LumosCardSkeleton(
        variant: widget.variant,
        borderRadius: _resolvedBorderRadius,
        margin: widget.margin ?? theme.cardTheme.margin,
        padding: widget.padding,
        backgroundColor: skeletonBackgroundColor,
      );
    }

    final Animation<double>? selectionAnimation = _selectionAnimation;
    if (selectionAnimation == null) {
      return _buildCard(
        theme: theme,
        colorScheme: colorScheme,
        selectionProgress: _selectionProgressWithoutAnimation(),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: selectionAnimation,
      builder: (context, child) => _buildCard(
        theme: theme,
        colorScheme: colorScheme,
        selectionProgress: selectionAnimation.value,
        child: child!,
      ),
      child: widget.child,
    );
  }

  double _selectionProgressWithoutAnimation() {
    if (widget.isSelected) {
      return WidgetRatios.full;
    }
    return WidgetRatios.none;
  }

  void _ensureSelectionAnimationControllerIfNeeded() {
    if (!widget.isSelected && _selectionController == null) {
      return;
    }
    if (_selectionController != null) {
      return;
    }
    final AnimationController controller = AnimationController(
      vsync: this,
      duration: LumosCardConst.selectionAnimationDuration,
      value: widget.isSelected ? WidgetRatios.full : WidgetRatios.none,
    );
    _selectionController = controller;
    _selectionAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
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

    return buildLumosVariantCard(
      variant: widget.variant,
      margin: widget.margin,
      theme: theme,
      elevation: elevation,
      color: color,
      shape: shape,
      child: tappableChild,
    );
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
        : colorScheme.surface.withValues(alpha: AppOpacity.transparent);

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
    final Color? customBackgroundColor = widget.backgroundColor;
    if (customBackgroundColor != null) {
      return Color.lerp(
        customBackgroundColor,
        colorScheme.primaryContainer,
        selectionProgress,
      );
    }
    final Color unselectedColor = _resolveUnselectedColor(
      colorScheme: colorScheme,
    );

    return Color.lerp(
      unselectedColor,
      colorScheme.primaryContainer,
      selectionProgress,
    );
  }

  Color _resolveUnselectedColor({required ColorScheme colorScheme}) {
    final Color? customBackgroundColor = widget.backgroundColor;
    if (customBackgroundColor != null) {
      return customBackgroundColor;
    }
    final Color baseUnselectedColor = switch (widget.variant) {
      LumosCardVariant.elevated => colorScheme.surfaceContainerLowest,
      LumosCardVariant.filled => colorScheme.surfaceContainerHighest,
      LumosCardVariant.outlined => colorScheme.surfaceContainerLowest,
    };
    if (colorScheme.brightness != Brightness.dark) {
      return baseUnselectedColor;
    }
    if (widget.variant == LumosCardVariant.filled) {
      return baseUnselectedColor;
    }
    return Color.lerp(
          baseUnselectedColor,
          colorScheme.surfaceContainerLow,
          LumosCardConst.darkModeSurfaceLiftBlend,
        ) ??
        colorScheme.surfaceContainerLow;
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
    final TextStyle contentTextStyle = theme.textTheme.bodyMedium
        .withResolvedColor(iconTextColor);
    final IconThemeData contentIconTheme = theme.iconTheme.withResolvedColor(
      iconTextColor,
    );

    return DefaultTextStyle.merge(
      style: contentTextStyle,
      child: IconTheme(data: contentIconTheme, child: content),
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
        alpha: AppOpacity.statePress, // 0.12
      ),
      highlightColor: colorScheme.primary.withValues(
        alpha: AppOpacity.stateHover, // 0.08
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
    required this.backgroundColor,
    this.margin,
  });

  final LumosCardVariant variant;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

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
          begin: AppOpacity.scrimLight,
          end: AppOpacity.scrimDark,
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
    final ColorScheme colorScheme = context.colorScheme;
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
          color: widget.backgroundColor,
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
                  widthFactor: WidgetRatios.shimmerLineWidthShort,
                  height: AppSpacing.lg,
                ),
                const SizedBox(height: AppSpacing.sm),
                _shimmerLine(
                  color: shimmerColor,
                  opacity:
                      _shimmerAnimation.value *
                      WidgetRatios.shimmerSecondaryBlendScale,
                  widthFactor: WidgetRatios.shimmerLineWidthFull,
                  height: AppSpacing.md,
                ),
                const SizedBox(height: AppSpacing.xs),
                _shimmerLine(
                  color: shimmerColor,
                  opacity:
                      _shimmerAnimation.value *
                      WidgetRatios.shimmerTertiaryBlendScale,
                  widthFactor: WidgetRatios.shimmerLineWidthMedium,
                  height: AppSpacing.md,
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
