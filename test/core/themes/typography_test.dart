import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumos/core/themes/typography.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  const String testFontFamily = 'TestFont';

  group('AppTypography', () {
    test('buildTextTheme creates full Material 3 text style set', () {
      final ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
      );
      final TextTheme textTheme = AppTypography.buildTextTheme(
        colorScheme: colorScheme,
        fontFamily: testFontFamily,
      );

      expect(textTheme.displayLarge, isNotNull);
      expect(textTheme.displayMedium, isNotNull);
      expect(textTheme.displaySmall, isNotNull);
      expect(textTheme.headlineLarge, isNotNull);
      expect(textTheme.headlineMedium, isNotNull);
      expect(textTheme.headlineSmall, isNotNull);
      expect(textTheme.titleLarge, isNotNull);
      expect(textTheme.titleMedium, isNotNull);
      expect(textTheme.titleSmall, isNotNull);
      expect(textTheme.bodyLarge, isNotNull);
      expect(textTheme.bodyMedium, isNotNull);
      expect(textTheme.bodySmall, isNotNull);
      expect(textTheme.labelLarge, isNotNull);
      expect(textTheme.labelMedium, isNotNull);
      expect(textTheme.labelSmall, isNotNull);
    });

    test('buildTextTheme applies onSurface color and typography metrics', () {
      final ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.orange,
      );
      final TextTheme textTheme = AppTypography.buildTextTheme(
        colorScheme: colorScheme,
        fontFamily: testFontFamily,
      );

      expect(
        textTheme.displayLarge?.fontSize,
        AppTypographyConst.displayLargeFontSize,
      );
      expect(
        textTheme.bodyMedium?.fontSize,
        AppTypographyConst.bodyMediumFontSize,
      );
      expect(textTheme.displayLarge?.color, colorScheme.onSurface);
      expect(textTheme.bodySmall?.fontSize, greaterThanOrEqualTo(12));
      expect(
        textTheme.bodyLarge?.fontFamilyFallback,
        AppTypographyConst.kFallbackFonts,
      );
    });

    test('buildPrimaryTextTheme applies onPrimary color', () {
      final ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.green,
      );
      final TextTheme textTheme = AppTypography.buildPrimaryTextTheme(
        colorScheme: colorScheme,
        fontFamily: testFontFamily,
      );

      expect(textTheme.titleLarge?.color, colorScheme.onPrimary);
      expect(textTheme.bodyMedium?.color, colorScheme.onPrimary);
    });

    test('throws when font family is empty', () {
      final ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.purple,
      );
      expect(
        () => AppTypography.buildTextTheme(
          colorScheme: colorScheme,
          fontFamily: '',
        ),
        throwsArgumentError,
      );
    });
  });
}
