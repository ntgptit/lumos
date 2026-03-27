enum AppThemeType {
  system,
  light,
  dark;

  bool get isSystem => this == AppThemeType.system;
  bool get isLight => this == AppThemeType.light;
  bool get isDark => this == AppThemeType.dark;

  static AppThemeType fromName(String? value) {
    final normalized = value?.trim().toLowerCase();
    for (final themeType in AppThemeType.values) {
      if (themeType.name == normalized) {
        return themeType;
      }
    }
    return AppThemeType.system;
  }
}
