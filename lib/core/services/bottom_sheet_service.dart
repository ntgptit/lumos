import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomSheetService {
  const BottomSheetService(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  BuildContext? get currentContext => navigatorKey.currentContext;
  bool get isAvailable => currentContext != null;

  Future<T?> show<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    Color? backgroundColor,
    bool useRootNavigator = true,
  }) {
    final context = currentContext;
    if (context == null) {
      return Future<T?>.error(
        StateError('BottomSheetService requires a mounted Navigator context.'),
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      useRootNavigator: useRootNavigator,
      builder: builder,
    );
  }

  void close<T extends Object?>([T? result]) {
    final context = currentContext;
    if (context == null) {
      return;
    }

    final router = GoRouter.maybeOf(context);
    if (router == null || !router.canPop()) {
      return;
    }

    router.pop<T>(result);
  }
}
