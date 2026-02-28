import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

/// Input size variants — mirrors [ButtonSize] / [ChipSize] convention.
///
/// - [small]  : Compact inline fields, search bars in dense layouts (40dp).
/// - [medium] : Default form fields (48dp — meets WCAG touch target).
/// - [large]  : Prominent search bars, primary form fields (56dp).
enum InputSize { small, medium, large }

/// Centralised input decoration theming for Social/Lifestyle app.
///
/// Covers all input use cases:
///   - Text input / Search
///   - Password field
///   - Multiline / TextArea
///   - Dropdown / Select
///
/// Supports:
///   - [InputSize]  — small / medium / large
///   - Full states  — enabled / focused / error / disabled / focusedError
///   - Icon support — prefix / suffix icon color per state
///   - DeviceType   — padding relaxed on tablet/desktop
///
/// Usage — global theme:
/// ```dart
/// inputDecorationTheme: InputDecorationThemes.build(
///   colorScheme: colorScheme,
///   textTheme: textTheme,
/// ),
/// ```
///
/// Usage — size override per field:
/// ```dart
/// TextField(
///   decoration: InputDecorationThemes.decorationOf(
///     colorScheme: colorScheme,
///     textTheme: textTheme,
///     size: InputSize.small,
///   ),
/// )
/// ```
abstract final class InputDecorationThemes {
  // Focused border width: M3 spec uses 2dp for focused state (vs 1dp resting).
  // ---------------------------------------------------------------------------
  // Global theme builder
  // ---------------------------------------------------------------------------

  /// Default input theme — medium size, mobile density.
  static InputDecorationTheme build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return _buildTheme(
      colorScheme: colorScheme,
      textTheme: textTheme,
      size: InputSize.medium,
      deviceType: deviceType,
    );
  }

  // ---------------------------------------------------------------------------
  // Per-widget decoration builder
  // ---------------------------------------------------------------------------

  /// Returns an [InputDecoration] for a specific [InputSize].
  /// Apply directly to [TextField.decoration] or [TextFormField.decoration].
  static InputDecoration decorationOf({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    InputSize size = InputSize.medium,
    DeviceType deviceType = DeviceType.mobile,
    String? labelText,
    String? hintText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int? maxLines,
  }) {
    final InputDecorationTheme theme = _buildTheme(
      colorScheme: colorScheme,
      textTheme: textTheme,
      size: size,
      deviceType: deviceType,
    );

    return InputDecoration(
      filled: true,
      fillColor: theme.fillColor,
      border: theme.border,
      enabledBorder: theme.enabledBorder,
      focusedBorder: theme.focusedBorder,
      errorBorder: theme.errorBorder,
      focusedErrorBorder: theme.focusedErrorBorder,
      disabledBorder: theme.disabledBorder,
      labelStyle: theme.labelStyle,
      floatingLabelStyle: theme.floatingLabelStyle,
      hintStyle: theme.hintStyle,
      errorStyle: theme.errorStyle,
      helperStyle: theme.helperStyle,
      prefixIconColor: theme.prefixIconColor,
      suffixIconColor: theme.suffixIconColor,
      contentPadding: theme.contentPadding,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      // TextArea: remove maxLines constraint from decoration level.
      // Set maxLines on TextField directly.
    );
  }

  // ---------------------------------------------------------------------------
  // Core builder
  // ---------------------------------------------------------------------------

  static InputDecorationTheme _buildTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required InputSize size,
    required DeviceType deviceType,
  }) {
    final EdgeInsets contentPadding = _contentPadding(
      size: size,
      deviceType: deviceType,
    );
    final OutlineInputBorder enabledBorder = _buildEnabledBorder(
      colorScheme: colorScheme,
    );
    final OutlineInputBorder focusedBorder = _buildFocusedBorder(
      colorScheme: colorScheme,
    );
    final OutlineInputBorder errorBorder = _buildErrorBorder(
      colorScheme: colorScheme,
    );
    final OutlineInputBorder focusedErrorBorder = _buildFocusedErrorBorder(
      colorScheme: colorScheme,
    );
    final OutlineInputBorder disabledBorder = _buildDisabledBorder(
      colorScheme: colorScheme,
    );
    return _composeTheme(
      colorScheme: colorScheme,
      textTheme: textTheme,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      disabledBorder: disabledBorder,
      contentPadding: contentPadding,
    );
  }

  // ---------------------------------------------------------------------------
  // Size helpers
  // ---------------------------------------------------------------------------

  static EdgeInsets _contentPadding({
    required InputSize size,
    required DeviceType deviceType,
  }) {
    final double vPad = switch (size) {
      InputSize.small => Insets.spacing8, // 40dp total height
      InputSize.medium =>
        Insets.spacing12, // 48dp total height — WCAG touch target
      InputSize.large => Insets.spacing16, // 56dp total height
    };

    final double hBase = switch (size) {
      InputSize.small => Insets.spacing12,
      InputSize.medium => Insets.spacing16,
      InputSize.large => Insets.spacing16,
    };

    final double hExtra = switch (deviceType) {
      DeviceType.mobile => 0,
      DeviceType.tablet => Insets.spacing4,
      DeviceType.desktop => Insets.spacing8,
    };

    return EdgeInsets.symmetric(horizontal: hBase + hExtra, vertical: vPad);
  }
}

