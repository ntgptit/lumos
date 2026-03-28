import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/color_scheme_ext.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/responsive/adaptive_layout.dart';
import 'package:lumos/core/theme/responsive/adaptive_radius.dart';
import 'package:lumos/core/theme/responsive/adaptive_spacing.dart';
import 'package:lumos/core/theme/responsive/adaptive_typography.dart';
import 'package:lumos/core/theme/responsive/adaptive_component_size.dart';
import 'package:lumos/core/theme/responsive/adaptive_icon_size.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';

abstract final class ResponsiveThemeFactory {
  static DimensionThemeExt create(ScreenClass screenClass) {
    return DimensionThemeExt(
      spacing: AdaptiveSpacing.fromScreen(screenClass),
      radius: AdaptiveRadius.fromScreen(screenClass),
      typography: AdaptiveTypography.fromScreen(screenClass),
      iconSize: AdaptiveIconSize.fromScreen(screenClass),
      componentSize: AdaptiveComponentSize.fromScreen(screenClass),
      layout: AdaptiveLayout.fromScreen(screenClass),
    );
  }

  static List<ThemeExtension<dynamic>> extensions({
    required DimensionThemeExt dimensions,
    Brightness brightness = Brightness.light,
  }) {
    return [
      dimensions,
      ColorSchemeExt.fromBrightness(brightness),
      AppThemePalette.fromBrightness(brightness),
    ];
  }

  static ColorSchemeExt colors(Brightness brightness) {
    return ColorSchemeExt.fromBrightness(brightness);
  }
}
