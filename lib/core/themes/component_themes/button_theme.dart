import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

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
      disabledBackgroundColor: _disabledContainer(colorScheme),
      disabledForegroundColor: _disabledForeground(colorScheme),
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
      overlayColor: _overlayColor(colorScheme.primary),
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
      disabledBackgroundColor: _disabledContainer(colorScheme),
      disabledForegroundColor: _disabledForeground(colorScheme),
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size),
      padding: _padding(size: size, deviceType: deviceType),
      shape: _buttonShape(),
    );

    return base.copyWith(overlayColor: _overlayColor(colorScheme.onPrimary));
  }

  static ButtonStyle outlinedStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    ButtonSize size = ButtonSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    final ButtonStyle base = OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: _disabledForeground(colorScheme),
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size),
      padding: _padding(size: size, deviceType: deviceType),
      shape: _buttonShape(),
      side: BorderSide(
        color: colorScheme.outline,
        width: WidgetSizes.borderWidthRegular,
      ),
      backgroundColor: _transparentSurface(colorScheme),
    );

    return base.copyWith(
      side: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: _disabledContainer(colorScheme),
            width: WidgetSizes.borderWidthRegular,
          );
        }
        return BorderSide(
          color: colorScheme.outline,
          width: WidgetSizes.borderWidthRegular,
        );
      }),
      overlayColor: _overlayColor(colorScheme.primary),
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
      disabledForegroundColor: _disabledForeground(colorScheme),
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size),
      padding: _padding(size: size, deviceType: deviceType),
      shape: _buttonShape(),
      backgroundColor: _transparentSurface(colorScheme),
    );
    return base.copyWith(overlayColor: _overlayColor(colorScheme.primary));
  }

  static ButtonStyle iconStyle({
    required ColorScheme colorScheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    final ButtonStyle base = IconButton.styleFrom(
      foregroundColor: colorScheme.onSurfaceVariant,
      disabledForegroundColor: _disabledForeground(colorScheme),
      minimumSize: const Size(
        WidgetSizes.minTouchTarget,
        WidgetSizes.minTouchTarget,
      ),
      iconSize: _iconSize(deviceType),
      padding: const EdgeInsets.all(Insets.spacing8),
      shape: _buttonShape(),
      backgroundColor: _transparentSurface(colorScheme),
    );

    return base.copyWith(
      foregroundColor: WidgetStateProperty.resolveWith((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return _disabledForeground(colorScheme);
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onSurfaceVariant;
      }),
      overlayColor: _overlayColor(colorScheme.onSurfaceVariant),
    );
  }
}

double _resolveElevatedElevation(Set<WidgetState> states) {
  if (states.contains(WidgetState.disabled)) {
    return _elevationDisabled;
  }
  if (states.contains(WidgetState.hovered)) {
    return _elevationHovered;
  }
  if (states.contains(WidgetState.focused)) {
    return _elevationFocused;
  }
  if (states.contains(WidgetState.pressed)) {
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

WidgetStateProperty<Color?> _overlayColor(Color color) {
  return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return color.withValues(alpha: WidgetOpacities.statePress);
    }
    if (states.contains(WidgetState.hovered)) {
      return color.withValues(alpha: WidgetOpacities.stateHover);
    }
    if (states.contains(WidgetState.focused)) {
      return color.withValues(alpha: WidgetOpacities.stateFocus);
    }
    return null;
  });
}

Color _disabledForeground(ColorScheme colorScheme) {
  return colorScheme.onSurface.withValues(
    alpha: WidgetOpacities.disabledContent,
  );
}

Color _disabledContainer(ColorScheme colorScheme) {
  return colorScheme.onSurface.withValues(alpha: WidgetOpacities.divider);
}

Color _transparentSurface(ColorScheme colorScheme) {
  return colorScheme.surface.withValues(alpha: WidgetOpacities.transparent);
}
