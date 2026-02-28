import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../extensions/color_scheme_state_extensions.dart';
import '../extensions/widget_state_extensions.dart';

enum ButtonSize { small, medium, large }

const double _cornerRadius = 20.0;
const double _minimumWidth = 64.0;
const double _elevationResting = 1.0;
const double _elevationHovered = 3.0;
const double _elevationFocused = 1.0;
const double _elevationPressed = 1.0;
const double _elevationDisabled = 0.0;

abstract final class ButtonThemes {
  static ElevatedButtonThemeData elevated({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return ElevatedButtonThemeData(
      style: elevatedStyle(
        colorScheme: colorScheme,
        textTheme: textTheme,
        deviceType: deviceType,
      ),
    );
  }

  static FilledButtonThemeData filled({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return FilledButtonThemeData(
      style: filledStyle(
        colorScheme: colorScheme,
        textTheme: textTheme,
        deviceType: deviceType,
      ),
    );
  }

  static OutlinedButtonThemeData outlined({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return OutlinedButtonThemeData(
      style: outlinedStyle(
        colorScheme: colorScheme,
        textTheme: textTheme,
        deviceType: deviceType,
      ),
    );
  }

  static TextButtonThemeData text({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return TextButtonThemeData(
      style: textStyle(
        colorScheme: colorScheme,
        textTheme: textTheme,
        deviceType: deviceType,
      ),
    );
  }

  static IconButtonThemeData icon({
    required ColorScheme colorScheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return IconButtonThemeData(
      style: iconStyle(colorScheme: colorScheme, deviceType: deviceType),
    );
  }

  static ButtonStyle elevatedStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    ButtonSize size = ButtonSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    final ButtonStyle base = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.surfaceContainerLow,
      foregroundColor: colorScheme.primary,
      disabledBackgroundColor: colorScheme.disabledContainerColor,
      disabledForegroundColor: colorScheme.disabledContentColor,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size),
      padding: _padding(size: size, deviceType: deviceType),
      shape: _buttonShape(),
      shadowColor: colorScheme.shadow.withValues(
        alpha: WidgetOpacities.elevationLevel2,
      ),
      surfaceTintColor: colorScheme.surfaceTint,
    );

    return base.copyWith(
      elevation: WidgetStateProperty.resolveWith(_resolveElevatedElevation),
      overlayColor: colorScheme.primary.asInteractiveOverlayProperty(),
    );
  }

  static ButtonStyle filledStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    ButtonSize size = ButtonSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    final ButtonStyle base = FilledButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      disabledBackgroundColor: colorScheme.disabledContainerColor,
      disabledForegroundColor: colorScheme.disabledContentColor,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size),
      padding: _padding(size: size, deviceType: deviceType),
      shape: _buttonShape(),
    );

    return base.copyWith(
      overlayColor: colorScheme.onPrimary.asInteractiveOverlayProperty(),
    );
  }

  static ButtonStyle outlinedStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    ButtonSize size = ButtonSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    final ButtonStyle base = OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.disabledContentColor,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size),
      padding: _padding(size: size, deviceType: deviceType),
      shape: _buttonShape(),
      side: BorderSide(
        color: colorScheme.outline,
        width: WidgetSizes.borderWidthRegular,
      ),
      backgroundColor: colorScheme.transparentSurfaceColor,
    );

    return base.copyWith(
      side: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
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
    ButtonSize size = ButtonSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    final ButtonStyle base = TextButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.disabledContentColor,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size),
      padding: _padding(size: size, deviceType: deviceType),
      shape: _buttonShape(),
      backgroundColor: colorScheme.transparentSurfaceColor,
    );
    return base.copyWith(
      overlayColor: colorScheme.primary.asInteractiveOverlayProperty(),
    );
  }

  static ButtonStyle iconStyle({
    required ColorScheme colorScheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    final ButtonStyle base = IconButton.styleFrom(
      foregroundColor: colorScheme.onSurfaceVariant,
      disabledForegroundColor: colorScheme.disabledContentColor,
      minimumSize: const Size(
        WidgetSizes.minTouchTarget,
        WidgetSizes.minTouchTarget,
      ),
      iconSize: _iconSize(deviceType),
      padding: const EdgeInsets.all(Insets.spacing8),
      shape: _buttonShape(),
      backgroundColor: colorScheme.transparentSurfaceColor,
    );

    return base.copyWith(
      foregroundColor: WidgetStateProperty.resolveWith((
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

double _resolveElevatedElevation(Set<WidgetState> states) {
  if (states.isDisabled) {
    return _elevationDisabled;
  }
  if (states.isHovered) {
    return _elevationHovered;
  }
  if (states.isFocused) {
    return _elevationFocused;
  }
  if (states.isPressed) {
    return _elevationPressed;
  }
  return _elevationResting;
}

TextStyle? _textStyle({
  required TextTheme textTheme,
  required ButtonSize size,
}) {
  return switch (size) {
    ButtonSize.small => textTheme.labelMedium,
    ButtonSize.medium => textTheme.labelLarge,
    ButtonSize.large => textTheme.labelLarge,
  };
}

Size _minimumSize({required ButtonSize size}) {
  final double height = switch (size) {
    ButtonSize.small => WidgetSizes.buttonHeightSmall,
    ButtonSize.medium => WidgetSizes.buttonHeightMedium,
    ButtonSize.large => WidgetSizes.buttonHeightLarge,
  };
  return Size(_minimumWidth, height);
}

EdgeInsets _padding({
  required ButtonSize size,
  required DeviceType deviceType,
}) {
  final double horizontal = switch (size) {
    ButtonSize.small => Insets.spacing12,
    ButtonSize.medium => Insets.spacing24,
    ButtonSize.large => Insets.spacing24,
  };
  final double vertical = switch (size) {
    ButtonSize.small => Insets.spacing4,
    ButtonSize.medium => Insets.spacing8,
    ButtonSize.large => Insets.spacing12,
  };
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}

double _iconSize(DeviceType deviceType) {
  return switch (deviceType) {
    DeviceType.mobile => IconSizes.iconMedium,
    DeviceType.tablet => IconSizes.iconMedium,
    DeviceType.desktop => IconSizes.iconMedium,
  };
}

RoundedRectangleBorder _buttonShape() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(_cornerRadius),
  );
}
