import 'package:flutter/material.dart';

import '../../themes/semantic/app_color_tokens.dart';

extension ColorSchemeExt on ColorScheme {
  AppColorTokens get semanticColors {
    return AppColorTokens.fromColorScheme(colorScheme: this);
  }

  Color get success => semanticColors.success;
  Color get onSuccess => semanticColors.onSuccess;
  Color get successContainer => semanticColors.successContainer;
  Color get onSuccessContainer => semanticColors.onSuccessContainer;

  Color get warning => semanticColors.warning;
  Color get onWarning => semanticColors.onWarning;
  Color get warningContainer => semanticColors.warningContainer;
  Color get onWarningContainer => semanticColors.onWarningContainer;

  Color get info => semanticColors.info;
  Color get onInfo => semanticColors.onInfo;
  Color get infoContainer => semanticColors.infoContainer;
  Color get onInfoContainer => semanticColors.onInfoContainer;
}
