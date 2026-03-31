import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/color_scheme_ext.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/extensions/screen_context_ext.dart';
import 'package:lumos/core/theme/foundation/responsive_dimensions.dart';
import 'package:lumos/core/theme/responsive/adaptive_layout.dart';
import 'package:lumos/core/theme/responsive/adaptive_component_size.dart';
import 'package:lumos/core/theme/responsive/adaptive_icon_size.dart';
import 'package:lumos/core/theme/responsive/adaptive_radius.dart';
import 'package:lumos/core/theme/responsive/adaptive_shape_roles.dart';
import 'package:lumos/core/theme/responsive/adaptive_spacing.dart';
import 'package:lumos/core/theme/responsive/adaptive_typography.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';
import 'package:lumos/core/theme/responsive/responsive_theme_factory.dart';

extension LumosThemeDataExt on ThemeData {
  DimensionThemeExt get lumos {
    final dimensions = extension<DimensionThemeExt>();
    assert(
      dimensions != null,
      'DimensionThemeExt is missing from ThemeData. Use AppTheme or access '
      'BuildContext.lumos for screen-aware fallback values.',
    );
    return dimensions ?? ResponsiveThemeFactory.create(ScreenClass.compact);
  }
}

extension ThemeContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  DimensionThemeExt get lumos {
    final dimensions = theme.extension<DimensionThemeExt>();
    if (dimensions != null) {
      return dimensions;
    }
    return ResponsiveThemeFactory.create(screenClass);
  }

  DimensionThemeExt get dims => lumos;
  AdaptiveSpacing get spacing => dims.spacing;
  AdaptiveRadius get radius => dims.radius;
  AdaptiveShapeRoles get shapes => dims.shapes;
  AdaptiveTypography get typography => dims.typography;
  AdaptiveLayout get layout => dims.layout;

  ColorSchemeExt get appColors {
    return theme.extension<ColorSchemeExt>() ??
        ResponsiveThemeFactory.colors(theme.brightness);
  }

  AppThemePalette get palette {
    return theme.extension<AppThemePalette>() ??
        AppThemePalette.fromBrightness(theme.brightness);
  }

  AdaptiveIconSize get iconSize => dims.iconSize;
  AdaptiveComponentSize get componentSize => dims.componentSize;
  AdaptiveComponentSize get component => componentSize;

  double compactValue({
    required double baseValue,
    required double minScale,
  }) {
    return ResponsiveDimensions.compactValue(
      context: this,
      baseValue: baseValue,
      minScale: minScale,
    );
  }

  EdgeInsets compactInsets({
    required EdgeInsets baseInsets,
    double minScale = ResponsiveDimensions.compactInsetScale,
  }) {
    return ResponsiveDimensions.compactInsets(
      context: this,
      baseInsets: baseInsets,
      minScale: minScale,
    );
  }
}
