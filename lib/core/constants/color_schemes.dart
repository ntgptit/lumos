import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../themes/foundation/app_palette.dart';

// ---------------------------------------------------------------------------
// Palette constants
// All raw brand colors live here. No other file should hardcode hex values.
// ---------------------------------------------------------------------------
@immutable
abstract final class AppColorSchemeConst {
  static const Color brandPrimary = AppPalette.primary40;
  static const Color brandPrimaryContainer = AppPalette.primary90;
  static const Color brandSecondary = AppPalette.secondary40;
  static const Color brandSecondaryContainer = AppPalette.secondary90;
  static const Color brandTertiary = AppPalette.tertiary40;
  static const Color brandTertiaryContainer = AppPalette.tertiary90;
  static const Color darkPrimary = AppPalette.darkPrimary80;
  static const Color darkPrimaryContainer = AppPalette.charcoal40;
  static const Color darkSecondary = AppPalette.darkSecondary70;
  static const Color darkSecondaryContainer = AppPalette.independence40;
  static const Color darkTertiary = AppPalette.cadetBlue40;
  static const Color darkTertiaryContainer = AppPalette.charcoal40;

  static const Color lightSurface = AppPalette.neutral99;
  static const Color lightBackground = AppPalette.neutral95;
  static const Color lightSurfaceContainer = AppPalette.primary90;
  static const Color lightOnPrimary = AppPalette.neutral99;
  static const Color lightOnPrimaryContainer = AppPalette.primary40;
  static const Color lightOnSecondary = AppPalette.neutral99;
  static const Color lightOnSecondaryContainer = AppPalette.primary40;
  static const Color lightOnTertiary = AppPalette.neutral99;
  static const Color lightOnTertiaryContainer = AppPalette.primary40;
  static const Color lightOnSurface = AppPalette.primary40;
  static const Color lightOnSurfaceVariant = AppPalette.primary40;
  static const Color lightOutline = AppPalette.tertiary40;
  static const Color lightOutlineVariant = AppPalette.cadetBlue40;
  static const Color darkSurface = AppPalette.neutral20;
  static const Color darkBackground = AppPalette.eigengrau10;
  static const Color darkSurfaceContainer = AppPalette.gunmetal20;
  static const Color darkSurfaceContainerHigh = AppPalette.gunmetal20;
  static const Color darkOutline = AppPalette.darkSecondary70;
  static const Color darkOutlineVariant = AppPalette.cadetBlue40;
  static const Color darkScrim = AppPalette.gunmetal20;

  static const Color lightError = AppPalette.error40;
  static const Color lightErrorContainer = AppPalette.error90;
  static const Color darkError = AppPalette.error90;
  static const Color darkErrorContainer = AppPalette.error40;

  // Seed & contrast config
  static const Color seedColor = brandPrimary;
  static const DynamicSchemeVariant dynamicSchemeVariant =
      DynamicSchemeVariant.tonalSpot;
  static const Color highContrastLightForeground = Colors.black;
  static const Color highContrastDarkForeground = Colors.white;

