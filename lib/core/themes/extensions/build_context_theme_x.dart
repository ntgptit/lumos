import 'package:flutter/material.dart';

import '../component/app_button_tokens.dart';
import '../component/app_card_tokens.dart';
import '../component/app_dialog_tokens.dart';
import '../component/app_input_tokens.dart';
import '../component/app_navigation_bar_tokens.dart';
import '../semantic/app_color_tokens.dart';
import '../semantic/app_text_tokens.dart';

extension BuildContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  AppColorTokens get appColors {
    final AppColorTokens? tokens = theme.extension<AppColorTokens>();
    if (tokens != null) {
      return tokens;
    }
    return AppColorTokens.fromColorScheme(colorScheme: colorScheme);
  }

  AppTextTokens get appText {
    final AppTextTokens? tokens = theme.extension<AppTextTokens>();
    if (tokens != null) {
      return tokens;
    }
    return AppTextTokens.fromTheme(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  AppButtonTokens get appButton {
    final AppButtonTokens? tokens = theme.extension<AppButtonTokens>();
    if (tokens != null) {
      return tokens;
    }
    return AppButtonTokens.defaults;
  }

  AppInputTokens get appInput {
    final AppInputTokens? tokens = theme.extension<AppInputTokens>();
    if (tokens != null) {
      return tokens;
    }
    return AppInputTokens.defaults;
  }

  AppCardTokens get appCard {
    final AppCardTokens? tokens = theme.extension<AppCardTokens>();
    if (tokens != null) {
      return tokens;
    }
    return AppCardTokens.defaults;
  }

  AppDialogTokens get appDialog {
    final AppDialogTokens? tokens = theme.extension<AppDialogTokens>();
    if (tokens != null) {
      return tokens;
    }
    return AppDialogTokens.defaults;
  }

  AppNavigationBarTokens get appNavigationBar {
    final AppNavigationBarTokens? tokens = theme
        .extension<AppNavigationBarTokens>();
    if (tokens != null) {
      return tokens;
    }
    return AppNavigationBarTokens.defaults;
  }
}
