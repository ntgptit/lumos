import 'breakpoints.dart';

const double _expandedMaxWidth = 1200.0;

enum ScreenClass {
  compact,
  medium,
  expanded,
  large;

  static ScreenClass fromWidth(double width) {
    if (width <= Breakpoints.kMobileMaxWidth) {
      return ScreenClass.compact;
    }
    if (width <= Breakpoints.kTabletMaxWidth) {
      return ScreenClass.medium;
    }
    if (width <= _expandedMaxWidth) {
      return ScreenClass.expanded;
    }
    return ScreenClass.large;
  }

  bool get isCompact => this == ScreenClass.compact;
  bool get isMedium => this == ScreenClass.medium;
  bool get isExpanded => this == ScreenClass.expanded;
  bool get isLarge => this == ScreenClass.large;
}
