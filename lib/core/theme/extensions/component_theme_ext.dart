import 'package:flutter/material.dart';

import '../../themes/component/app_button_tokens.dart';
import '../../themes/component/app_card_tokens.dart';
import '../../themes/component/app_dialog_tokens.dart';
import '../../themes/component/app_input_tokens.dart';
import '../../themes/component/app_navigation_bar_tokens.dart';

@immutable
final class ComponentThemeExt extends ThemeExtension<ComponentThemeExt> {
  const ComponentThemeExt({
    required this.button,
    required this.input,
    required this.card,
    required this.dialog,
    required this.navigationBar,
  });

  factory ComponentThemeExt.fromTheme(ThemeData theme) {
    return ComponentThemeExt(
      button: theme.extension<AppButtonTokens>() ?? AppButtonTokens.defaults,
      input: theme.extension<AppInputTokens>() ?? AppInputTokens.defaults,
      card: theme.extension<AppCardTokens>() ?? AppCardTokens.defaults,
      dialog: theme.extension<AppDialogTokens>() ?? AppDialogTokens.defaults,
      navigationBar:
          theme.extension<AppNavigationBarTokens>() ??
          AppNavigationBarTokens.defaults,
    );
  }

  final AppButtonTokens button;
  final AppInputTokens input;
  final AppCardTokens card;
  final AppDialogTokens dialog;
  final AppNavigationBarTokens navigationBar;

  @override
  ComponentThemeExt copyWith({
    AppButtonTokens? button,
    AppInputTokens? input,
    AppCardTokens? card,
    AppDialogTokens? dialog,
    AppNavigationBarTokens? navigationBar,
  }) {
    return ComponentThemeExt(
      button: button ?? this.button,
      input: input ?? this.input,
      card: card ?? this.card,
      dialog: dialog ?? this.dialog,
      navigationBar: navigationBar ?? this.navigationBar,
    );
  }

  @override
  ComponentThemeExt lerp(ThemeExtension<ComponentThemeExt>? other, double t) {
    if (other is! ComponentThemeExt) {
      return this;
    }
    return ComponentThemeExt(
      button: button.lerp(other.button, t),
      input: input.lerp(other.input, t),
      card: card.lerp(other.card, t),
      dialog: dialog.lerp(other.dialog, t),
      navigationBar: navigationBar.lerp(other.navigationBar, t),
    );
  }
}
