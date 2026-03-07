import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'foundation/app_palette.dart';

// ---------------------------------------------------------------------------
// Palette constants — Tokyo Dashboard mapped into Material 3 roles.
// All raw colors live in AppPalette. This file only assigns semantic roles.
// ---------------------------------------------------------------------------
@immutable
abstract final class AppColorSchemeConst {
  // ── Light brand roles ────────────────────────────────────────────────────
  static const Color brandPrimary = AppPalette.primary40;
  static const Color brandPrimaryContainer = AppPalette.primary90;
  static const Color brandSecondary = AppPalette.secondary40;
  static const Color brandSecondaryContainer = AppPalette.secondary90;
  static const Color brandTertiary = AppPalette.tertiary40;
  static const Color brandTertiaryContainer = AppPalette.tertiary90;

  // ── Dark brand roles ─────────────────────────────────────────────────────
  static const Color darkPrimary = AppPalette.violet40;
  static const Color darkOnPrimary = AppPalette.violet10;
  static const Color darkPrimaryContainer = AppPalette.violet20;
  static const Color darkOnPrimaryContainer = AppPalette.violet90;
  static const Color darkSecondary = AppPalette.midnight80;
  static const Color darkOnSecondary = AppPalette.midnight20;
  static const Color darkSecondaryContainer = AppPalette.midnight50;
  static const Color darkOnSecondaryContainer = AppPalette.midnight95;
  static const Color darkTertiary = AppPalette.tertiary80;
  static const Color darkOnTertiary = AppPalette.tertiary20;
  static const Color darkTertiaryContainer = AppPalette.tertiary30;
  static const Color darkOnTertiaryContainer = AppPalette.tertiary90;

  // ── Light surface roles ──────────────────────────────────────────────────
  static const Color lightSurface = AppPalette.neutral95;
  static const Color lightSurfaceContainerLowest = AppPalette.neutral99;
  static const Color lightSurfaceContainerLow = AppPalette.neutral99;
  static const Color lightSurfaceContainer = AppPalette.neutral98;
  static const Color lightSurfaceContainerHigh = AppPalette.neutral95;
  static const Color lightSurfaceContainerHighest = AppPalette.neutral90;
  static const Color lightOnPrimary = AppPalette.neutral0;
  static const Color lightOnPrimaryContainer = AppPalette.primary10;
  static const Color lightOnSecondary = AppPalette.neutral0;
  static const Color lightOnSecondaryContainer = AppPalette.secondary10;
  static const Color lightOnTertiary = AppPalette.neutral99;
  static const Color lightOnTertiaryContainer = AppPalette.tertiary10;
  static const Color lightOnSurface = AppPalette.neutral20;
  static const Color lightOnSurfaceVariant = AppPalette.neutral40;
  static const Color lightOutline = AppPalette.neutral40;
  static const Color lightOutlineVariant = AppPalette.neutral70;
  static const Color lightInverseSurface = AppPalette.neutral20;
  static const Color lightOnInverseSurface = AppPalette.neutral99;
  static const Color lightInversePrimary = AppPalette.primary80;
  static const Color lightScrim = AppPalette.neutral20;
  static const Color lightShadow = AppPalette.neutral20;

  // ── Dark surface roles ───────────────────────────────────────────────────
  static const Color darkSurface = AppPalette.midnight10;
  static const Color darkSurfaceContainerLowest = AppPalette.midnight20;
  static const Color darkSurfaceContainerLow = AppPalette.midnight30;
  static const Color darkSurfaceContainer = AppPalette.midnight40;
  static const Color darkSurfaceContainerHigh = AppPalette.midnight50;
  static const Color darkSurfaceContainerHighest = AppPalette.midnight60;
  static const Color darkOnSurface = AppPalette.midnight95;
  static const Color darkOnSurfaceVariant = AppPalette.midnight90;
  static const Color darkOutline = AppPalette.midnight80;
  static const Color darkOutlineVariant = AppPalette.midnight70;
  static const Color darkInverseSurface = AppPalette.neutral99;
  static const Color darkOnInverseSurface = AppPalette.midnight20;
  static const Color darkInversePrimary = AppPalette.primary40;
  static const Color darkScrim = AppPalette.midnight10;
  static const Color darkShadow = AppPalette.midnight10;

