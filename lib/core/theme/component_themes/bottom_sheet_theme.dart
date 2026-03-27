import 'package:flutter/material.dart';

import '../../themes/builders/app_dialog_theme_builder.dart';
import '../extensions/component_theme_ext.dart';

abstract final class AppBottomSheetTheme {
  static BottomSheetThemeData build({required ThemeData theme}) {
    final ComponentThemeExt componentTheme =
        theme.extension<ComponentThemeExt>() ??
        ComponentThemeExt.fromTheme(theme);
    return AppDialogThemeBuilder.bottomSheetTheme(
      colorScheme: theme.colorScheme,
      dialogTokens: componentTheme.dialog,
    );
  }
}
