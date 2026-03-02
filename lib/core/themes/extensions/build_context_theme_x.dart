import 'package:flutter/material.dart';

import '../component/app_button_tokens.dart';
import '../component/app_card_tokens.dart';
import '../component/app_dialog_tokens.dart';
import '../component/app_input_tokens.dart';
import '../component/app_navigation_bar_tokens.dart';
import '../component/app_theme_contract_tokens.dart';
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
    _assertThemeExtensionFallback<AppColorTokens>(
      theme: resolvedTheme,
      accessor: 'appColors',
    );
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
    _assertThemeExtensionFallback<AppTextTokens>(
      theme: resolvedTheme,
      accessor: 'appText',
    );
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
    _assertThemeExtensionFallback<AppButtonTokens>(
      theme: resolvedTheme,
      accessor: 'appButton',
    );
    return AppButtonTokens.defaults;
  }

  AppInputTokens get appInput {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppInputTokens? tokens = resolvedTheme.extension<AppInputTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppInputTokens>(
      theme: resolvedTheme,
      accessor: 'appInput',
    );
    return AppInputTokens.defaults;
  }

  AppCardTokens get appCard {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppCardTokens? tokens = resolvedTheme.extension<AppCardTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppCardTokens>(
      theme: resolvedTheme,
      accessor: 'appCard',
    );
    return AppCardTokens.defaults;
  }

  AppDialogTokens get appDialog {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppDialogTokens? tokens = resolvedTheme.extension<AppDialogTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppDialogTokens>(
      theme: resolvedTheme,
      accessor: 'appDialog',
    );
    return AppDialogTokens.defaults;
  }

  AppNavigationBarTokens get appNavigationBar {
    final ThemeData resolvedTheme = Theme.of(this);
    final AppNavigationBarTokens? tokens = resolvedTheme
        .extension<AppNavigationBarTokens>();
    if (tokens != null) {
      return tokens;
    }
    _assertThemeExtensionFallback<AppNavigationBarTokens>(
      theme: resolvedTheme,
      accessor: 'appNavigationBar',
    );
    return AppNavigationBarTokens.defaults;
  }
}

void _assertThemeExtensionFallback<T extends ThemeExtension<T>>({
  required ThemeData theme,
  required String accessor,
}) {
  assert(() {
    final T? extension = theme.extension<T>();
    if (extension != null) {
      return true;
    }
    final AppThemeContractTokens? contractTokens = theme
        .extension<AppThemeContractTokens>();
    if (contractTokens == null) {
      return true;
    }
    throw FlutterError(
      'Missing ThemeExtension<$T> for BuildContextThemeX.$accessor. '
      'Ensure AppThemeExtensionsBuilder.toThemeExtensions() is applied.',
    );
  }());
}
