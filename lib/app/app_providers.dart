import 'package:flutter/material.dart';
import 'package:lumos/core/config/app_keys.dart';
import 'package:lumos/core/enums/app_theme_type.dart';
import 'package:lumos/core/enums/app_locale.dart';
import 'package:lumos/core/di/core_providers.dart';
import 'package:lumos/core/utils/logger.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_providers.g.dart';

@Riverpod(keepAlive: true)
class ThemeTypeController extends _$ThemeTypeController {
  @override
  AppThemeType build() {
    final storage = ref.watch(preferencesStorageProvider);
    final rawValue = storage.read<String>(AppKeys.themeTypeStorageKey);

    return AppThemeType.fromName(rawValue);
  }

  Future<void> setTheme(AppThemeType themeType) async {
    state = themeType;
    await ref
        .read(preferencesStorageProvider)
        .write(AppKeys.themeTypeStorageKey, themeType.name);
  }

  Future<void> reset() {
    return setTheme(AppThemeType.system);
  }

  Future<void> toggle() {
    switch (state) {
      case AppThemeType.system:
        return setTheme(AppThemeType.light);
      case AppThemeType.light:
        return setTheme(AppThemeType.dark);
      case AppThemeType.dark:
        return setTheme(AppThemeType.system);
    }
  }
}

@Riverpod(keepAlive: true)
class AppLocaleController extends _$AppLocaleController {
  @override
  AppLocale build() {
    final storage = ref.watch(preferencesStorageProvider);
    final rawValue = storage.read<String>(AppKeys.localeStorageKey);

    return AppLocale.fromLanguageCode(rawValue);
  }

  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    await ref
        .read(preferencesStorageProvider)
        .write(AppKeys.localeStorageKey, locale.languageCode);
  }

  Future<void> reset() {
    return setLocale(AppLocale.fromLanguageCode(null));
  }
}

@Riverpod(keepAlive: true)
class LifecycleStateController extends _$LifecycleStateController {
  @override
  AppLifecycleState? build() {
    return WidgetsBinding.instance.lifecycleState;
  }

  void setLifecycle(AppLifecycleState lifecycleState) {
    if (state == lifecycleState) {
      return;
    }

    Logger.debug('Lifecycle changed: $lifecycleState');
    state = lifecycleState;
  }
}

@Riverpod(keepAlive: true)
Locale appLocale(Ref ref) {
  final selectedLocale = ref.watch(appLocaleControllerProvider);
  return selectedLocale.locale;
}

@Riverpod(keepAlive: true)
List<Locale> supportedLocales(Ref ref) {
  return AppLocalizations.supportedLocales;
}
