import 'dart:math' as math;
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Palette constants
// All raw brand colors live here. No other file should hardcode hex values.
// ---------------------------------------------------------------------------
@immutable
abstract final class AppColorSchemeConst {
  // Brand palette (from provided design reference)
  // Midnight Blue, Dusty Blue, Ivory, Deep Navy, Buttercream.
  static const Color paletteCadetBlue = Color(0xFF52677D); // Dusty Blue
  static const Color paletteIndependence = Color(0xFF1C2E4A); // Midnight Blue
  static const Color paletteCharcoal = Color(0xFF52677D); // Dusty Blue
  static const Color paletteGunmetal = Color(0xFF0F1A2B); // Deep Navy
  static const Color paletteEigengrau = Color(0xFF0F1A2B); // Deep Navy
  static const Color paletteAbsoluteBlack = Color(0xFF000000);
  static const Color paletteNeutralWhite = Color(0xFFFFFFFF);

  // Derived surface tones (light mode)
  static const Color paletteSecondaryContainerLight = Color(0xFFBDC4D4); // Ivory
  static const Color paletteTertiaryContainerLight = Color(0xFFD1CFC9); // Buttercream

  // Derived surface tones (dark mode)
  static const Color paletteTertiaryDark = Color(
    0xFFBDC4D4,
  ); // Ivory accent for dark
  static const Color paletteTertiaryContainerDark = Color(
    0xFF1C2E4A,
  ); // Midnight Blue container for dark

  // Seed & contrast config
  static const Color seedColor = paletteIndependence;
  static const Color highContrastLightForeground = paletteAbsoluteBlack;
  static const Color highContrastDarkForeground = paletteNeutralWhite;

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
    dynamicSchemeVariant: DynamicSchemeVariant.neutral,
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
// Roles are chosen for Social / Lifestyle + Modern & Minimal:
//   primary   → brand CTA, FAB, active nav
//   secondary → secondary actions, icons
//   tertiary  → accent badges, tags, subtle highlights
//   surface   → card and scaffold backgrounds
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
    // Primary: Midnight Blue — core CTA and active controls
    primary: AppColorSchemeConst.paletteIndependence,
    // primaryContainer: Dusty Blue — selected chip and softer emphasis
    primaryContainer: AppColorSchemeConst.paletteCadetBlue,

    // Secondary: Dusty Blue — secondary actions and icon tint
    secondary: AppColorSchemeConst.paletteCharcoal,
    // secondaryContainer: Ivory for neutral filled surfaces
    secondaryContainer: AppColorSchemeConst.paletteSecondaryContainerLight,

    // Tertiary: Deep Navy — accent badges, quiet highlights
    tertiary: AppColorSchemeConst.paletteGunmetal,
    // tertiaryContainer: Buttercream for subtle containers
    tertiaryContainer: AppColorSchemeConst.paletteTertiaryContainerLight,

    // Surface: Buttercream base for light mode
    surface: AppColorSchemeConst.paletteTertiaryContainerLight,
    surfaceTint: AppColorSchemeConst.paletteIndependence,
  );
}

ColorScheme _applyDarkRoles(ColorScheme base) {
  return base.copyWith(
    // Primary: Dusty Blue — readable and distinct on dark surfaces
    primary: AppColorSchemeConst.paletteCadetBlue,
    // primaryContainer: Midnight Blue — contained controls
    primaryContainer: AppColorSchemeConst.paletteIndependence,

    // Secondary: Dusty Blue with low-chroma dark depth
    secondary: AppColorSchemeConst.paletteCharcoal,
    // secondaryContainer: Deep Navy for layered cards/sheets
    secondaryContainer: AppColorSchemeConst.paletteGunmetal,

    // Tertiary: Ivory accent for dark context
    tertiary: AppColorSchemeConst.paletteTertiaryDark,
    // tertiaryContainer: Midnight Blue accent container
    tertiaryContainer: AppColorSchemeConst.paletteTertiaryContainerDark,

    // Surface: Deep Navy for stable dark foundation
    surface: AppColorSchemeConst.paletteEigengrau,

    surfaceTint: AppColorSchemeConst.paletteCadetBlue,
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
