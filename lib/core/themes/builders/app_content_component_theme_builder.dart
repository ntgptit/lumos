import 'package:flutter/material.dart';

import '../component/app_card_tokens.dart';
import '../../constants/dimensions.dart';
import '../extensions/theme_extensions.dart';

abstract final class AppContentComponentThemeBuilder {
  static CardThemeData cardTheme({
    required ColorScheme colorScheme,
    required AppCardTokens cardTokens,
  }) {
    return CardThemeData(
      color: colorScheme.surfaceContainerLow,
      elevation: WidgetSizes.none,
      margin: EdgeInsets.zero,
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
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      selectedColor: colorScheme.secondaryContainer,
      disabledColor: colorScheme.disabledContainerColor,
      side: BorderSide(
        color: colorScheme.outlineVariant,
        width: WidgetSizes.borderWidthRegular,
      ),
      labelStyle: textTheme.labelMedium?.copyWith(color: colorScheme.onSurface),
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSecondaryContainer,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radius.radiusLarge),
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
      minVerticalPadding: Insets.spacing8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radius.radiusLarge),
      ),
    );
  }
}
