import 'package:lumos/core/theme/responsive/screen_class.dart';

abstract final class ResponsiveScale {
  static double spacing(ScreenClass screenClass) {
    return switch (screenClass) {
      ScreenClass.compact => 1.0,
      ScreenClass.medium => 1.0,
      ScreenClass.expanded => 1.15,
      ScreenClass.large => 1.2,
    };
  }

  static double typography(ScreenClass screenClass) {
    return switch (screenClass) {
      ScreenClass.compact => 1.0,
      ScreenClass.medium => 1.0,
      ScreenClass.expanded => 1.08,
      ScreenClass.large => 1.12,
    };
  }

  static double radius(ScreenClass screenClass) {
    return switch (screenClass) {
      ScreenClass.compact => 1.0,
      ScreenClass.medium => 1.0,
      ScreenClass.expanded => 1.05,
      ScreenClass.large => 1.08,
    };
  }

  static double icon(ScreenClass screenClass) {
    return switch (screenClass) {
      ScreenClass.compact => 1.0,
      ScreenClass.medium => 1.0,
      ScreenClass.expanded => 1.06,
      ScreenClass.large => 1.1,
    };
  }

  static double component(ScreenClass screenClass) {
    return switch (screenClass) {
      ScreenClass.compact => 1.0,
      ScreenClass.medium => 1.0,
      ScreenClass.expanded => 1.06,
      ScreenClass.large => 1.1,
    };
  }
}
