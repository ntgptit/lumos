import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

/// Snackbar severity variants.
///
/// - [info]    : General feedback, neutral actions (default).
/// - [success] : Confirmed action, completed task.
/// - [warning] : Cautionary message, recoverable state.
/// - [error]   : Failed action, destructive result.
enum SnackBarSeverity { info, success, warning, error }

/// Centralised snackbar theming for Social/Lifestyle app.
///
/// Supports:
///   - [SnackBarSeverity] — info / success / warning / error
///   - Brightness         — surface roles adjusted per brightness
///   - DeviceType         — width constrained on tablet/desktop
///   - Action button      — per-severity action color
///
/// Usage — global theme (info severity as default):
/// ```dart
/// snackBarTheme: SnackBarThemes.build(colorScheme: cs, textTheme: tt),
/// ```
///
/// Usage — severity-specific snackbar via ScaffoldMessenger:
/// ```dart
/// ScaffoldMessenger.of(context).showSnackBar(
///   SnackBarThemes.buildSnackBar(
///     message: 'Profile updated',
///     severity: SnackBarSeverity.success,
///     colorScheme: colorScheme,
///     textTheme: textTheme,
///   ),
/// );
/// ```
abstract final class SnackBarThemes {
  // Floating snackbar elevation: M3 spec uses 6dp to lift above page content.
  static const double _elevation = 6.0;

  // Width constraints for tablet/desktop — snackbar should not span full width.
  static const double _maxWidthTablet = 480.0;
  static const double _maxWidthDesktop = 560.0;

  // ---------------------------------------------------------------------------
  // Global theme builder — wired into ThemeData.snackBarTheme
  // Uses info/neutral severity as the default.
  // ---------------------------------------------------------------------------
  static SnackBarThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return _buildTheme(
      colorScheme: colorScheme,
      textTheme: textTheme,
      severity: SnackBarSeverity.info,
      deviceType: deviceType,
    );
  }

  // ---------------------------------------------------------------------------
  // Per-snackbar builder — returns a ready-to-show SnackBar widget
  // ---------------------------------------------------------------------------

  /// Builds a [SnackBar] with the given [severity] applied as a Theme override.
  /// Severity changes background, text, and action colors semantically.
  static SnackBar buildSnackBar({
    required String message,
    required SnackBarSeverity severity,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    String? actionLabel,
    VoidCallback? onAction,
    DeviceType deviceType = DeviceType.mobile,
    Duration duration = MotionDurations.snackbar,
  }) {
    final _SnackBarColors colors = _resolveColors(
      colorScheme: colorScheme,
      severity: severity,
    );

    return SnackBar(
      content: Row(
        children: [
          // Severity icon — provides quick visual scan without reading text.
          Icon(
            _resolveIcon(severity),
            color: colors.onBackground,
            size: IconSizes.iconSmall, // 16dp — compact, doesn't overpower text
          ),
          const SizedBox(width: Insets.spacing8),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(color: colors.onBackground),
            ),
          ),
        ],
      ),
      backgroundColor: colors.background,
      behavior: SnackBarBehavior.floating,
      elevation: _elevation,
      shape: _snackBarShape(),
      duration: duration,
      width: _snackBarWidth(deviceType),
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.spacing16,
        vertical: Insets.spacing12,
      ),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: colors.action,
              disabledTextColor: colors.onBackground.withValues(
                alpha: WidgetOpacities.disabledContent,
              ),
              onPressed: onAction ?? () {},
            )
          : null,
    );
  }

  // ---------------------------------------------------------------------------
  // Core theme builder
  // ---------------------------------------------------------------------------

  static SnackBarThemeData _buildTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required SnackBarSeverity severity,
    required DeviceType deviceType,
  }) {
    final _SnackBarColors colors = _resolveColors(
      colorScheme: colorScheme,
      severity: severity,
    );

    return SnackBarThemeData(
      backgroundColor: colors.background,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.onBackground,
      ),
      // inversePrimary: M3 spec for action on inverseSurface background.
      // Per-severity action color applied via buildSnackBar().
      actionTextColor: colors.action,
      disabledActionTextColor: colors.onBackground.withValues(
        alpha: WidgetOpacities.disabledContent, // 0.38
      ),
      actionBackgroundColor: colors.background.withValues(
        alpha: WidgetOpacities.transparent,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: _elevation,
      shape: _snackBarShape(),
      width: _snackBarWidth(deviceType),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: Insets.spacing16,
        vertical: Insets.spacing8,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Color resolution per severity
  // ---------------------------------------------------------------------------

  static _SnackBarColors _resolveColors({
    required ColorScheme colorScheme,
    required SnackBarSeverity severity,
  }) {
    return switch (severity) {
      // Info: inverseSurface/onInverseSurface — M3 default snackbar colors.
      // inversePrimary as action — readable on dark inverseSurface.
      SnackBarSeverity.info => _SnackBarColors(
        background: colorScheme.inverseSurface,
        onBackground: colorScheme.onInverseSurface,
        action: colorScheme.inversePrimary,
      ),

      // Success: use tertiary container — green-adjacent tone from palette.
      // Avoids adding an external green color outside the design system.
      SnackBarSeverity.success => _SnackBarColors(
        background: colorScheme.tertiaryContainer,
        onBackground: colorScheme.onTertiaryContainer,
        action: colorScheme.tertiary,
      ),

      // Warning: secondary container — warm mid-tone signals caution.
      SnackBarSeverity.warning => _SnackBarColors(
        background: colorScheme.secondaryContainer,
        onBackground: colorScheme.onSecondaryContainer,
        action: colorScheme.secondary,
      ),

      // Error: errorContainer — M3 semantic role for error surfaces.
      SnackBarSeverity.error => _SnackBarColors(
        background: colorScheme.errorContainer,
        onBackground: colorScheme.onErrorContainer,
        action: colorScheme.error,
      ),
    };
  }

  // ---------------------------------------------------------------------------
  // Icon per severity
  // ---------------------------------------------------------------------------

  static IconData _resolveIcon(SnackBarSeverity severity) {
    return switch (severity) {
      SnackBarSeverity.info => Icons.info_outline_rounded,
      SnackBarSeverity.success => Icons.check_circle_outline_rounded,
      SnackBarSeverity.warning => Icons.warning_amber_rounded,
      SnackBarSeverity.error => Icons.error_outline_rounded,
    };
  }

  // ---------------------------------------------------------------------------
  // Shape & width helpers
  // ---------------------------------------------------------------------------

  /// Snackbar uses small radius (4dp) per M3 spec — not card radius (8dp).
  /// Snackbar is a transient notification, not a content container.
  static RoundedRectangleBorder _snackBarShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radius.radiusSmall), // 4dp
    );
  }

  /// Constrain width on tablet/desktop — full-width snackbar on large screens
  /// looks awkward and draws too much attention.
  /// Returns null on mobile to let Flutter use default full-width behavior.
  static double? _snackBarWidth(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => null,
      DeviceType.tablet => _maxWidthTablet,
      DeviceType.desktop => _maxWidthDesktop,
    };
  }
}

// ---------------------------------------------------------------------------
// Internal data model
// ---------------------------------------------------------------------------

@immutable
class _SnackBarColors {
  const _SnackBarColors({
    required this.background,
    required this.onBackground,
    required this.action,
  });

  final Color background;
  final Color onBackground;
  final Color action;
}
