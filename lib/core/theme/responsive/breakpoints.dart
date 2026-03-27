abstract final class AppBreakpoints {
  static const double compactMinWidth = 0;
  static const double compactMaxWidth = 599;
  static const double mediumMinWidth = 600;
  static const double mediumMaxWidth = 839;
  static const double expandedMinWidth = 840;
  static const double expandedMaxWidth = 1199;
  static const double largeMinWidth = 1200;

  static bool isCompact(double width) => width <= compactMaxWidth;

  static bool isMedium(double width) {
    return width >= mediumMinWidth && width <= mediumMaxWidth;
  }

  static bool isExpanded(double width) {
    return width >= expandedMinWidth && width <= expandedMaxWidth;
  }
}
