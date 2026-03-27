import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/localization/locale_provider.dart';
import '../core/providers/theme_provider.dart';
import 'app_router.dart';

part 'app_providers.g.dart';

@Riverpod(keepAlive: true)
class AppLifecycleController extends _$AppLifecycleController {
  @override
  AppLifecycleState build() {
    final AppLifecycleState? lifecycleState =
        WidgetsBinding.instance.lifecycleState;
    if (lifecycleState == null) {
      return AppLifecycleState.resumed;
    }
    return lifecycleState;
  }

  void setLifecycleState(AppLifecycleState lifecycleState) {
    if (state == lifecycleState) {
      return;
    }
    state = lifecycleState;
  }
}

@Riverpod(keepAlive: true)
bool appIsInForeground(Ref ref) {
  final AppLifecycleState lifecycleState = ref.watch(
    appLifecycleControllerProvider,
  );
  return switch (lifecycleState) {
    AppLifecycleState.resumed => true,
    AppLifecycleState.inactive => true,
    AppLifecycleState.hidden => false,
    AppLifecycleState.paused => false,
    AppLifecycleState.detached => false,
  };
}

@Riverpod(keepAlive: true)
GoRouter appRouterConfig(Ref ref) {
  return ref.watch(appRouterProvider);
}

@Riverpod(keepAlive: true)
ThemeMode appThemeModeConfig(Ref ref) {
  return ref.watch(appThemeModeProvider);
}

@Riverpod(keepAlive: true)
ThemeData appLightThemeConfig(Ref ref) {
  return ref.watch(appLightThemeProvider);
}

@Riverpod(keepAlive: true)
ThemeData appDarkThemeConfig(Ref ref) {
  return ref.watch(appDarkThemeProvider);
}

@Riverpod(keepAlive: true)
Locale? appLocaleConfig(Ref ref) {
  return ref.watch(appLocaleProvider);
}
