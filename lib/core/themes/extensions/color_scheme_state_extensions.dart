import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

extension ColorSchemeStateColorsExtension on ColorScheme {
  Color get disabledContentColor {
    return onSurface.withValues(alpha: WidgetOpacities.disabledContent);
  }

  Color get disabledContainerColor {
    return onSurface.withValues(alpha: WidgetOpacities.divider);
  }

  Color get transparentSurfaceColor {
    return surface.withValues(alpha: WidgetOpacities.transparent);
  }

  Color get transparentScrimColor {
    return scrim.withValues(alpha: WidgetOpacities.transparent);
  }

  Color get modalBarrierScrimColor {
    if (brightness == Brightness.dark) {
      return scrim.withValues(alpha: WidgetOpacities.scrimDark);
    }
    return scrim.withValues(alpha: WidgetOpacities.scrimLight);
  }
}
