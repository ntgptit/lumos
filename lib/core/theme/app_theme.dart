import 'package:flutter/material.dart';

export 'app_color_scheme.dart';
export 'app_text_theme.dart';
export 'app_theme_mode.dart';
export 'component_themes/app_bar_theme.dart';
export 'component_themes/bottom_sheet_theme.dart';
export 'component_themes/button_theme.dart';
export 'component_themes/card_theme.dart';
export 'component_themes/checkbox_theme.dart';
export 'component_themes/chip_theme.dart';
export 'component_themes/dialog_theme.dart';
export 'component_themes/divider_theme.dart';
export 'component_themes/input_theme.dart';
export 'component_themes/progress_indicator_theme.dart';
export 'component_themes/radio_theme.dart';
export 'component_themes/slider_theme.dart';
export 'component_themes/switch_theme.dart';
export 'extensions/color_scheme_ext.dart';
export 'extensions/component_theme_ext.dart';
export 'extensions/dimension_theme_ext.dart';
export 'extensions/screen_context_ext.dart';
export 'extensions/text_theme_ext.dart';
export 'extensions/theme_context_ext.dart';
export 'responsive/adaptive_component_size.dart';
export 'responsive/adaptive_icon_size.dart';
export 'responsive/adaptive_layout.dart';
export 'responsive/adaptive_radius.dart';
export 'responsive/adaptive_spacing.dart';
export 'responsive/adaptive_typography.dart';
export 'responsive/breakpoints.dart';
export 'responsive/responsive_scale.dart';
export 'responsive/responsive_theme_factory.dart';
export 'responsive/screen_class.dart';
export 'responsive/screen_info.dart';
export 'tokens/border_tokens.dart';
export 'tokens/color_tokens.dart';
export 'tokens/elevation_tokens.dart';
export 'tokens/icon_tokens.dart';
export 'tokens/motion_tokens.dart';
export 'tokens/opacity_tokens.dart';
export 'tokens/radius_tokens.dart';
export 'tokens/shadow_tokens.dart';
export 'tokens/size_tokens.dart';
export 'tokens/spacing_tokens.dart';
export 'tokens/typography_tokens.dart';

import '../themes/builders/app_component_theme_builder.dart';
import '../themes/builders/app_theme_extensions_builder.dart';
import '../themes/foundation/app_layout_tokens.dart';
import 'app_color_scheme.dart';
import 'app_text_theme.dart';
import 'component_themes/app_bar_theme.dart';
import 'component_themes/bottom_sheet_theme.dart';
import 'component_themes/button_theme.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/checkbox_theme.dart';
import 'component_themes/chip_theme.dart';
import 'component_themes/dialog_theme.dart';
import 'component_themes/divider_theme.dart';
import 'component_themes/input_theme.dart';
import 'component_themes/progress_indicator_theme.dart';
import 'component_themes/radio_theme.dart';
import 'component_themes/slider_theme.dart';
import 'component_themes/switch_theme.dart';
import 'extensions/component_theme_ext.dart';
import 'theme_helpers.dart';

abstract final class AppTheme {
  static final ThemeData _light = lightTheme();
  static final ThemeData _dark = darkTheme();

  static ThemeData get light => _light;
  static ThemeData get dark => _dark;

  static ThemeData build({required Brightness brightness, Color? seedColor}) {
    final ColorScheme colorScheme = AppColorScheme.build(
      brightness: brightness,
      seedColor: seedColor,
    );
    final TextTheme textTheme = AppTextTheme.build(
      brightness: brightness,
      colorScheme: colorScheme,
    );
    final ThemeData baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      primaryTextTheme: AppTextTheme.primary(colorScheme),
      visualDensity: const VisualDensity(
        horizontal: WidgetSizes.none,
        vertical: WidgetSizes.none,
      ),
      extensions: _buildExtensions(
        brightness: brightness,
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    );
    final ThemeData legacyAppliedTheme = AppComponentThemeBuilder.apply(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
    final ThemeData themed = ThemeHelpers.applyExtensions(
      theme: legacyAppliedTheme,
      extensions: <ThemeExtension<dynamic>>[
        ComponentThemeExt.fromTheme(legacyAppliedTheme),
      ],
    );
    return themed.copyWith(
      elevatedButtonTheme: AppButtonTheme.elevated(theme: themed),
      outlinedButtonTheme: AppButtonTheme.outlined(theme: themed),
      filledButtonTheme: AppButtonTheme.filled(theme: themed),
      textButtonTheme: AppButtonTheme.text(theme: themed),
      iconButtonTheme: AppButtonTheme.icon(theme: themed),
      inputDecorationTheme: AppInputTheme.build(theme: themed),
      cardTheme: AppCardTheme.build(theme: themed),
      dialogTheme: AppDialogTheme.build(theme: themed),
      bottomSheetTheme: AppBottomSheetTheme.build(theme: themed),
      chipTheme: AppChipTheme.build(theme: themed),
      appBarTheme: AppBarThemeFactory.build(theme: themed),
      dividerTheme: AppDividerTheme.build(theme: themed),
      checkboxTheme: AppCheckboxTheme.build(theme: themed),
      radioTheme: AppRadioTheme.build(theme: themed),
      switchTheme: AppSwitchTheme.build(theme: themed),
      sliderTheme: AppSliderTheme.build(theme: themed),
      progressIndicatorTheme: AppProgressIndicatorTheme.build(theme: themed),
    );
  }

  static ThemeData lightTheme({Color? seedColor}) {
    return build(brightness: Brightness.light, seedColor: seedColor);
  }

  static ThemeData darkTheme({Color? seedColor}) {
    return build(brightness: Brightness.dark, seedColor: seedColor);
  }

  static List<ThemeExtension<dynamic>> _buildExtensions({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return switch (brightness) {
      Brightness.light => AppThemeExtensionsBuilder.light(
        colorScheme,
        textTheme,
      ).toThemeExtensions(),
      Brightness.dark => AppThemeExtensionsBuilder.dark(
        colorScheme,
        textTheme,
      ).toThemeExtensions(),
    };
  }
}
