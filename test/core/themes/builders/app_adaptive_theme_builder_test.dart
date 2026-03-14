import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumos/core/themes/app_theme.dart';
import 'package:lumos/core/themes/builders/app_adaptive_theme_builder.dart';
import 'package:lumos/core/themes/component/app_button_tokens.dart';
import 'package:lumos/core/themes/component/app_input_tokens.dart';
import 'package:lumos/core/themes/component/app_navigation_bar_tokens.dart';
import 'package:lumos/core/themes/foundation/app_responsive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('AppAdaptiveThemeBuilder', () {
    test('returns original theme at base design width', () {
      final ThemeData baseTheme = AppTheme.lightTheme();
      final ThemeData adaptedTheme = AppAdaptiveThemeBuilder.adapt(
        theme: baseTheme,
        screenWidth: ResponsiveDimensions.baseDesignWidth,
      );

      expect(identical(adaptedTheme, baseTheme), isTrue);
    });

    test('shrinks typography and component tokens on compact screens', () {
      final ThemeData baseTheme = AppTheme.lightTheme();
      final ThemeData adaptedTheme = AppAdaptiveThemeBuilder.adapt(
        theme: baseTheme,
        screenWidth: 360,
      );
      final AppButtonTokens baseButtonTokens = baseTheme
          .extension<AppButtonTokens>()!;
      final AppButtonTokens adaptedButtonTokens = adaptedTheme
          .extension<AppButtonTokens>()!;
      final AppInputTokens baseInputTokens = baseTheme
          .extension<AppInputTokens>()!;
      final AppInputTokens adaptedInputTokens = adaptedTheme
          .extension<AppInputTokens>()!;
      final AppNavigationBarTokens baseNavigationBarTokens = baseTheme
          .extension<AppNavigationBarTokens>()!;
      final AppNavigationBarTokens adaptedNavigationBarTokens = adaptedTheme
          .extension<AppNavigationBarTokens>()!;

      expect(
        adaptedTheme.textTheme.headlineMedium!.fontSize,
        lessThan(baseTheme.textTheme.headlineMedium!.fontSize!),
      );
      expect(adaptedButtonTokens.heightMd, lessThan(baseButtonTokens.heightMd));
      expect(adaptedInputTokens.minHeight, lessThan(baseInputTokens.minHeight));
      expect(
        adaptedNavigationBarTokens.height,
        lessThan(baseNavigationBarTokens.height),
      );
      expect(
        adaptedTheme.visualDensity.vertical,
        lessThan(baseTheme.visualDensity.vertical),
      );
    });
  });
}
