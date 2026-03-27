import 'package:flutter/widgets.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/utils/context_utils.dart';
import 'package:lumos/core/utils/route_utils.dart';

extension BuildContextExt on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => ContextUtils.screenSize(this);
  double get screenWidth => ContextUtils.screenWidth(this);
  double get screenHeight => ContextUtils.screenHeight(this);
  EdgeInsets get safeAreaPadding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  bool get isDarkMode => ContextUtils.isDarkMode(this);
  bool get isKeyboardVisible => viewInsets.bottom > 0;
  bool get canPop => RouteUtils.canPop(this);

  void hideKeyboard() => ContextUtils.hideKeyboard(this);

  bool popIfPossible<T extends Object?>([T? result]) {
    return RouteUtils.popIfPossible(this, result);
  }

  EdgeInsets get pagePadding {
    return EdgeInsets.symmetric(
      horizontal: layout.pageHorizontalPadding,
      vertical: layout.pageVerticalPadding,
    );
  }
}
