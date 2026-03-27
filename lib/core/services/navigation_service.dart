import 'package:flutter/material.dart';

class NavigationService {
  const NavigationService(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorState? get navigator => navigatorKey.currentState;
  BuildContext? get currentContext => navigatorKey.currentContext;
  bool get isReady => navigator != null;
  bool get canPop => navigator?.canPop() ?? false;

  Future<T?> push<T extends Object?>(Route<T> route) {
    final navigator = this.navigator;
    if (navigator == null) {
      return Future<T?>.error(
        StateError('NavigationService requires a mounted NavigatorState.'),
      );
    }

    return navigator.push<T>(route);
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> route, {
    TO? result,
  }) {
    final navigator = this.navigator;
    if (navigator == null) {
      return Future<T?>.error(
        StateError('NavigationService requires a mounted NavigatorState.'),
      );
    }

    return navigator.pushReplacement<T, TO>(route, result: result);
  }

  Future<bool> maybePop<T extends Object?>([T? result]) async {
    final navigator = this.navigator;
    if (navigator == null) {
      return false;
    }

    return navigator.maybePop<T>(result);
  }

  void pop<T extends Object?>([T? result]) {
    final navigator = this.navigator;
    if (navigator == null || !navigator.canPop()) {
      return;
    }

    navigator.pop<T>(result);
  }

  void popUntilRoot() {
    final navigator = this.navigator;
    if (navigator == null) {
      return;
    }

    navigator.popUntil((route) => route.isFirst);
  }
}
