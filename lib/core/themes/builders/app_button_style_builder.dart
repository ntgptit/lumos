import 'package:flutter/material.dart';

import '../component/app_button_tokens.dart';
import '../foundation/app_foundation.dart';
import '../extensions/theme_extensions.dart';
import '../semantic/app_elevation_tokens.dart';

enum AppButtonSize { small, medium, large }

abstract final class AppButtonStyleBuilder {
  static ElevatedButtonThemeData elevated({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
  }) {
    return ElevatedButtonThemeData(
      style: elevatedStyle(
        colorScheme: colorScheme,
        textTheme: textTheme,
        buttonTokens: buttonTokens,
      ),
    );
  }

  static FilledButtonThemeData filled({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
  }) {
    return FilledButtonThemeData(
      style: filledStyle(
        colorScheme: colorScheme,
        textTheme: textTheme,
        buttonTokens: buttonTokens,
      ),
    );
  }

  static OutlinedButtonThemeData outlined({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
  }) {
    return OutlinedButtonThemeData(
      style: outlinedStyle(
        colorScheme: colorScheme,
        textTheme: textTheme,
        buttonTokens: buttonTokens,
      ),
    );
  }

  static TextButtonThemeData text({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
  }) {
    return TextButtonThemeData(
      style: textStyle(
        colorScheme: colorScheme,
        textTheme: textTheme,
        buttonTokens: buttonTokens,
      ),
    );
  }

  static IconButtonThemeData icon({
    required ColorScheme colorScheme,
    required AppButtonTokens buttonTokens,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return IconButtonThemeData(
      style: iconStyle(
        colorScheme: colorScheme,
        buttonTokens: buttonTokens,
        size: size,
      ),
    );
  }

  static ButtonStyle elevatedStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    final ButtonStyle baseStyle = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.surfaceContainerLow,
      foregroundColor: colorScheme.primary,
      disabledBackgroundColor: colorScheme.disabledContainerColor,
      disabledForegroundColor: colorScheme.disabledContentColor,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size, buttonTokens: buttonTokens),
      padding: _padding(size: size, buttonTokens: buttonTokens),
      shape: _shape(size: size, buttonTokens: buttonTokens),
      shadowColor: colorScheme.shadow.withValues(
        alpha: AppOpacity.elevationLevel2,
      ),
      surfaceTintColor: colorScheme.surfaceTint,
    );
    return baseStyle.copyWith(
      elevation: WidgetStateProperty.resolveWith<double>(_resolveElevation),
      overlayColor: colorScheme.primary.asInteractiveOverlayProperty(),
      animationDuration: AppMotion.fast,
    );
  }

  static ButtonStyle filledStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    final ButtonStyle baseStyle = FilledButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      disabledBackgroundColor: colorScheme.disabledContainerColor,
      disabledForegroundColor: colorScheme.disabledContentColor,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size, buttonTokens: buttonTokens),
      padding: _padding(size: size, buttonTokens: buttonTokens),
      shape: _shape(size: size, buttonTokens: buttonTokens),
    );
    return baseStyle.copyWith(
      overlayColor: _resolveFilledOverlayBase(
        colorScheme,
      ).asInteractiveOverlayProperty(),
      animationDuration: AppMotion.fast,
    );
  }

  static ButtonStyle tonalStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    final ButtonStyle baseStyle = FilledButton.styleFrom(
      backgroundColor: colorScheme.secondaryContainer,
      foregroundColor: colorScheme.onSecondaryContainer,
      disabledBackgroundColor: colorScheme.disabledContainerColor,
      disabledForegroundColor: colorScheme.disabledContentColor,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size, buttonTokens: buttonTokens),
      padding: _padding(size: size, buttonTokens: buttonTokens),
      shape: _shape(size: size, buttonTokens: buttonTokens),
    );
    return baseStyle.copyWith(
      overlayColor: colorScheme.onSecondaryContainer
          .asInteractiveOverlayProperty(),
      animationDuration: AppMotion.fast,
    );
  }

  static ButtonStyle outlinedStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    final ButtonStyle baseStyle = OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.disabledContentColor,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size, buttonTokens: buttonTokens),
      padding: _padding(size: size, buttonTokens: buttonTokens),
      shape: _shape(size: size, buttonTokens: buttonTokens),
      side: BorderSide(
        color: colorScheme.outline,
        width: WidgetSizes.borderWidthRegular,
      ),
      backgroundColor: colorScheme.transparentSurfaceColor,
    );
    return baseStyle.copyWith(
      side: WidgetStateProperty.resolveWith<BorderSide>((
        Set<WidgetState> states,
      ) {
        if (states.isDisabled) {
          return BorderSide(
            color: colorScheme.disabledContainerColor,
            width: WidgetSizes.borderWidthRegular,
          );
        }
        return BorderSide(
          color: colorScheme.outline,
          width: WidgetSizes.borderWidthRegular,
        );
      }),
      overlayColor: colorScheme.primary.asInteractiveOverlayProperty(),
      animationDuration: AppMotion.fast,
    );
  }

  static ButtonStyle textStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    final ButtonStyle baseStyle = TextButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.disabledContentColor,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size, buttonTokens: buttonTokens),
      padding: _padding(size: size, buttonTokens: buttonTokens),
      shape: _shape(size: size, buttonTokens: buttonTokens),
      backgroundColor: colorScheme.transparentSurfaceColor,
    );
    return baseStyle.copyWith(
      overlayColor: colorScheme.primary.asInteractiveOverlayProperty(),
      animationDuration: AppMotion.fast,
    );
  }

  static ButtonStyle iconStyle({
    required ColorScheme colorScheme,
    required AppButtonTokens buttonTokens,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    final ButtonStyle baseStyle = IconButton.styleFrom(
      foregroundColor: colorScheme.onSurfaceVariant,
      disabledForegroundColor: colorScheme.disabledContentColor,
      minimumSize: const Size(
        WidgetSizes.minTouchTarget,
        WidgetSizes.minTouchTarget,
      ),
      iconSize: _iconSize(size: size, buttonTokens: buttonTokens),
      padding: const EdgeInsets.all(AppSpacing.sm),
      shape: _shape(size: size, buttonTokens: buttonTokens),
      backgroundColor: colorScheme.transparentSurfaceColor,
    );
    return baseStyle.copyWith(
      foregroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.isDisabled) {
          return colorScheme.disabledContentColor;
        }
        if (states.isSelected) {
          return colorScheme.primary;
        }
        return colorScheme.onSurfaceVariant;
      }),
      overlayColor: colorScheme.onSurfaceVariant.asInteractiveOverlayProperty(),
      animationDuration: AppMotion.fast,
    );
  }
}