  static const double minimumTextContrastRatio = 4.5;
  static const double minimumUiContrastRatio = 3.0;
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------
ColorScheme buildLightColorScheme({Color? seedColor}) =>
    _buildColorScheme(seedColor: seedColor, brightness: Brightness.light);

ColorScheme buildDarkColorScheme({Color? seedColor}) =>
    _buildColorScheme(seedColor: seedColor, brightness: Brightness.dark);

// Eager singletons — safe because ColorScheme is immutable.
final ColorScheme lightColorScheme = buildLightColorScheme();
final ColorScheme darkColorScheme = buildDarkColorScheme();

// ---------------------------------------------------------------------------
// Core builder
// ---------------------------------------------------------------------------
ColorScheme _buildColorScheme({
  required Brightness brightness,
  Color? seedColor,
}) {
  final Color resolvedSeed = seedColor ?? AppColorSchemeConst.seedColor;

  final ColorScheme seeded = ColorScheme.fromSeed(
    seedColor: resolvedSeed,
    brightness: brightness,
    dynamicSchemeVariant: AppColorSchemeConst.dynamicSchemeVariant,
  );

  final ColorScheme withPalette = _applyPaletteRoles(
    base: seeded,
    brightness: brightness,
  );

  final ColorScheme withOnRoles = _applyAccessibleOnRoles(withPalette);

  final Color resolvedOutline = _resolveOutline(withOnRoles);
  final Color resolvedOutlineVariant = _resolveOutlineVariant(withOnRoles);

  final ColorScheme result = withOnRoles.copyWith(
    outline: resolvedOutline,
    outlineVariant: resolvedOutlineVariant,
  );

  assert(() {
    _validateContrast(result);
    return true;
  }());

  return result;
}

// ---------------------------------------------------------------------------
// Palette role assignment
// Light and dark keep the same role taxonomy, only values change.
// ---------------------------------------------------------------------------
ColorScheme _applyPaletteRoles({
  required ColorScheme base,
  required Brightness brightness,
}) {
  return switch (brightness) {
    Brightness.light => _applyLightRoles(base),
    Brightness.dark => _applyDarkRoles(base),
  };
}

ColorScheme _applyLightRoles(ColorScheme base) {
  return base.copyWith(
    primary: AppColorSchemeConst.brandPrimary,
    onPrimary: AppColorSchemeConst.lightOnPrimary,
    primaryContainer: AppColorSchemeConst.brandPrimaryContainer,
    onPrimaryContainer: AppColorSchemeConst.lightOnPrimaryContainer,
    secondary: AppColorSchemeConst.brandSecondary,
    onSecondary: AppColorSchemeConst.lightOnSecondary,
    secondaryContainer: AppColorSchemeConst.brandSecondaryContainer,
    onSecondaryContainer: AppColorSchemeConst.lightOnSecondaryContainer,
    tertiary: AppColorSchemeConst.brandTertiary,
    onTertiary: AppColorSchemeConst.lightOnTertiary,
    tertiaryContainer: AppColorSchemeConst.brandTertiaryContainer,
    onTertiaryContainer: AppColorSchemeConst.lightOnTertiaryContainer,
    surface: AppColorSchemeConst.lightSurface,
    onSurface: AppColorSchemeConst.lightOnSurface,
    onSurfaceVariant: AppColorSchemeConst.lightOnSurfaceVariant,
    surfaceContainerLowest: AppColorSchemeConst.lightBackground,
    surfaceContainerLow: AppColorSchemeConst.lightBackground,
    surfaceContainer: AppColorSchemeConst.lightSurfaceContainer,
    surfaceContainerHigh: AppColorSchemeConst.lightSurfaceContainer,
    surfaceContainerHighest: AppColorSchemeConst.lightSurfaceContainer,
    outline: AppColorSchemeConst.lightOutline,
    outlineVariant: AppColorSchemeConst.lightOutlineVariant,
    error: AppColorSchemeConst.lightError,
    errorContainer: AppColorSchemeConst.lightErrorContainer,
    surfaceTint: AppColorSchemeConst.brandPrimary,
  );
}

ColorScheme _applyDarkRoles(ColorScheme base) {
  return base.copyWith(
    primary: AppColorSchemeConst.darkPrimary,
    primaryContainer: AppColorSchemeConst.darkPrimaryContainer,
    secondary: AppColorSchemeConst.darkSecondary,
    secondaryContainer: AppColorSchemeConst.darkSecondaryContainer,
    tertiary: AppColorSchemeConst.darkTertiary,
    tertiaryContainer: AppColorSchemeConst.darkTertiaryContainer,
    surface: AppColorSchemeConst.darkSurface,
    surfaceContainerLowest: AppColorSchemeConst.darkBackground,
    surfaceContainerLow: AppColorSchemeConst.darkBackground,
    surfaceContainer: AppColorSchemeConst.darkSurfaceContainer,
    surfaceContainerHigh: AppColorSchemeConst.darkSurfaceContainerHigh,
    surfaceContainerHighest: AppColorSchemeConst.darkSurfaceContainerHigh,
    outline: AppColorSchemeConst.darkOutline,
    outlineVariant: AppColorSchemeConst.darkOutlineVariant,
    error: AppColorSchemeConst.darkError,
    errorContainer: AppColorSchemeConst.darkErrorContainer,
    surfaceTint: AppColorSchemeConst.darkPrimary,
    scrim: AppColorSchemeConst.darkScrim,
  );
}

// ---------------------------------------------------------------------------
// Accessible on-role resolution
// For each colored surface, ensure the paired foreground meets WCAG AA (4.5:1).
// ---------------------------------------------------------------------------
ColorScheme _applyAccessibleOnRoles(ColorScheme scheme) {
  return scheme.copyWith(
    onPrimary: _resolveAccessibleForeground(
      foreground: scheme.onPrimary,
      background: scheme.primary,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
    onSecondary: _resolveAccessibleForeground(
      foreground: scheme.onSecondary,
      background: scheme.secondary,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
    onTertiary: _resolveAccessibleForeground(
      foreground: scheme.onTertiary,
      background: scheme.tertiary,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
    onPrimaryContainer: _resolveAccessibleForeground(
      foreground: scheme.onPrimaryContainer,
      background: scheme.primaryContainer,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
    onSecondaryContainer: _resolveAccessibleForeground(
      foreground: scheme.onSecondaryContainer,
      background: scheme.secondaryContainer,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
    onTertiaryContainer: _resolveAccessibleForeground(
      foreground: scheme.onTertiaryContainer,
      background: scheme.tertiaryContainer,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
  );
}

// ---------------------------------------------------------------------------
// outlineVariant resolution
// Tries candidates in descending preference; falls back to highest contrast.
// ---------------------------------------------------------------------------
Color _resolveOutline(ColorScheme scheme) {
  final Color surface = scheme.surface;
  final List<Color> candidates = <Color>[
    scheme.outline,
    scheme.onSurfaceVariant,
    scheme.onSurface,
  ];

  for (final Color candidate in candidates) {
    if (_contrastRatio(candidate, surface) >=
        AppColorSchemeConst.minimumUiContrastRatio) {
      return candidate;
    }
  }

  debugPrint(
    '[AppColorScheme] Warning: No outline candidate met '
    'minimumUiContrastRatio (${AppColorSchemeConst.minimumUiContrastRatio}). '
    'Falling back to highest contrast foreground.',
  );
  return _highestContrastForeground(surface);
}

Color _resolveOutlineVariant(ColorScheme scheme) {
  final Color surface = scheme.surface;
  final List<Color> candidates = <Color>[
    scheme.outlineVariant,
    scheme.outline,
    scheme.onSurfaceVariant,
  ];

  for (final Color candidate in candidates) {
    if (_contrastRatio(candidate, surface) >=
        AppColorSchemeConst.minimumUiContrastRatio) {
      return candidate;
    }
  }

  debugPrint(
    '[AppColorScheme] Warning: No outlineVariant candidate met '
    'minimumUiContrastRatio (${AppColorSchemeConst.minimumUiContrastRatio}). '
    'Falling back to highest contrast foreground.',
  );
  return _highestContrastForeground(surface);
}

// ---------------------------------------------------------------------------
// Contrast utilities
// ---------------------------------------------------------------------------
Color _resolveAccessibleForeground({
  required Color foreground,
  required Color background,
  required double minimumRatio,
}) {
  if (_contrastRatio(foreground, background) >= minimumRatio) {
    return foreground;
  }
  return _highestContrastForeground(background);
}

Color _highestContrastForeground(Color background) {
  final double lightRatio = _contrastRatio(
    AppColorSchemeConst.highContrastLightForeground,
    background,
  );
  final double darkRatio = _contrastRatio(
    AppColorSchemeConst.highContrastDarkForeground,
    background,
  );
  return lightRatio >= darkRatio
      ? AppColorSchemeConst.highContrastLightForeground
      : AppColorSchemeConst.highContrastDarkForeground;
}

double _contrastRatio(Color foreground, Color background) {
  final double lighter = math.max(
    foreground.computeLuminance(),
    background.computeLuminance(),
  );
  final double darker = math.min(
    foreground.computeLuminance(),
    background.computeLuminance(),
  );
  return (lighter + 0.05) / (darker + 0.05);
}

// ---------------------------------------------------------------------------
// Debug-only contrast validation (assert guard ensures zero production cost)
// ---------------------------------------------------------------------------
void _validateContrast(ColorScheme scheme) {
  final List<_ContrastPair> failures = <_ContrastPair>[];

  _textPairs(scheme).where(_failsContrast).forEach(failures.add);
  _uiPairs(scheme).where(_failsUiContrast).forEach(failures.add);

  if (failures.isEmpty) return;

  final String diagnostics = failures
      .map(
        (p) =>
            '- ${p.label}: ${_contrastRatio(p.foreground, p.background).toStringAsFixed(2)} (min ${p.minimumRatio})',
      )
      .join('\n');

  throw FlutterError('Color scheme contrast validation failed:\n$diagnostics');
}

List<_ContrastPair> _textPairs(ColorScheme s) => <_ContrastPair>[
  _ContrastPair(
    s.onPrimary,
    s.primary,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onPrimary/primary',
  ),
  _ContrastPair(
    s.onSecondary,
    s.secondary,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onSecondary/secondary',
  ),
  _ContrastPair(
    s.onTertiary,
    s.tertiary,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onTertiary/tertiary',
  ),
  _ContrastPair(
    s.onSurface,
    s.surface,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onSurface/surface',
  ),
  _ContrastPair(
    s.onSurfaceVariant,
    s.surfaceContainerHighest,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onSurfaceVariant/surfaceContainerHighest',
  ),
  _ContrastPair(
    s.onPrimaryContainer,
    s.primaryContainer,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onPrimaryContainer/primaryContainer',
  ),
  _ContrastPair(
    s.onSecondaryContainer,
    s.secondaryContainer,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onSecondaryContainer/secondaryContainer',
  ),
  _ContrastPair(
    s.onTertiaryContainer,
    s.tertiaryContainer,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onTertiaryContainer/tertiaryContainer',
  ),
];

List<_ContrastPair> _uiPairs(ColorScheme s) => <_ContrastPair>[
  _ContrastPair(
    s.outline,
    s.surface,
    AppColorSchemeConst.minimumUiContrastRatio,
    'outline/surface',
  ),
  _ContrastPair(
    s.outlineVariant,
    s.surface,
    AppColorSchemeConst.minimumUiContrastRatio,
    'outlineVariant/surface',
  ),
];

bool _failsContrast(_ContrastPair p) =>
    _contrastRatio(p.foreground, p.background) < p.minimumRatio;
bool _failsUiContrast(_ContrastPair p) =>
    _contrastRatio(p.foreground, p.background) < p.minimumRatio;

// ---------------------------------------------------------------------------
// Internal data model
// ---------------------------------------------------------------------------
@immutable
class _ContrastPair {
  const _ContrastPair(
    this.foreground,
    this.background,
    this.minimumRatio,
    this.label,
  );

  final Color foreground;
  final Color background;
  final double minimumRatio;
  final String label;
}
