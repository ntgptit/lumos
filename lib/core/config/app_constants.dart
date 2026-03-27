import 'package:flutter/widgets.dart';

abstract final class AppConstants {
  static const appPackage = 'com.lumos.app';
  static const appRestorationScopeId = 'lumos_app';
  static const defaultLocaleCode = 'en';
  static const supportedLocaleCodes = <String>['en', 'vi', 'ko'];
  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
    Locale('ko'),
  ];
  static const minTextScaleFactor = 0.9;
  static const maxTextScaleFactor = 1.15;
  static const defaultPageSize = 20;
  static const defaultSearchPageSize = 20;
}
