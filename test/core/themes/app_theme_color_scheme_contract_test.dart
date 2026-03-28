// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/theme/app_color_scheme.dart';

void main() {
  group('AppColorScheme contract', () {
    test('light theme exposes all required color tokens', () {
      final ColorScheme colorScheme = AppColorScheme.light();
      final List<Color> colors = _collectRequiredColors(colorScheme);

      expect(colors, hasLength(36));
      for (final Color color in colors) {
        expect(color, isA<Color>());
      }
    });

    test('dark theme exposes all required color tokens', () {
      final ColorScheme colorScheme = AppColorScheme.dark();
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
    colorScheme.background,
    colorScheme.onBackground,
    colorScheme.surface,
    colorScheme.onSurface,
    colorScheme.surfaceVariant,
    colorScheme.onSurfaceVariant,
    colorScheme.outline,
    colorScheme.outlineVariant,
    colorScheme.surfaceDim,
    colorScheme.surfaceBright,
    colorScheme.surfaceContainerLowest,
    colorScheme.surfaceContainerLow,
    colorScheme.surfaceContainer,
    colorScheme.surfaceContainerHigh,
    colorScheme.surfaceContainerHighest,
    colorScheme.inversePrimary,
    colorScheme.inverseSurface,
    colorScheme.onInverseSurface,
    colorScheme.shadow,
    colorScheme.scrim,
  ];
}
