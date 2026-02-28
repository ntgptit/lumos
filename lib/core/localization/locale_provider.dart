import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

abstract final class LocaleProviderConst {
  LocaleProviderConst._();

  static const String englishLanguageCode = 'en';
  static const String vietnameseLanguageCode = 'vi';
}

/// Provides current app locale.
///
/// `null` means following system locale.
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale? build() {
    return null;
  }

  /// Uses system locale.
  void useSystemLocale() {
    state = null;
  }

  /// Uses English locale.
  void useEnglish() {
    state = const Locale(LocaleProviderConst.englishLanguageCode);
  }

  /// Uses Vietnamese locale.
  void useVietnamese() {
    state = const Locale(LocaleProviderConst.vietnameseLanguageCode);
  }

  /// Uses a specific locale.
  void setLocale(Locale locale) {
    state = locale;
  }
}