OutlineInputBorder _buildEnabledBorder({required ColorScheme colorScheme}) {
  return AppShape.input(
    borderColor: colorScheme.outline.withValues(
      alpha: WidgetOpacities.elevationLevel3,
    ),
  );
}

OutlineInputBorder _buildFocusedBorder({required ColorScheme colorScheme}) {
  return AppShape.inputFocused(borderColor: colorScheme.primary);
}

OutlineInputBorder _buildErrorBorder({required ColorScheme colorScheme}) {
  return AppShape.input(borderColor: colorScheme.error);
}

OutlineInputBorder _buildFocusedErrorBorder({
  required ColorScheme colorScheme,
}) {
  return AppShape.inputFocused(borderColor: colorScheme.error);
}

OutlineInputBorder _buildDisabledBorder({required ColorScheme colorScheme}) {
  return AppShape.input(
    borderColor: colorScheme.onSurface.withValues(
      alpha: WidgetOpacities.disabledContent,
    ),
  );
}

InputDecorationTheme _composeTheme({
  required ColorScheme colorScheme,
  required TextTheme textTheme,
  required OutlineInputBorder enabledBorder,
  required OutlineInputBorder focusedBorder,
  required OutlineInputBorder errorBorder,
  required OutlineInputBorder focusedErrorBorder,
  required OutlineInputBorder disabledBorder,
  required EdgeInsets contentPadding,
}) {
  return InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surfaceContainerHighest,
    border: enabledBorder,
    enabledBorder: enabledBorder,
    focusedBorder: focusedBorder,
    errorBorder: errorBorder,
    focusedErrorBorder: focusedErrorBorder,
    disabledBorder: disabledBorder,
    labelStyle: textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    ),
    floatingLabelStyle: _buildFloatingLabelStyle(
      colorScheme: colorScheme,
      textTheme: textTheme,
    ),
    hintStyle: textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant.withValues(
        alpha: WidgetOpacities.statePress,
      ),
    ),
    errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
    helperStyle: textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    ),
    prefixIconColor: _buildPrefixIconColor(colorScheme: colorScheme),
    suffixIconColor: _buildSuffixIconColor(colorScheme: colorScheme),
    contentPadding: contentPadding,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    alignLabelWithHint: true,
  );
}

WidgetStateTextStyle _buildFloatingLabelStyle({
  required ColorScheme colorScheme,
  required TextTheme textTheme,
}) {
  return WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
    final TextStyle base =
        textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant) ??
        const TextStyle();
    if (states.contains(WidgetState.error)) {
      return base.copyWith(color: colorScheme.error);
    }
    if (states.contains(WidgetState.focused)) {
      return base.copyWith(color: colorScheme.primary);
    }
    if (states.contains(WidgetState.disabled)) {
      return base.copyWith(
        color: colorScheme.onSurface.withValues(
          alpha: WidgetOpacities.disabledContent,
        ),
      );
    }
    return base;
  });
}

WidgetStateColor _buildPrefixIconColor({required ColorScheme colorScheme}) {
  return WidgetStateColor.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return colorScheme.onSurface.withValues(
        alpha: WidgetOpacities.disabledContent,
      );
    }
    if (states.contains(WidgetState.focused)) {
      return colorScheme.primary;
    }
    return colorScheme.onSurfaceVariant;
  });
}

WidgetStateColor _buildSuffixIconColor({required ColorScheme colorScheme}) {
  return WidgetStateColor.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return colorScheme.onSurface.withValues(
        alpha: WidgetOpacities.disabledContent,
      );
    }
    if (states.contains(WidgetState.error)) {
      return colorScheme.error;
    }
    if (states.contains(WidgetState.focused)) {
      return colorScheme.primary;
    }
    return colorScheme.onSurfaceVariant;
  });
}
