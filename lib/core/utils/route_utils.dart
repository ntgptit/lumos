import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

abstract final class RouteUtils {
  static String? currentRouteName(BuildContext context) {
    return ModalRoute.of(context)?.settings.name;
  }

  static bool isCurrentRoute(BuildContext context, String routeName) {
    return currentRouteName(context) == routeName;
  }

  static bool canPop(BuildContext context) {
    return GoRouter.maybeOf(context)?.canPop() ?? false;
  }

  static bool popIfPossible<T extends Object?>(
    BuildContext context, [
    T? result,
  ]) {
    if (!canPop(context)) {
      return false;
    }
    GoRouter.maybeOf(context)?.pop<T>(result);
    return true;
  }
}