  // ── Error roles ──────────────────────────────────────────────────────────
  static const Color lightError = AppPalette.error40;
  static const Color lightOnError = AppPalette.neutral0;
  static const Color lightErrorContainer = AppPalette.error90;
  static const Color lightOnErrorContainer = AppPalette.error10;
  static const Color darkError = AppPalette.error80;
  static const Color darkOnError = AppPalette.error20;
  static const Color darkErrorContainer = AppPalette.error30;
  static const Color darkOnErrorContainer = AppPalette.error90;

  // ── Seed & scheme config ─────────────────────────────────────────────────
  static const Color lightSeedColor = brandPrimary;
  static const Color darkSeedColor = darkPrimary;
  static const DynamicSchemeVariant dynamicSchemeVariant =
      DynamicSchemeVariant.fidelity;
  static const Color highContrastLightForeground = AppPalette.neutral0;
  static const Color highContrastDarkForeground = AppPalette.neutral99;

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

// ---------------------------------------------------------------------------
// Core builder
// ---------------------------------------------------------------------------
ColorScheme _buildColorScheme({
  required Brightness brightness,
  Color? seedColor,
}) {
  final Color resolvedSeed = _resolveSeedColor(
    brightness: brightness,
    seedColor: seedColor,
  );

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
  final ColorScheme withOutlineRoles = _applyAccessibleOutlineRoles(
    withOnRoles,
  );

  assert(() {
    _validateContrast(withOutlineRoles);
    return true;
  }());

  return withOutlineRoles;
}

Color _resolveSeedColor({required Brightness brightness, Color? seedColor}) {
  if (seedColor != null) {
    return seedColor;
  }

  return switch (brightness) {
    Brightness.light => AppColorSchemeConst.lightSeedColor,
    Brightness.dark => AppColorSchemeConst.darkSeedColor,
  };
}

// ---------------------------------------------------------------------------
// Palette role assignment
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
    surfaceContainerLowest: AppColorSchemeConst.lightSurfaceContainerLowest,
    surfaceContainerLow: AppColorSchemeConst.lightSurfaceContainerLow,
    surfaceContainer: AppColorSchemeConst.lightSurfaceContainer,
    surfaceContainerHigh: AppColorSchemeConst.lightSurfaceContainerHigh,
    surfaceContainerHighest: AppColorSchemeConst.lightSurfaceContainerHighest,
    outline: AppColorSchemeConst.lightOutline,
    outlineVariant: AppColorSchemeConst.lightOutlineVariant,
    error: AppColorSchemeConst.lightError,
    onError: AppColorSchemeConst.lightOnError,
    errorContainer: AppColorSchemeConst.lightErrorContainer,
    onErrorContainer: AppColorSchemeConst.lightOnErrorContainer,
    inverseSurface: AppColorSchemeConst.lightInverseSurface,
    onInverseSurface: AppColorSchemeConst.lightOnInverseSurface,
    inversePrimary: AppColorSchemeConst.lightInversePrimary,
    surfaceTint: AppColorSchemeConst.brandPrimary,
    scrim: AppColorSchemeConst.lightScrim,
    shadow: AppColorSchemeConst.lightShadow,
  );
}

ColorScheme _applyDarkRoles(ColorScheme base) {
  return base.copyWith(
    primary: AppColorSchemeConst.darkPrimary,
    onPrimary: AppColorSchemeConst.darkOnPrimary,
    primaryContainer: AppColorSchemeConst.darkPrimaryContainer,
    onPrimaryContainer: AppColorSchemeConst.darkOnPrimaryContainer,
    secondary: AppColorSchemeConst.darkSecondary,
    onSecondary: AppColorSchemeConst.darkOnSecondary,
    secondaryContainer: AppColorSchemeConst.darkSecondaryContainer,
    onSecondaryContainer: AppColorSchemeConst.darkOnSecondaryContainer,
    tertiary: AppColorSchemeConst.darkTertiary,
    onTertiary: AppColorSchemeConst.darkOnTertiary,
    tertiaryContainer: AppColorSchemeConst.darkTertiaryContainer,
    onTertiaryContainer: AppColorSchemeConst.darkOnTertiaryContainer,
    surface: AppColorSchemeConst.darkSurface,
    onSurface: AppColorSchemeConst.darkOnSurface,
    onSurfaceVariant: AppColorSchemeConst.darkOnSurfaceVariant,
    surfaceContainerLowest: AppColorSchemeConst.darkSurfaceContainerLowest,
    surfaceContainerLow: AppColorSchemeConst.darkSurfaceContainerLow,
    surfaceContainer: AppColorSchemeConst.darkSurfaceContainer,
    surfaceContainerHigh: AppColorSchemeConst.darkSurfaceContainerHigh,
    surfaceContainerHighest: AppColorSchemeConst.darkSurfaceContainerHighest,
    outline: AppColorSchemeConst.darkOutline,
    outlineVariant: AppColorSchemeConst.darkOutlineVariant,
    error: AppColorSchemeConst.darkError,
    onError: AppColorSchemeConst.darkOnError,
    errorContainer: AppColorSchemeConst.darkErrorContainer,
    onErrorContainer: AppColorSchemeConst.darkOnErrorContainer,
    inverseSurface: AppColorSchemeConst.darkInverseSurface,
    onInverseSurface: AppColorSchemeConst.darkOnInverseSurface,
    inversePrimary: AppColorSchemeConst.darkInversePrimary,
    surfaceTint: AppColorSchemeConst.darkPrimary,
    scrim: AppColorSchemeConst.darkScrim,
    shadow: AppColorSchemeConst.darkShadow,
  );
}

