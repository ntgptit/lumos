// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumos/core/themes/constants/color_schemes.dart';
import 'package:lumos/core/themes/extensions/theme_extensions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('AppTheme ColorScheme contract', () {
    test('light theme exposes all required color tokens', () {
      final ColorScheme colorScheme = buildLightColorScheme();
      final List<Color> colors = _collectRequiredColors(colorScheme);

      expect(colors, hasLength(36));
      for (final Color color in colors) {
        expect(color, isA<Color>());
      }
    });

    test('dark theme exposes all required color tokens', () {
      final ColorScheme colorScheme = buildDarkColorScheme();
      final List<Color> colors = _collectRequiredColors(colorScheme);

      expect(colors, hasLength(36));
      for (final Color color in colors) {
        expect(color, isA<Color>());
      }
    });
  });
}

List<Color> _collectRequiredColors(ColorScheme colorScheme) {
  return <Color>[
    // I. Core Brand Colors
    colorScheme.primary,
    colorScheme.onPrimary,
    colorScheme.primaryContainer,
    colorScheme.onPrimaryContainer,
    colorScheme.secondary,
    colorScheme.onSecondary,
    colorScheme.secondaryContainer,
    colorScheme.onSecondaryContainer,
    colorScheme.tertiary,
    colorScheme.onTertiary,
    colorScheme.tertiaryContainer,
    colorScheme.onTertiaryContainer,
    colorScheme.error,
    colorScheme.onError,
    colorScheme.errorContainer,
    colorScheme.onErrorContainer,

    // II. Neutral & System Colors
    colorScheme.background,
    colorScheme.onBackground,
    colorScheme.surface,
    colorScheme.onSurface,
    colorScheme.surfaceVariant,
    colorScheme.onSurfaceVariant,
    colorScheme.outline,
    colorScheme.outlineVariant,

    // III. Elevation Colors
    colorScheme.surfaceDim,
    colorScheme.surfaceBright,
    colorScheme.surfaceContainerLowest,
    colorScheme.surfaceContainerLow,
    colorScheme.surfaceContainer,
    colorScheme.surfaceContainerHigh,
    colorScheme.surfaceContainerHighest,

    // IV. Inverse Colors
    colorScheme.inversePrimary,
    colorScheme.inverseSurface,
    colorScheme.inverseOnSurface,

    // V. Scrim / Shadow
    colorScheme.shadow,
    colorScheme.scrim,
  ];
}
