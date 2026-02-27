import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppColorSchemeConst {
  const AppColorSchemeConst._();

  static const Color paletteDeepNavy = Color(0xFF161E2F);
  static const Color paletteNavy = Color(0xFF242F49);
  static const Color paletteSlate = Color(0xFF384358);
  static const Color palettePeach = Color(0xFFFFA586);
  static const Color paletteCrimson = Color(0xFFB51A2B);
  static const Color paletteWine = Color(0xFF541A2E);
  static const Color paletteNeutralWhite = Color(0xFFFFFFFF);

  static const Color seedColor = paletteNavy;
  static const Color highContrastLightForeground = paletteDeepNavy;
  static const Color highContrastDarkForeground = paletteNeutralWhite;
  static const double minimumTextContrastRatio = 4.5;
  static const double minimumUiContrastRatio = 3.0;
}

class _ContrastPairInput {
  const _ContrastPairInput({
    required this.foreground,
    required this.background,
    required this.minimumRatio,
    required this.pairLabel,
  });

  final Color foreground;
  final Color background;
  final double minimumRatio;
  final String pairLabel;
}

ColorScheme buildLightColorScheme({Color? seedColor}) {
  return _buildColorScheme(seedColor: seedColor, brightness: Brightness.light);
}

ColorScheme buildDarkColorScheme({Color? seedColor}) {
  return _buildColorScheme(seedColor: seedColor, brightness: Brightness.dark);
}

ColorScheme _buildColorScheme({
  required Brightness brightness,
  Color? seedColor,
}) {
  final Color resolvedSeedColor = _resolveSeedColor(seedColor: seedColor);

  final ColorScheme seededColorScheme = ColorScheme.fromSeed(
    seedColor: resolvedSeedColor,
    brightness: brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.neutral,
  );
  final ColorScheme paletteColorScheme = _applyPaletteColorRoles(
    seededColorScheme: seededColorScheme,
    brightness: brightness,
  );
  final resolvedOnRoles = _resolveAccessibleOnRoles(
    colorScheme: paletteColorScheme,
  );
  final Color resolvedOutlineVariant = _resolveOutlineVariant(
    seededColorScheme: paletteColorScheme,
  );

  final ColorScheme colorScheme = paletteColorScheme.copyWith(
    onPrimary: resolvedOnRoles.onPrimary,
    onSecondary: resolvedOnRoles.onSecondary,
    onTertiary: resolvedOnRoles.onTertiary,
    onPrimaryContainer: resolvedOnRoles.onPrimaryContainer,
    onSecondaryContainer: resolvedOnRoles.onSecondaryContainer,
    onTertiaryContainer: resolvedOnRoles.onTertiaryContainer,
    outlineVariant: resolvedOutlineVariant,
  );

  assert(() {
    _validateColorSchemeContrast(colorScheme: colorScheme);
    return true;
  }());

  return colorScheme;
}

ColorScheme _applyPaletteColorRoles({
  required ColorScheme seededColorScheme,
  required Brightness brightness,
}) {
  if (brightness == Brightness.dark) {
    return _applyDarkPaletteColorRoles(seededColorScheme: seededColorScheme);
  }

  return _applyLightPaletteColorRoles(seededColorScheme: seededColorScheme);
}

ColorScheme _applyLightPaletteColorRoles({
  required ColorScheme seededColorScheme,
}) {
  return seededColorScheme.copyWith(
    primary: AppColorSchemeConst.paletteNavy,
    primaryContainer: AppColorSchemeConst.paletteSlate,
    secondary: AppColorSchemeConst.paletteCrimson,
    secondaryContainer: AppColorSchemeConst.paletteWine,
    tertiary: AppColorSchemeConst.palettePeach,
    tertiaryContainer: AppColorSchemeConst.palettePeach,
    surfaceTint: AppColorSchemeConst.paletteNavy,
  );
}

