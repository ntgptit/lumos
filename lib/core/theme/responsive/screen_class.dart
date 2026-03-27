import 'package:lumos/core/theme/responsive/breakpoints.dart';

enum ScreenClass {
  compact('compact'),
  medium('medium'),
  expanded('expanded'),
  large('large');

  const ScreenClass(this.label);

  final String label;

  static ScreenClass fromWidth(double width) {
    if (AppBreakpoints.isCompact(width)) {
      return ScreenClass.compact;
    }
    if (AppBreakpoints.isMedium(width)) {
      return ScreenClass.medium;
    }
    if (AppBreakpoints.isExpanded(width)) {
      return ScreenClass.expanded;
    }
    return ScreenClass.large;
  }

  bool get isCompact => this == ScreenClass.compact;

  bool get isMedium => this == ScreenClass.medium;

  bool get isExpanded => this == ScreenClass.expanded;

  bool get isLarge => this == ScreenClass.large;

  bool get canUseSplitView => isExpanded || isLarge;

  int get recommendedColumns {
    switch (this) {
      case ScreenClass.compact:
        return 1;
      case ScreenClass.medium:
        return 2;
      case ScreenClass.expanded:
        return 3;
      case ScreenClass.large:
        return 4;
    }
  }
}
