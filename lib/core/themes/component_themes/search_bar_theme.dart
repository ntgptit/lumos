import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../extensions/theme_extensions.dart';

abstract final class SearchBarThemes {
  static SearchBarThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return SearchBarThemeData(
      constraints: const BoxConstraints(minHeight: WidgetSizes.minTouchTarget),
      elevation: const WidgetStatePropertyAll<double>(WidgetSizes.none),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder()),
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: Insets.spacing12),
      ),
      side: WidgetStatePropertyAll<BorderSide>(
        BorderSide(
          color: colorScheme.outlineVariant,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
      backgroundColor: WidgetStatePropertyAll<Color>(
        colorScheme.surfaceContainerHighest,
      ),
      surfaceTintColor: WidgetStatePropertyAll<Color>(
        colorScheme.surface.withValues(alpha: WidgetOpacities.transparent),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.bodyMedium),
      hintStyle: WidgetStatePropertyAll<TextStyle?>(
        textTheme.bodyMedium.withResolvedColor(
          colorScheme.onSurfaceVariant.withValues(
            alpha: WidgetOpacities.statePress,
          ),
        ),
      ),
      overlayColor: colorScheme.onSurface.asInteractiveOverlayProperty(),
    );
  }
}