ColorScheme _applyDarkPaletteColorRoles({
  required ColorScheme seededColorScheme,
}) {
  return seededColorScheme.copyWith(
    primary: AppColorSchemeConst.palettePeach,
    primaryContainer: AppColorSchemeConst.paletteNavy,
    secondary: AppColorSchemeConst.paletteCrimson,
    secondaryContainer: AppColorSchemeConst.paletteWine,
    tertiary: AppColorSchemeConst.paletteSlate,
    tertiaryContainer: AppColorSchemeConst.paletteNavy,
    surface: AppColorSchemeConst.paletteDeepNavy,
    surfaceTint: AppColorSchemeConst.palettePeach,
  );
}

({
  Color onPrimary,
  Color onSecondary,
  Color onTertiary,
  Color onPrimaryContainer,
  Color onSecondaryContainer,
  Color onTertiaryContainer,
})
_resolveAccessibleOnRoles({required ColorScheme colorScheme}) {
  return (
    onPrimary: _resolveOnPrimary(
      seededColorScheme: colorScheme,
      primary: colorScheme.primary,
    ),
    onSecondary: _resolveAccessibleForeground(
      foreground: colorScheme.onSecondary,
      background: colorScheme.secondary,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
    onTertiary: _resolveAccessibleForeground(
      foreground: colorScheme.onTertiary,
      background: colorScheme.tertiary,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
    onPrimaryContainer: _resolveAccessibleForeground(
      foreground: colorScheme.onPrimaryContainer,
      background: colorScheme.primaryContainer,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
    onSecondaryContainer: _resolveAccessibleForeground(
      foreground: colorScheme.onSecondaryContainer,
      background: colorScheme.secondaryContainer,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
    onTertiaryContainer: _resolveAccessibleForeground(
      foreground: colorScheme.onTertiaryContainer,
      background: colorScheme.tertiaryContainer,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    ),
  );
}

Color _resolveOutlineVariant({required ColorScheme seededColorScheme}) {
  final Color surface = seededColorScheme.surface;
  final List<Color> candidates = <Color>[
    seededColorScheme.outlineVariant,
    seededColorScheme.outline,
    seededColorScheme.onSurfaceVariant,
  ];

  for (final Color candidate in candidates) {
    final double ratio = _calculateContrastRatio(
      foreground: candidate,
      background: surface,
    );
    if (ratio >= AppColorSchemeConst.minimumUiContrastRatio) {
      return candidate;
    }
  }

  return _resolveHighestContrastForeground(background: surface);
}

Color _resolveOnPrimary({
  required ColorScheme seededColorScheme,
  required Color primary,
}) {
  return _resolveAccessibleForeground(
    foreground: seededColorScheme.onPrimary,
    background: primary,
    minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
  );
}

Color _resolveAccessibleForeground({
  required Color foreground,
  required Color background,
  required double minimumRatio,
}) {
  final double seededContrastRatio = _calculateContrastRatio(
    foreground: foreground,
    background: background,
  );

  if (seededContrastRatio >= minimumRatio) {
    return foreground;
  }

  return _resolveHighestContrastForeground(background: background);
}

Color _resolveHighestContrastForeground({required Color background}) {
  final Color lightForeground = AppColorSchemeConst.highContrastLightForeground;
  final Color darkForeground = AppColorSchemeConst.highContrastDarkForeground;

  final double lightContrastRatio = _calculateContrastRatio(
    foreground: lightForeground,
    background: background,
  );
  final double darkContrastRatio = _calculateContrastRatio(
    foreground: darkForeground,
    background: background,
  );

  return lightContrastRatio >= darkContrastRatio
      ? lightForeground
      : darkForeground;
}

void _validateColorSchemeContrast({required ColorScheme colorScheme}) {
  final List<String> textFailures = _validateTextContrastPairs(
    colorScheme: colorScheme,
  );
  final List<String> uiFailures = _validateUiContrastPairs(
    colorScheme: colorScheme,
  );
  final List<String> failures = <String>[...textFailures, ...uiFailures];
  if (failures.isEmpty) {
    return;
  }
  final String diagnostics = failures
      .map((String item) => '- $item')
      .join('\n');
  throw FlutterError('Color scheme contrast validation failed:\n$diagnostics');
}

List<String> _validateTextContrastPairs({required ColorScheme colorScheme}) {
  final List<String> failures = <String>[];
  final List<_ContrastPairInput> pairs = <_ContrastPairInput>[];
  _appendCoreTextPairs(pairs: pairs, colorScheme: colorScheme);
  _appendContainerTextPairs(pairs: pairs, colorScheme: colorScheme);
  for (final _ContrastPairInput pair in pairs) {
    _collectContrastFailure(
      failures: failures,
      foreground: pair.foreground,
      background: pair.background,
      minimumRatio: pair.minimumRatio,
      pairLabel: pair.pairLabel,
    );
  }
  return failures;
}

void _appendCoreTextPairs({
  required List<_ContrastPairInput> pairs,
  required ColorScheme colorScheme,
}) {
  pairs.add(
    _ContrastPairInput(
      foreground: colorScheme.onPrimary,
      background: colorScheme.primary,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
      pairLabel: 'onPrimary/primary',
    ),
  );
  pairs.add(
    _ContrastPairInput(
      foreground: colorScheme.onSecondary,
      background: colorScheme.secondary,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
      pairLabel: 'onSecondary/secondary',
    ),
  );
  pairs.add(
    _ContrastPairInput(
      foreground: colorScheme.onTertiary,
      background: colorScheme.tertiary,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
      pairLabel: 'onTertiary/tertiary',
    ),
  );
  pairs.add(
    _ContrastPairInput(
      foreground: colorScheme.onSurface,
      background: colorScheme.surface,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
      pairLabel: 'onSurface/surface',
    ),
  );
  pairs.add(
    _ContrastPairInput(
      foreground: colorScheme.onSurface,
      background: colorScheme.surface,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
      pairLabel: 'onSurface/background',
    ),
  );
}

void _appendContainerTextPairs({
  required List<_ContrastPairInput> pairs,
  required ColorScheme colorScheme,
}) {
  pairs.add(
    _ContrastPairInput(
      foreground: colorScheme.onSurfaceVariant,
      background: colorScheme.surfaceContainerHighest,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
      pairLabel: 'onSurfaceVariant/surfaceVariant',
    ),
  );
  pairs.add(
    _ContrastPairInput(
      foreground: colorScheme.onSecondaryContainer,
      background: colorScheme.secondaryContainer,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
      pairLabel: 'onSecondaryContainer/secondaryContainer',
    ),
  );
  pairs.add(
    _ContrastPairInput(
      foreground: colorScheme.onTertiaryContainer,
      background: colorScheme.tertiaryContainer,
      minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
      pairLabel: 'onTertiaryContainer/tertiaryContainer',
    ),
  );
}

List<String> _validateUiContrastPairs({required ColorScheme colorScheme}) {
  final List<String> failures = <String>[];
  _collectContrastFailure(
    failures: failures,
    foreground: colorScheme.outline,
    background: colorScheme.surface,
    minimumRatio: AppColorSchemeConst.minimumUiContrastRatio,
    pairLabel: 'outline/surface',
  );
  _collectContrastFailure(
    failures: failures,
    foreground: colorScheme.outlineVariant,
    background: colorScheme.surface,
    minimumRatio: AppColorSchemeConst.minimumUiContrastRatio,
    pairLabel: 'outlineVariant/surface',
  );
  return failures;
}

void _collectContrastFailure({
  required List<String> failures,
  required Color foreground,
  required Color background,
  required double minimumRatio,
  required String pairLabel,
}) {
  final double ratio = _calculateContrastRatio(
    foreground: foreground,
    background: background,
  );

  if (ratio >= minimumRatio) {
    return;
  }
  failures.add(
    'Color pair $pairLabel has contrast ratio '
    '${ratio.toStringAsFixed(2)} which is below $minimumRatio',
  );
}

double _calculateContrastRatio({
  required Color foreground,
  required Color background,
}) {
  final double foregroundLuminance = foreground.computeLuminance();
  final double backgroundLuminance = background.computeLuminance();
  final double lighter = math.max(foregroundLuminance, backgroundLuminance);
  final double darker = math.min(foregroundLuminance, backgroundLuminance);
  return (lighter + 0.05) / (darker + 0.05);
}

Color _resolveSeedColor({Color? seedColor}) {
  return seedColor ?? AppColorSchemeConst.seedColor;
}

final ColorScheme lightColorScheme = buildLightColorScheme();
final ColorScheme darkColorScheme = buildDarkColorScheme();
