import 'package:flutter/material.dart';

import '../responsive/screen_class.dart';
import '../responsive/screen_info.dart';
import 'dimension_theme_ext.dart';

extension ScreenContextExt on BuildContext {
  ScreenInfo get screenInfo {
    final DimensionThemeExt? extension = Theme.of(
      this,
    ).extension<DimensionThemeExt>();
    if (extension != null) {
      return extension.screenInfo;
    }
    return ScreenInfo.fromMediaQueryData(MediaQuery.of(this));
  }

  ScreenClass get screenClass => screenInfo.screenClass;
}
