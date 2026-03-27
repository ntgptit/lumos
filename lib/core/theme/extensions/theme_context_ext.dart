import 'package:flutter/material.dart';

import '../responsive/adaptive_component_size.dart';
import '../responsive/adaptive_icon_size.dart';
import '../responsive/adaptive_layout.dart';
import '../responsive/adaptive_radius.dart';
import '../responsive/adaptive_spacing.dart';
import 'component_theme_ext.dart';
import 'dimension_theme_ext.dart';

extension ThemeContextExt on BuildContext {
  DimensionThemeExt get dimensions {
    final DimensionThemeExt? extension = Theme.of(
      this,
    ).extension<DimensionThemeExt>();
    if (extension != null) {
      return extension;
    }
    return DimensionThemeExt.fromMediaQueryData(MediaQuery.of(this));
  }

  ComponentThemeExt get componentTheme {
    final ComponentThemeExt? extension = Theme.of(
      this,
    ).extension<ComponentThemeExt>();
    if (extension != null) {
      return extension;
    }
    return ComponentThemeExt.fromTheme(Theme.of(this));
  }

  AdaptiveSpacing get spacing => dimensions.spacing;
  AdaptiveRadius get radius => dimensions.radius;
  AdaptiveLayout get layout => dimensions.layout;
  AdaptiveIconSize get iconSize => dimensions.iconSize;
  AdaptiveComponentSize get componentSize => dimensions.componentSize;
}
