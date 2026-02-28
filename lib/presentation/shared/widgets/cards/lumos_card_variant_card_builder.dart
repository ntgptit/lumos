import 'package:flutter/material.dart';

import 'lumos_card_variant.dart';

Widget buildLumosVariantCard({
  required LumosCardVariant variant,
  required ThemeData theme,
  required double elevation,
  required Color? color,
  required ShapeBorder shape,
  required Widget child,
  required EdgeInsetsGeometry? margin,
}) {
  final EdgeInsetsGeometry? resolvedMargin = margin ?? theme.cardTheme.margin;
  final Color? surfaceTintColor = theme.cardTheme.surfaceTintColor;

  return switch (variant) {
    LumosCardVariant.filled => Card.filled(
      elevation: elevation,
      color: color,
      margin: resolvedMargin,
      surfaceTintColor: surfaceTintColor,
      clipBehavior: Clip.antiAlias,
      shape: shape,
      child: child,
    ),
    LumosCardVariant.outlined => Card.outlined(
      elevation: elevation,
      color: color,
      margin: resolvedMargin,
      surfaceTintColor: surfaceTintColor,
      clipBehavior: Clip.antiAlias,
      shape: shape,
      child: child,
    ),
    LumosCardVariant.elevated => Card(
      elevation: elevation,
      color: color,
      margin: resolvedMargin,
      surfaceTintColor: surfaceTintColor,
      clipBehavior: Clip.antiAlias,
      shape: shape,
      child: child,
    ),
  };
}
