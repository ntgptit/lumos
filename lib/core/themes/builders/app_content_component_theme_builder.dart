import 'package:flutter/material.dart';

import '../component/app_card_tokens.dart';
import '../foundation/app_foundation.dart';
import '../extensions/theme_extensions.dart';

abstract final class AppContentComponentThemeBuilder {
  static CardThemeData cardTheme({
    required ColorScheme colorScheme,
    required AppCardTokens cardTokens,
  }) {
    return CardThemeData(
      color: colorScheme.surfaceContainerLowest,
      elevation: WidgetSizes.none,
      margin: EdgeInsets.zero,
      surfaceTintColor: colorScheme.surface.withValues(
        alpha: AppOpacity.transparent,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardTokens.radius),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: cardTokens.borderWidth,
        ),
      ),
    );
  }

  static ChipThemeData chipTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final TextStyle? chipLabelStyle = textTheme.titleSmall;
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      selectedColor: colorScheme.secondaryContainer,
      disabledColor: colorScheme.disabledContainerColor,
      side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
        if (states.isDisabled) {
          return BorderSide(
            color: colorScheme.disabledContainerColor,
            width: WidgetSizes.borderWidthRegular,
          );
        }
        return BorderSide(
          color: colorScheme.outlineVariant,
          width: WidgetSizes.borderWidthRegular,
        );
      }),
      labelStyle: chipLabelStyle?.copyWith(color: colorScheme.onSurface),
      secondaryLabelStyle: chipLabelStyle?.copyWith(
        color: colorScheme.onSecondaryContainer,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      showCheckmark: true,
    );
  }

  static ListTileThemeData listTileTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return ListTileThemeData(
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      titleTextStyle: textTheme.titleMedium,
      subtitleTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      minLeadingWidth: IconSizes.iconLarge,
      minVerticalPadding: AppSpacing.sm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    );
  }
}
