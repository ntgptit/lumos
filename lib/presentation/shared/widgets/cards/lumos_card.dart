import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../../../../core/themes/shape.dart';

class LumosCardConst {
  const LumosCardConst._();

  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(
    Insets.paddingScreen,
  );
  static const double selectedElevationBoost = 1;
}

enum LumosCardVariant { elevated, filled, outlined }

class LumosCard extends StatelessWidget {
  const LumosCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = LumosCardConst.defaultPadding,
    this.elevation,
    this.borderRadius,
    this.isSelected = false,
    this.margin,
    this.variant = LumosCardVariant.elevated,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool isSelected;
  final EdgeInsetsGeometry? margin;
  final LumosCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final BorderRadius resolvedBorderRadius =
        borderRadius ?? BorderRadii.medium;
    final BorderSide? borderSide = _resolveBorderSide(colorScheme: colorScheme);
    final ShapeBorder resolvedShape = _resolveShape(
      theme: theme,
      borderRadius: resolvedBorderRadius,
      borderSide: borderSide,
    );
    final Color? resolvedColor = _resolveCardColor(colorScheme: colorScheme);
    final double resolvedElevation = _resolveElevation(theme: theme);
    final EdgeInsetsGeometry? resolvedMargin = margin ?? theme.cardTheme.margin;
    final Widget content = Padding(padding: padding, child: child);
    final Widget themedContent = _buildThemedContent(
      theme: theme,
      colorScheme: colorScheme,
      content: content,
    );
    final Widget cardChild = _buildCardChild(
      colorScheme: colorScheme,
      content: themedContent,
      borderRadius: resolvedBorderRadius,
    );
    return _buildCardByVariant(
      elevation: resolvedElevation,
      color: resolvedColor,
      margin: resolvedMargin,
      surfaceTintColor: theme.cardTheme.surfaceTintColor,
      clipBehavior: Clip.antiAlias,
      shape: resolvedShape,
      child: cardChild,
    );
  }

  Widget _buildCardByVariant({
    required double elevation,
    required Color? color,
    required EdgeInsetsGeometry? margin,
    required Color? surfaceTintColor,
    required Clip clipBehavior,
    required ShapeBorder shape,
    required Widget child,
  }) {
    if (variant == LumosCardVariant.filled) {
      return Card.filled(
        elevation: elevation,
        color: color,
        margin: margin,
        surfaceTintColor: surfaceTintColor,
        clipBehavior: clipBehavior,
        shape: shape,
        child: child,
      );
    }
    if (variant == LumosCardVariant.outlined) {
      return Card.outlined(
        elevation: elevation,
        color: color,
        margin: margin,
        surfaceTintColor: surfaceTintColor,
        clipBehavior: clipBehavior,
        shape: shape,
        child: child,
      );
    }
    return Card(
      elevation: elevation,
      color: color,
      margin: margin,
      surfaceTintColor: surfaceTintColor,
      clipBehavior: clipBehavior,
      shape: shape,
      child: child,
    );
  }

  ShapeBorder _resolveShape({
    required ThemeData theme,
    required BorderRadius borderRadius,
    required BorderSide? borderSide,
  }) {
    if (borderSide case final BorderSide value) {
      if (borderRadius == BorderRadii.medium) {
        return AppShape.cardShape(side: value);
      }
      return RoundedRectangleBorder(borderRadius: borderRadius, side: value);
    }

    if (borderRadius == BorderRadii.medium) {
      if (theme.cardTheme.shape case final ShapeBorder cardShape) {
        return cardShape;
      }
      return AppShape.cardShape();
    }

    return RoundedRectangleBorder(borderRadius: borderRadius);
  }

  double _resolveElevation({required ThemeData theme}) {
    final double themeElevation =
        elevation ?? theme.cardTheme.elevation ?? WidgetSizes.none;
    final double baseElevation = _resolveVariantElevation(
      themeElevation: themeElevation,
    );
    if (!isSelected) {
      return baseElevation;
    }
    return baseElevation + LumosCardConst.selectedElevationBoost;
  }

  double _resolveVariantElevation({required double themeElevation}) {
    if (variant == LumosCardVariant.elevated) {
      return themeElevation;
    }
    return WidgetSizes.none;
  }

  BorderSide? _resolveBorderSide({required ColorScheme colorScheme}) {
    if (isSelected) {
      return BorderSide(
        color: colorScheme.primary,
        width: WidgetSizes.borderWidthRegular,
      );
    }
    if (variant == LumosCardVariant.outlined) {
      return BorderSide(
        color: colorScheme.outlineVariant,
        width: WidgetSizes.borderWidthRegular,
      );
    }
    return null;
  }

  Color? _resolveCardColor({required ColorScheme colorScheme}) {
    if (isSelected) {
      return colorScheme.primaryContainer;
    }
    if (variant == LumosCardVariant.filled) {
      return colorScheme.surfaceContainerHighest;
    }
    return null;
  }

  Widget _buildThemedContent({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Widget content,
  }) {
    final ThemeData scopedTheme = _resolveScopedTheme(
      theme: theme,
      colorScheme: colorScheme,
    );
    final Color secondaryTextColor = scopedTheme.colorScheme.onSurfaceVariant;
    return Theme(
      data: scopedTheme,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: secondaryTextColor),
        child: IconTheme(
          data: IconThemeData(color: secondaryTextColor),
          child: content,
        ),
      ),
    );
  }

  ThemeData _resolveScopedTheme({
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    if (!isSelected) {
      return theme;
    }
    final ColorScheme selectedColorScheme = colorScheme.copyWith(
      onSurface: colorScheme.onPrimaryContainer,
      onSurfaceVariant: colorScheme.onPrimaryContainer,
    );
    return theme.copyWith(colorScheme: selectedColorScheme);
  }

  Widget _buildCardChild({
    required ColorScheme colorScheme,
    required Widget content,
    required BorderRadius borderRadius,
  }) {
    if (onTap == null) {
      return content;
    }
    return InkWell(
      borderRadius: borderRadius,
      splashColor: colorScheme.primary.withValues(
        alpha: WidgetOpacities.statePress,
      ),
      highlightColor: colorScheme.primary.withValues(
        alpha: WidgetOpacities.stateFocus,
      ),
      onTap: onTap,
      child: content,
    );
  }
}
