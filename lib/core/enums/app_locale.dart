import 'package:flutter/widgets.dart';
import 'package:lumos/core/config/app_constants.dart';
import 'package:lumos/core/enums/app_language.dart';

enum AppLocale {
  en(
    languageCode: 'en',
    displayName: 'English',
    nativeName: 'English',
    language: AppLanguage.english,
  ),
  vi(
    languageCode: 'vi',
    displayName: 'Vietnamese',
    nativeName: 'Tiếng Việt',
    language: AppLanguage.vietnamese,
  ),
  ko(
    languageCode: 'ko',
    displayName: 'Korean',
    nativeName: '한국어',
    language: AppLanguage.korean,
  );

  const AppLocale({
    required this.languageCode,
    required this.displayName,
    required this.nativeName,
    required this.language,
  });

  final String languageCode;
  final String displayName;
  final String nativeName;
  final AppLanguage language;

  Locale get locale => Locale(languageCode);
  bool get isDefault => languageCode == AppConstants.defaultLocaleCode;

  static AppLocale fromLanguageCode(String? value) {
    final normalized = value?.trim().toLowerCase();
    for (final locale in AppLocale.values) {
      if (locale.languageCode == normalized) {
        return locale;
      }
    }
    return _defaultLocale;
  }

  static AppLocale fromLocale(Locale? value) {
    return fromLanguageCode(value?.languageCode);
  }

  static AppLocale get _defaultLocale {
    for (final locale in AppLocale.values) {
      if (locale.languageCode == AppConstants.defaultLocaleCode) {
        return locale;
      }
    }
    return AppLocale.en;
  }
}