double _resolveElevation(Set<WidgetState> states) {
  if (states.isDisabled) {
    return AppElevationTokens.level0;
  }
  // M3: hovered elevated button lifts to level2.
  if (states.isHovered) {
    return AppElevationTokens.level2;
  }
  // M3: pressed elevated button stays at level1.
  if (states.isPressed) {
    return AppElevationTokens.level1;
  }
  // M3: focused elevated button stays at level1.
  if (states.isFocused) {
    return AppElevationTokens.level1;
  }
  // M3: default elevated button uses level1.
  return AppElevationTokens.level1;
}

Color _resolveFilledOverlayBase(ColorScheme colorScheme) {
  const double minimumVisibleContrast = 1.01;
  final Color background = colorScheme.primary;
  final List<Color> candidates = <Color>[
    colorScheme.onPrimary,
    colorScheme.onSurface,
    colorScheme.inversePrimary,
  ];
  final Color resolved = _pickHighestContrastColor(
    background: background,
    candidates: candidates,
  );
  if (_contrastRatio(resolved, background) >= minimumVisibleContrast) {
    return resolved;
  }
  return colorScheme.onPrimary;
}

Color _pickHighestContrastColor({
  required Color background,
  required List<Color> candidates,
}) {
  Color best = candidates.first;
  double bestContrast = _contrastRatio(best, background);

  for (final Color candidate in candidates.skip(1)) {
    final double contrast = _contrastRatio(candidate, background);
    if (contrast > bestContrast) {
      best = candidate;
      bestContrast = contrast;
    }
  }

  return best;
}

double _contrastRatio(Color foreground, Color background) {
  final double foregroundLuminance = foreground.computeLuminance();
  final double backgroundLuminance = background.computeLuminance();
  final double lighter = foregroundLuminance >= backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final double darker = foregroundLuminance < backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

TextStyle? _textStyle({
  required TextTheme textTheme,
  required AppButtonSize size,
}) {
  return switch (size) {
    AppButtonSize.small => textTheme.labelMedium,
    AppButtonSize.medium => textTheme.labelLarge,
    AppButtonSize.large => textTheme.labelLarge,
  };
}

Size _minimumSize({
  required AppButtonSize size,
  required AppButtonTokens buttonTokens,
}) {
  final double height = switch (size) {
    AppButtonSize.small => buttonTokens.heightSm,
    AppButtonSize.medium => buttonTokens.heightMd,
    AppButtonSize.large => buttonTokens.heightLg,
  };
  return Size(WidgetSizes.buttonMinWidth, height);
}

double _iconSize({
  required AppButtonSize size,
  required AppButtonTokens buttonTokens,
}) {
  return switch (size) {
    AppButtonSize.small => buttonTokens.iconSizeSm,
    AppButtonSize.medium => buttonTokens.iconSizeMd,
    AppButtonSize.large => buttonTokens.iconSizeLg,
  };
}

EdgeInsets _padding({
  required AppButtonSize size,
  required AppButtonTokens buttonTokens,
}) {
  return switch (size) {
    AppButtonSize.small => buttonTokens.paddingSm,
    AppButtonSize.medium => buttonTokens.paddingMd,
    AppButtonSize.large => buttonTokens.paddingLg,
  };
}

RoundedRectangleBorder _shape({
  required AppButtonSize size,
  required AppButtonTokens buttonTokens,
}) {
  final double radius = switch (size) {
    AppButtonSize.small => buttonTokens.radiusSm,
    AppButtonSize.medium => buttonTokens.radiusMd,
    AppButtonSize.large => buttonTokens.radiusLg,
  };
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
}
