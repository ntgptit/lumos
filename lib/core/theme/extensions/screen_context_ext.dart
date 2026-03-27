import 'package:flutter/material.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';

extension ScreenContextExt on BuildContext {
  ScreenInfo get screenInfo => ScreenInfo.fromContext(this);
  ScreenClass get screenClass => screenInfo.screenClass;
}
