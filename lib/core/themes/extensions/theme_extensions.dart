import 'package:flutter/material.dart';

export 'build_context_theme_x.dart';
export 'color_scheme_state_extensions.dart';
export 'typography_extensions.dart';
export 'widget_state_extensions.dart';

extension ColorSchemeCompatibilityExtension on ColorScheme {
  Color get inverseOnSurface => onInverseSurface;
}

extension AppIconThemeDataExtension on IconThemeData {
  IconThemeData withResolvedColor(Color color) {
    return copyWith(color: color);
  }

  IconThemeData withResolvedColorAndSize({
    required Color color,
    required double size,
  }) {
    return copyWith(color: color, size: size);
  }
}
