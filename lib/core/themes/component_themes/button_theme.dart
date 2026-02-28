import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

/// Button size variants.
///
/// - [small]  : Inline actions, tags, compact UI (32dp height).
/// - [medium] : Default for most interactions (40dp height).
/// - [large]  : Primary CTA, full-width actions (48dp height).
enum ButtonSize { small, medium, large }

/// Centralised button theming for Social/Lifestyle app.
///
/// Supports:
///   - All 4 Material button types: elevated, filled, outlined, text
///   - [ButtonSize] — small / medium / large
///   - [DeviceType] — compact padding on mobile, relaxed on tablet/desktop
///   - Icon buttons via [IconButton] theme
///
/// Usage — global theme:
/// ```dart
/// elevatedButtonTheme : ButtonThemes.elevated(colorScheme: cs, textTheme: tt),
/// filledButtonTheme   : ButtonThemes.filled(colorScheme: cs, textTheme: tt),
/// outlinedButtonTheme : ButtonThemes.outlined(colorScheme: cs, textTheme: tt),
/// textButtonTheme     : ButtonThemes.text(colorScheme: cs, textTheme: tt),
/// iconButtonTheme     : ButtonThemes.icon(colorScheme: cs),
/// ```
///
/// Usage — per-widget size override:
/// ```dart
/// ElevatedButton(
///   style: ButtonThemes.elevatedStyle(
///     colorScheme: colorScheme,
///     textTheme: textTheme,
///     size: ButtonSize.small,
///   ),
///   ...
/// )
/// ```
abstract final class ButtonThemes {
  // ---------------------------------------------------------------------------
  // Global theme builders — wired into ThemeData
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // Per-widget style builders — use for size overrides in specific widgets
  // ---------------------------------------------------------------------------

  static ButtonStyle elevatedStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    ButtonSize size = ButtonSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      disabledBackgroundColor: colorScheme.onSurface.withValues(
        alpha: WidgetOpacities.disabledContent, // 0.38
      ),
      disabledForegroundColor: colorScheme.onSurface.withValues(
        alpha: WidgetOpacities.disabledContent,
      ),
      elevation: WidgetSizes.none,
      shadowColor: Colors.transparent,
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size, deviceType: deviceType),
      padding: _padding(size: size, deviceType: deviceType),
      shape: AppShape.button(),
    );
  }

  static ButtonStyle filledStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    ButtonSize size = ButtonSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return FilledButton.styleFrom(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      disabledBackgroundColor: colorScheme.onSurface.withValues(
        alpha: WidgetOpacities.disabledContent,
      ),
      disabledForegroundColor: colorScheme.onSurface.withValues(
        alpha: WidgetOpacities.disabledContent,
      ),
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size, deviceType: deviceType),
      padding: _padding(size: size, deviceType: deviceType),
      shape: AppShape.button(),
    );
  }

  static ButtonStyle outlinedStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    ButtonSize size = ButtonSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.onSurface.withValues(
        alpha: WidgetOpacities.disabledContent,
      ),
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size, deviceType: deviceType),
      padding: _padding(size: size, deviceType: deviceType),
      shape: AppShape.button(
        side: BorderSide(
          color: colorScheme.primary,
          width: WidgetSizes.borderWidthRegular, // 1.2
        ),
      ),
    ).copyWith(
      // Dim border when disabled — styleFrom does not expose disabledSide directly.
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: colorScheme.onSurface.withValues(
              alpha: WidgetOpacities.disabledContent,
            ),
            width: WidgetSizes.borderWidthRegular,
          );
        }
        return BorderSide(
          color: colorScheme.primary,
          width: WidgetSizes.borderWidthRegular,
        );
      }),
    );
  }

  static ButtonStyle textStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    ButtonSize size = ButtonSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return TextButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.onSurface.withValues(
        alpha: WidgetOpacities.disabledContent,
      ),
      textStyle: _textStyle(textTheme: textTheme, size: size),
      minimumSize: _minimumSize(size: size, deviceType: deviceType),
      padding: _padding(size: size, deviceType: deviceType),
      shape: AppShape.button(),
    );
  }

  static ButtonStyle iconStyle({
    required ColorScheme colorScheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return IconButton.styleFrom(
      foregroundColor: colorScheme.onSurfaceVariant,
      // Minimum touch target: 48dp regardless of device (WCAG 2.5.5).
      minimumSize: const Size(
        WidgetSizes.minTouchTarget,
        WidgetSizes.minTouchTarget,
      ),
      iconSize: _iconSize(deviceType),
    );
  }

  // ---------------------------------------------------------------------------
  // Size helpers
  // ---------------------------------------------------------------------------

  static TextStyle? _textStyle({
    required TextTheme textTheme,
    required ButtonSize size,
  }) {
    return switch (size) {
      ButtonSize.small => textTheme.labelMedium,
      ButtonSize.medium => textTheme.labelLarge,
      ButtonSize.large => textTheme.labelLarge,
    };
  }

  /// Minimum tap area — ensures touch targets meet WCAG on all sizes.
  static Size _minimumSize({
    required ButtonSize size,
    required DeviceType deviceType,
  }) {
    final double height = switch (size) {
      ButtonSize.small => WidgetSizes.buttonHeightSmall, // 32dp
      ButtonSize.medium => WidgetSizes.buttonHeightMedium, // 40dp
      ButtonSize.large => WidgetSizes.buttonHeightLarge, // 48dp
    };

    // Tablet/desktop: slightly wider minimum to avoid overly narrow buttons
    // on larger screens where content is more spread out.
    final double minWidth = switch (deviceType) {
      DeviceType.mobile =>
        WidgetSizes.buttonHeightLarge, // 48dp — square-ish minimum
      DeviceType.tablet => WidgetSizes.buttonHeightLarge * 1.5, // 72dp
      DeviceType.desktop => WidgetSizes.buttonHeightLarge * 2, // 96dp
    };

    return Size(minWidth, height);
  }

  static EdgeInsets _padding({
    required ButtonSize size,
    required DeviceType deviceType,
  }) {
    // Base horizontal padding per size.
    final double hBase = switch (size) {
      ButtonSize.small => Insets.spacing12,
      ButtonSize.medium => Insets.spacing16,
      ButtonSize.large => Insets.spacing24,
    };

    // Base vertical padding per size.
    final double vBase = switch (size) {
      ButtonSize.small => Insets.spacing4,
      ButtonSize.medium => Insets.spacing8,
      ButtonSize.large => Insets.spacing12,
    };

    // Tablet/desktop: add extra horizontal breathing room.
    final double hExtra = switch (deviceType) {
      DeviceType.mobile => 0,
      DeviceType.tablet => Insets.spacing4,
      DeviceType.desktop => Insets.spacing8,
    };

    return EdgeInsets.symmetric(horizontal: hBase + hExtra, vertical: vBase);
  }

  static double _iconSize(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => IconSizes.iconMedium, // 24dp
      DeviceType.tablet =>
        IconSizes.iconMedium, // 24dp — icon size stays stable
      DeviceType.desktop => IconSizes.iconMedium,
    };
  }
}
