import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/themes/builders/app_adaptive_theme_builder.dart';
import 'package:lumos/core/themes/builders/app_component_theme_builder.dart';
import 'package:lumos/core/themes/component/app_button_tokens.dart';
import 'package:lumos/core/themes/component/app_input_tokens.dart';
import 'package:lumos/core/themes/component/app_navigation_bar_tokens.dart';
import 'package:lumos/core/themes/component/app_card_tokens.dart';
import 'package:lumos/core/themes/component/app_dialog_tokens.dart';
import 'package:lumos/core/themes/component/app_theme_contract_tokens.dart';
import 'package:lumos/core/themes/foundation/app_responsive.dart';
import 'package:lumos/core/themes/semantic/app_color_tokens.dart';
import 'package:lumos/core/themes/semantic/app_text_tokens.dart';

void main() {
  group('AppAdaptiveThemeBuilder', () {
    test('returns original theme at base design width', () {
      final ThemeData baseTheme = _buildBaseTheme();
      final ThemeData adaptedTheme = AppAdaptiveThemeBuilder.adapt(
        theme: baseTheme,
        screenWidth: ResponsiveDimensions.baseDesignWidth,
      );

      expect(identical(adaptedTheme, baseTheme), isTrue);
    });

    test('shrinks typography and component tokens on compact screens', () {
      final ThemeData baseTheme = _buildBaseTheme();
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
      final AppCardTokens baseCardTokens = baseTheme
          .extension<AppCardTokens>()!;
      final AppCardTokens adaptedCardTokens = adaptedTheme
          .extension<AppCardTokens>()!;
      final double baseHeadlineFontSize =
          baseTheme.textTheme.headlineMedium?.fontSize ?? 28;
      final double adaptedHeadlineFontSize =
          adaptedTheme.textTheme.headlineMedium?.fontSize ??
          baseHeadlineFontSize;
      final double baseTitleFontSize =
          baseTheme.textTheme.titleLarge?.fontSize ?? 22;
      final double adaptedTitleFontSize =
          adaptedTheme.textTheme.titleLarge?.fontSize ?? baseTitleFontSize;
      final double baseBodySmallFontSize =
          baseTheme.textTheme.bodySmall?.fontSize ?? 12;
      final double adaptedBodySmallFontSize =
          adaptedTheme.textTheme.bodySmall?.fontSize ?? baseBodySmallFontSize;
      final double adaptedBodyMediumFontSize =
          adaptedTheme.textTheme.bodyMedium?.fontSize ?? 14;

      expect(adaptedHeadlineFontSize, lessThan(baseHeadlineFontSize));
      expect(adaptedTitleFontSize, lessThan(baseTitleFontSize));
      expect(adaptedBodyMediumFontSize, lessThan(14));
      expect(adaptedBodySmallFontSize, baseBodySmallFontSize);
      expect(adaptedButtonTokens.heightMd, lessThan(baseButtonTokens.heightMd));
      expect(adaptedInputTokens.minHeight, lessThan(baseInputTokens.minHeight));
      expect(
        adaptedCardTokens.paddingLg.left,
        lessThan(baseCardTokens.paddingLg.left),
      );
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

ThemeData _buildBaseTheme() {
  final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  final ThemeData seedTheme = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
  );
  final TextTheme textTheme = seedTheme.textTheme.copyWith(
    headlineMedium: _ensureFontSize(seedTheme.textTheme.headlineMedium, 28),
    titleLarge: _ensureFontSize(seedTheme.textTheme.titleLarge, 22),
    titleSmall: _ensureFontSize(seedTheme.textTheme.titleSmall, 14),
    bodyMedium: _ensureFontSize(seedTheme.textTheme.bodyMedium, 14),
    labelMedium: _ensureFontSize(seedTheme.textTheme.labelMedium, 12),
  );
  final ThemeData baseTheme = seedTheme.copyWith(
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    extensions: <ThemeExtension<dynamic>>[
      AppThemeContractTokens.defaults,
      AppColorTokens.fromColorScheme(colorScheme: colorScheme),
      AppTextTokens.fromTheme(colorScheme: colorScheme, textTheme: textTheme),
      AppButtonTokens.defaults,
      AppInputTokens.defaults,
      AppCardTokens.defaults,
      AppDialogTokens.defaults,
      AppNavigationBarTokens.defaults,
    ],
  );
  return AppComponentThemeBuilder.apply(
    baseTheme: baseTheme,
    colorScheme: colorScheme,
    textTheme: textTheme,
  );
}

TextStyle _ensureFontSize(TextStyle? style, double fontSize) {
  return (style ?? const TextStyle()).copyWith(fontSize: fontSize);
}
