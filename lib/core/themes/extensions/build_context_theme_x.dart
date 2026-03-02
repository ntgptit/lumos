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

  ColorScheme get colorScheme {
    final ThemeData resolvedTheme = Theme.of(this);
    return resolvedTheme.colorScheme;
  }

  TextTheme get textTheme {
    final ThemeData resolvedTheme = Theme.of(this);
    return resolvedTheme.textTheme;
  }

  AppColorTokens get appColors {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppColorTokens? tokens = resolvedTheme.extension<AppColorTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppColorTokens>(resolvedTheme);
    return AppColorTokens.fromColorScheme(
      colorScheme: resolvedTheme.colorScheme,
    );
  }

  AppTextTokens get appText {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppTextTokens? tokens = resolvedTheme.extension<AppTextTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppTextTokens>(resolvedTheme);
    return AppTextTokens.fromTheme(
      colorScheme: resolvedTheme.colorScheme,
      textTheme: resolvedTheme.textTheme,
    );
  }

  AppButtonTokens get appButton {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppButtonTokens? tokens = resolvedTheme.extension<AppButtonTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppButtonTokens>(resolvedTheme);
    return AppButtonTokens.defaults;
  }

  AppInputTokens get appInput {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppInputTokens? tokens = resolvedTheme.extension<AppInputTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppInputTokens>(resolvedTheme);
    return AppInputTokens.defaults;
  }

  AppCardTokens get appCard {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppCardTokens? tokens = resolvedTheme.extension<AppCardTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppCardTokens>(resolvedTheme);
    return AppCardTokens.defaults;
  }

  AppDialogTokens get appDialog {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppDialogTokens? tokens = resolvedTheme.extension<AppDialogTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppDialogTokens>(resolvedTheme);
    return AppDialogTokens.defaults;
  }

  AppNavigationBarTokens get appNavigationBar {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppNavigationBarTokens? tokens = resolvedTheme
        .extension<AppNavigationBarTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppNavigationBarTokens>(resolvedTheme);
    return AppNavigationBarTokens.defaults;
  }
}

void _assertThemeExtensionFallback<T extends ThemeExtension<T>>(
  ThemeData theme,
) {
  assert(() {
    if (!_hasAnyAppThemeExtension(theme)) {
      return true;
    }
    throw FlutterError(
      'Missing ThemeExtension<$T> in ThemeData.extensions. '
      'Ensure AppThemeExtensionsBuilder.toThemeExtensions() is applied.',
    );
  }());
}

bool _hasAnyAppThemeExtension(ThemeData theme) {
  final AppColorTokens? appColorTokens = theme.extension<AppColorTokens>();
  if (appColorTokens != null) {
    return true;
  }

  final AppTextTokens? appTextTokens = theme.extension<AppTextTokens>();
  if (appTextTokens != null) {
    return true;
  }

  final AppButtonTokens? appButtonTokens = theme.extension<AppButtonTokens>();
  if (appButtonTokens != null) {
    return true;
  }

  final AppInputTokens? appInputTokens = theme.extension<AppInputTokens>();
  if (appInputTokens != null) {
    return true;
  }

  final AppCardTokens? appCardTokens = theme.extension<AppCardTokens>();
  if (appCardTokens != null) {
    return true;
  }

  final AppDialogTokens? appDialogTokens = theme.extension<AppDialogTokens>();
  if (appDialogTokens != null) {
    return true;
  }

  final AppNavigationBarTokens? appNavigationBarTokens = theme
      .extension<AppNavigationBarTokens>();
  if (appNavigationBarTokens != null) {
    return true;
  }

  return false;
}
