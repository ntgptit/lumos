import 'package:lumos/core/utils/string_utils.dart';

enum AppThemeType {
  system,
  light,
  dark;

  bool get isSystem => this == AppThemeType.system;
  bool get isLight => this == AppThemeType.light;
  bool get isDark => this == AppThemeType.dark;

  static AppThemeType fromName(String? value) {
    final normalized = StringUtils.normalizedLowerOrNull(value);
    for (final themeType in AppThemeType.values) {
      if (themeType.name == normalized) {
        return themeType;
      }
    }
    return AppThemeType.system;
  }
}
