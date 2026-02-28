import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

/// FAB color variants aligned with M3 color roles.
///
/// - [primary]   : Main CTA — uses primaryContainer. Most prominent.
/// - [secondary] : Secondary action — uses secondaryContainer.
/// - [tertiary]  : Tertiary/accent action — uses tertiaryContainer.
/// - [surface]   : Neutral — uses surfaceContainer. Least prominent.
enum FabColorVariant { primary, secondary, tertiary, surface }

/// Centralised FAB theming for Social/Lifestyle app.
///
/// Covers all M3 FAB sizes:
///   - Regular FAB  : 56dp — primary action (ThemeData.floatingActionButtonTheme)
///   - Extended FAB : 56dp tall, variable width — icon + label
///   - Small FAB    : 40dp — secondary/contextual action
///
/// Supports:
///   - [FabColorVariant] — primary / secondary / tertiary / surface
///   - Brightness        — elevation and shadow adjusted per brightness
///   - DeviceType        — size scaling for tablet/desktop
///
/// Usage — global theme (primary tonal FAB as default):
/// ```dart
/// floatingActionButtonTheme: FloatingActionButtonThemes.build(
///   colorScheme: colorScheme,
///   textTheme: textTheme,
/// ),
/// ```
///
/// Usage — variant override at widget level:
/// ```dart
/// FloatingActionButton(
///   style: FloatingActionButtonThemes.styleOf(
///     colorScheme: colorScheme,
///     variant: FabColorVariant.tertiary,
///   ),
///   ...
/// )
/// ```
abstract final class FloatingActionButtonThemes {
  // ---------------------------------------------------------------------------
  // Elevation constants — M3 FAB elevation tokens
  // Regular: 3dp resting, 6dp hovered, 3dp focused, 6dp pressed.
  // Dark mode: suppress shadow — tonal surface provides separation instead.
  // ---------------------------------------------------------------------------
  static const double _elevationResting = 3.0;
  static const double _elevationHover = 6.0;
  static const double _elevationFocus = 3.0;
  static const double _elevationPressed = 6.0;
  static const double _elevationDisabled = 0.0;

  // FAB sizes
  static const double _sizeFabRegular = 56.0;
  static const double _sizeFabSmall = 40.0;

  // ---------------------------------------------------------------------------
  // Global theme builder
  // ---------------------------------------------------------------------------

  /// Default FAB theme — primary tonal color, regular size.
  /// Wired into ThemeData.floatingActionButtonTheme.
  static FloatingActionButtonThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    FabColorVariant variant = FabColorVariant.primary,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final _FabColors colors = _resolveColors(
      colorScheme: colorScheme,
      variant: variant,
    );

    return FloatingActionButtonThemeData(
      backgroundColor: colors.container,
      foregroundColor: colors.onContainer,

      // Shadow suppressed on dark — tonal elevation handles separation.
      elevation: isDark ? WidgetSizes.none : _elevationResting,
      focusElevation: isDark ? WidgetSizes.none : _elevationFocus,
      hoverElevation: isDark ? WidgetSizes.none : _elevationHover,
      highlightElevation: isDark ? WidgetSizes.none : _elevationPressed,
      disabledElevation: _elevationDisabled,

      // Regular FAB: radiusXLarge (16dp) per M3 spec — NOT button radius (8dp).
      shape: AppShape.button(side: BorderSide.none),

      // Extended FAB text style.
      extendedTextStyle: textTheme.labelLarge?.copyWith(
        color: colors.onContainer,
        letterSpacing: 0.1,
      ),

      // Extended FAB padding: icon-to-label gap.
      extendedIconLabelSpacing: Insets.spacing8,
      extendedPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: Insets.spacing16,
      ),

      // Icon size inside regular FAB.
      iconSize: IconSizes.iconMedium, // 24dp
      // Ensure minimum touch target.
      sizeConstraints: const BoxConstraints.tightFor(
        width: _sizeFabRegular,
        height: _sizeFabRegular,
      ),

      smallSizeConstraints: const BoxConstraints.tightFor(
        width: _sizeFabSmall,
        height: _sizeFabSmall,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Per-widget style — use for variant overrides on individual FABs
  // ---------------------------------------------------------------------------

  /// Returns a [ButtonStyle] for applying a specific [FabColorVariant] to a
  /// single [FloatingActionButton] via its [style] property.
  ///
  /// Example:
  /// ```dart
  /// FloatingActionButton(
  ///   style: FloatingActionButtonThemes.styleOf(
  ///     colorScheme: colorScheme,
  ///     variant: FabColorVariant.secondary,
  ///   ),
  ///   onPressed: () {},
  ///   child: Icon(Icons.add),
  /// )
  /// ```
  static ButtonStyle styleOf({
    required ColorScheme colorScheme,
    FabColorVariant variant = FabColorVariant.primary,
  }) {
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final _FabColors colors = _resolveColors(
      colorScheme: colorScheme,
      variant: variant,
    );

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(
            alpha: WidgetOpacities.divider, // 0.12
          );
        }
        return colors.container;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(
            alpha: WidgetOpacities.disabledContent, // 0.38
          );
        }
        return colors.onContainer;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (isDark) return WidgetSizes.none;
        if (states.contains(WidgetState.disabled)) return _elevationDisabled;
        if (states.contains(WidgetState.pressed)) return _elevationPressed;
        if (states.contains(WidgetState.hovered)) return _elevationHover;
        if (states.contains(WidgetState.focused)) return _elevationFocus;
        return _elevationResting;
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Color resolution
  // ---------------------------------------------------------------------------

  static _FabColors _resolveColors({
    required ColorScheme colorScheme,
    required FabColorVariant variant,
  }) {
    return switch (variant) {
      FabColorVariant.primary => _FabColors(
        container: colorScheme.primaryContainer,
        onContainer: colorScheme.onPrimaryContainer,
      ),
      FabColorVariant.secondary => _FabColors(
        container: colorScheme.secondaryContainer,
        onContainer: colorScheme.onSecondaryContainer,
      ),
      FabColorVariant.tertiary => _FabColors(
        container: colorScheme.tertiaryContainer,
        onContainer: colorScheme.onTertiaryContainer,
      ),
      FabColorVariant.surface => _FabColors(
        container: colorScheme.surfaceContainer,
        onContainer: colorScheme.onSurface,
      ),
    };
  }
}

// ---------------------------------------------------------------------------
// Internal data model
// ---------------------------------------------------------------------------

@immutable
class _FabColors {
  const _FabColors({required this.container, required this.onContainer});

  final Color container;
  final Color onContainer;
}
