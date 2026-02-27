import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../../../../core/themes/shape.dart';

class LumosCardConst {
  const LumosCardConst._();

  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(
    Insets.paddingScreen,
  );
  static const double minLuminanceDelta = 0.03;
}

class LumosCard extends StatelessWidget {
  const LumosCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = LumosCardConst.defaultPadding,
    this.elevation,
    this.color,
    this.borderRadius,
    this.isSelected = false,
    this.margin,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool isSelected;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final BorderRadius resolvedBorderRadius =
        borderRadius ?? BorderRadii.medium;
    final BorderSide borderSide = _resolveBorderSide(colorScheme: colorScheme);
    final ShapeBorder resolvedShape = _resolveShape(
      borderRadius: resolvedBorderRadius,
      borderSide: borderSide,
    );
    final Color resolvedColor = _resolveCardColor(
      theme: theme,
      colorScheme: colorScheme,
    );
    final double resolvedElevation =
        elevation ?? theme.cardTheme.elevation ?? WidgetSizes.none;
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
    return Card(
      elevation: resolvedElevation,
      color: resolvedColor,
      margin: resolvedMargin,
      surfaceTintColor: theme.cardTheme.surfaceTintColor,
      clipBehavior: Clip.antiAlias,
      shape: resolvedShape,
      child: cardChild,
    );
  }

  ShapeBorder _resolveShape({
    required BorderRadius borderRadius,
    required BorderSide borderSide,
  }) {
    if (borderRadius == BorderRadii.medium) {
      return AppShape.cardShape(side: borderSide);
    }
    return RoundedRectangleBorder(borderRadius: borderRadius, side: borderSide);
  }

  BorderSide _resolveBorderSide({required ColorScheme colorScheme}) {
    if (isSelected) {
      return BorderSide(
        color: colorScheme.primary,
        width: WidgetSizes.borderWidthRegular,
      );
    }
    return BorderSide(
      color: colorScheme.outlineVariant.withValues(
        alpha: WidgetOpacities.stateDrag,
      ),
      width: WidgetSizes.borderWidthRegular,
    );
  }

  Color _resolveCardColor({
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    if (color != null) {
      return color!;
    }
    if (isSelected) {
      return colorScheme.primaryContainer;
    }
    final Color defaultColor =
        theme.cardTheme.color ?? colorScheme.surfaceContainerLow;
    final double luminanceDelta =
        (defaultColor.computeLuminance() -
                theme.scaffoldBackgroundColor.computeLuminance())
            .abs();
    if (luminanceDelta >= LumosCardConst.minLuminanceDelta) {
      return defaultColor;
    }
    return colorScheme.surfaceContainer;
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