// ---------------------------------------------------------------------------
// Accessible on-role resolution — ensures WCAG AA (4.5:1) on all surfaces
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
// Outline resolution — enforces minimum UI contrast for outline roles
// ---------------------------------------------------------------------------
ColorScheme _applyAccessibleOutlineRoles(ColorScheme scheme) {
  return scheme.copyWith(
    outline: _resolveOutline(
      scheme: scheme,
      minimumRatio: AppColorSchemeConst.minimumUiContrastRatio,
    ),
    outlineVariant: _resolveOutlineVariant(
      scheme: scheme,
      minimumRatio: AppColorSchemeConst.minimumUiContrastRatio,
    ),
  );
}

Color _resolveOutline({
  required ColorScheme scheme,
  required double minimumRatio,
}) {
  final Color surface = scheme.surface;
  final List<Color> candidates = <Color>[
    scheme.outline,
    scheme.onSurfaceVariant,
    scheme.onSurface,
  ];

  return _resolveContrastCandidate(
    candidates: candidates,
    background: surface,
    minimumRatio: minimumRatio,
    roleLabel: 'outline',
  );
}

Color _resolveOutlineVariant({
  required ColorScheme scheme,
  required double minimumRatio,
}) {
  final Color surface = scheme.surface;
  final List<Color> candidates = <Color>[
    scheme.outlineVariant,
    scheme.outline,
    scheme.onSurfaceVariant,
  ];

  return _resolveContrastCandidate(
    candidates: candidates,
    background: surface,
    minimumRatio: minimumRatio,
    roleLabel: 'outlineVariant',
  );
}

Color _resolveContrastCandidate({
  required List<Color> candidates,
  required Color background,
  required double minimumRatio,
  required String roleLabel,
}) {
  for (final Color candidate in candidates) {
    if (_contrastRatio(candidate, background) >= minimumRatio) {
      return candidate;
    }
  }

  final Color fallback = _highestContrastForeground(background);
  final double fallbackRatio = _contrastRatio(fallback, background);

  assert(() {
    if (fallbackRatio >= minimumRatio) {
      return true;
    }

    throw FlutterError(
      'Color scheme contrast fallback failed for $roleLabel: '
      '${fallbackRatio.toStringAsFixed(2)} < $minimumRatio',
    );
  }());

  debugPrint(
    '[AppColorScheme] Warning: No $roleLabel candidate met '
    'minimumUiContrastRatio ($minimumRatio). '
    'Using highest contrast foreground.',
  );
  return fallback;
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
// Debug-only contrast validation (assert guard — zero production cost)
// ---------------------------------------------------------------------------
void _validateContrast(ColorScheme scheme) {
  final List<_ContrastPair> failures = <_ContrastPair>[];

  _textPairs(scheme).where(_failsContrast).forEach(failures.add);
  _uiPairs(scheme).where(_failsUiContrast).forEach(failures.add);

  if (failures.isEmpty) {
    return;
  }

  final String diagnostics = failures
      .map(
        (p) =>
            '- ${p.label}: '
            '${_contrastRatio(p.foreground, p.background).toStringAsFixed(2)} '
            '(min ${p.minimumRatio})',
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
    s.surfaceContainerHigh,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onSurfaceVariant/surfaceContainerHigh',
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
  _ContrastPair(
    s.onError,
    s.error,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onError/error',
  ),
  _ContrastPair(
    s.onErrorContainer,
    s.errorContainer,
    AppColorSchemeConst.minimumTextContrastRatio,
    'onErrorContainer/errorContainer',
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
