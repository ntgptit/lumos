import 'package:flutter/material.dart';

import '../../themes/builders/app_adaptive_theme_builder.dart';
import '../component_themes/app_bar_theme.dart';
import '../component_themes/bottom_sheet_theme.dart';
import '../component_themes/button_theme.dart';
import '../component_themes/card_theme.dart';
import '../component_themes/checkbox_theme.dart';
import '../component_themes/chip_theme.dart';
import '../component_themes/dialog_theme.dart';
import '../component_themes/divider_theme.dart';
import '../component_themes/input_theme.dart';
import '../component_themes/progress_indicator_theme.dart';
import '../component_themes/radio_theme.dart';
import '../component_themes/slider_theme.dart';
import '../component_themes/switch_theme.dart';
import '../extensions/component_theme_ext.dart';
import '../extensions/dimension_theme_ext.dart';
import '../theme_helpers.dart';
import 'screen_info.dart';

abstract final class ResponsiveThemeFactory {
  static ScreenInfo screenInfoOf(BuildContext context) {
    return ScreenInfo.fromMediaQueryData(MediaQuery.of(context));
  }

  static ThemeData adapt({
    required ThemeData theme,
    required MediaQueryData mediaQueryData,
  }) {
    final ThemeData adaptedTheme = AppAdaptiveThemeBuilder.adapt(
      theme: theme,
      screenWidth: mediaQueryData.size.width,
    );
    final ThemeData themed = ThemeHelpers.applyExtensions(
      theme: adaptedTheme,
      extensions: <ThemeExtension<dynamic>>[
        ComponentThemeExt.fromTheme(adaptedTheme),
        DimensionThemeExt.fromMediaQueryData(mediaQueryData),
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
}
