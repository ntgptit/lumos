import 'package:flutter/material.dart';
import 'package:lumos/core/theme/responsive/adaptive_component_size.dart';
import 'package:lumos/core/theme/responsive/adaptive_icon_size.dart';

@immutable
class ComponentThemeExt extends ThemeExtension<ComponentThemeExt> {
  const ComponentThemeExt({
    required this.iconSize,
    required this.componentSize,
  });

  final AdaptiveIconSize iconSize;
  final AdaptiveComponentSize componentSize;

  @override
  ComponentThemeExt copyWith({
    AdaptiveIconSize? iconSize,
    AdaptiveComponentSize? componentSize,
  }) {
    return ComponentThemeExt(
      iconSize: iconSize ?? this.iconSize,
      componentSize: componentSize ?? this.componentSize,
    );
  }

  @override
  ComponentThemeExt lerp(ThemeExtension<ComponentThemeExt>? other, double t) {
    if (other is! ComponentThemeExt) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}
