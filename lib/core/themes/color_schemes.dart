import 'dart:math' as math;

import 'package:flutter/material.dart';

// See: lib/core/themes/color_scheme_hex_checklist.md
class AppColorSchemeConst {
  const AppColorSchemeConst._();

  // Single seed keeps light/dark palettes aligned when switching mode.
  static const Color seedColor = Color(0xFF2E5AAC);
  static const Color highContrastLightForeground = Color(0xFFFFFFFF);
  static const Color highContrastDarkForeground = Color(0xFF000000);
  static const double minimumTextContrastRatio = 4.5;
  static const double minimumUiContrastRatio = 3;
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
  );
  final Color resolvedOnPrimary = _resolveOnPrimary(
    seededColorScheme: seededColorScheme,
    primary: seededColorScheme.primary,
  );
  final ColorScheme colorScheme = seededColorScheme.copyWith(
    onPrimary: resolvedOnPrimary,
  );
  assert(() {
    _validateColorSchemeContrast(colorScheme: colorScheme);
    return true;
  }());
  return colorScheme;
}

Color _resolveOnPrimary({
  required ColorScheme seededColorScheme,
  required Color primary,
}) {
  final Color seededOnPrimary = seededColorScheme.onPrimary;
  final double seededContrastRatio = _calculateContrastRatio(
    foreground: seededOnPrimary,
    background: primary,
  );
  if (seededContrastRatio >= AppColorSchemeConst.minimumTextContrastRatio) {
    return seededOnPrimary;
  }
  return _resolveHighestContrastForeground(background: primary);
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
  if (lightContrastRatio >= darkContrastRatio) {
    return lightForeground;
  }
  return darkForeground;
}

void _validateColorSchemeContrast({required ColorScheme colorScheme}) {
  _ensureMinimumContrast(
    foreground: colorScheme.onPrimary,
    background: colorScheme.primary,
    minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    pairLabel: 'onPrimary/primary',
  );
  _ensureMinimumContrast(
    foreground: colorScheme.onSurface,
    background: colorScheme.surface,
    minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    pairLabel: 'onSurface/surface',
  );
  _ensureMinimumContrast(
    foreground: colorScheme.onSecondaryContainer,
    background: colorScheme.secondaryContainer,
    minimumRatio: AppColorSchemeConst.minimumTextContrastRatio,
    pairLabel: 'onSecondaryContainer/secondaryContainer',
  );
  _ensureMinimumContrast(
    foreground: colorScheme.outline,
    background: colorScheme.surface,
    minimumRatio: AppColorSchemeConst.minimumUiContrastRatio,
    pairLabel: 'outline/surface',
  );
}

void _ensureMinimumContrast({
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
  throw FlutterError(
    'Color pair $pairLabel has contrast ratio '
    '${ratio.toStringAsFixed(2)} which is below $minimumRatio.',
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
  if (seedColor != null) {
    return seedColor;
  }
  return AppColorSchemeConst.seedColor;
}

final ColorScheme lightColorScheme = buildLightColorScheme();
final ColorScheme darkColorScheme = buildDarkColorScheme();
