import 'package:flutter/material.dart';

import '../component/app_button_tokens.dart';
import '../../constants/dimensions.dart';
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
  }) {
    return IconButtonThemeData(
      style: iconStyle(colorScheme: colorScheme, buttonTokens: buttonTokens),
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
        alpha: WidgetOpacities.elevationLevel2,
      ),
      surfaceTintColor: colorScheme.surfaceTint,
    );
    return baseStyle.copyWith(
      elevation: WidgetStateProperty.resolveWith<double>(_resolveElevation),
      overlayColor: colorScheme.primary.asInteractiveOverlayProperty(),
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
      overlayColor: colorScheme.onPrimary.asInteractiveOverlayProperty(),
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
    );
  }

  static ButtonStyle iconStyle({
    required ColorScheme colorScheme,
    required AppButtonTokens buttonTokens,
  }) {
    final ButtonStyle baseStyle = IconButton.styleFrom(
      foregroundColor: colorScheme.onSurfaceVariant,
      disabledForegroundColor: colorScheme.disabledContentColor,
      minimumSize: const Size(
        WidgetSizes.minTouchTarget,
        WidgetSizes.minTouchTarget,
      ),
      iconSize: buttonTokens.iconSizeMd,
      padding: const EdgeInsets.all(Insets.spacing8),
      shape: _shape(size: AppButtonSize.medium, buttonTokens: buttonTokens),
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
    );
  }
}

double _resolveElevation(Set<WidgetState> states) {
  if (states.isDisabled) {
    return AppElevationTokens.level0;
  }
  if (states.isHovered) {
    return AppElevationTokens.level2;
  }
  if (states.isFocused) {
    return AppElevationTokens.level1;
  }
  if (states.isPressed) {
    return AppElevationTokens.level1;
  }
  return AppElevationTokens.level1;
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
