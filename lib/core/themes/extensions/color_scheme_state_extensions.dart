import 'package:flutter/material.dart';

import '../foundation/app_foundation.dart';

extension ColorSchemeStateColorsExtension on ColorScheme {
  Color get disabledContentColor {
    return onSurface.withValues(alpha: AppOpacity.disabledContent);
  }

  Color get disabledContainerColor {
    return onSurface.withValues(alpha: AppOpacity.divider);
  }

  Color get transparentSurfaceColor {
    return Colors.transparent;
  }

  Color get transparentScrimColor {
    return scrim.withValues(alpha: AppOpacity.transparent);
  }

  Color get modalBarrierScrimColor {
    if (brightness == Brightness.dark) {
      return scrim.withValues(alpha: AppOpacity.scrimDark);
    }
    return scrim.withValues(alpha: AppOpacity.scrimLight);
  }
}
