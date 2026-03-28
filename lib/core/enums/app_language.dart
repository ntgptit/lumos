import 'package:lumos/core/utils/string_utils.dart';

enum AppLanguage {
  english(code: 'en', label: 'English', nativeLabel: 'English'),
  vietnamese(code: 'vi', label: 'Vietnamese', nativeLabel: 'Tiếng Việt'),
  korean(code: 'ko', label: 'Korean', nativeLabel: '한국어');

  const AppLanguage({
    required this.code,
    required this.label,
    required this.nativeLabel,
  });

  final String code;
  final String label;
  final String nativeLabel;

  static AppLanguage fromCode(String? value) {
    final normalized = StringUtils.normalizedLowerOrNull(value);
    for (final language in AppLanguage.values) {
      if (language.code == normalized) {
        return language;
      }
    }
    return AppLanguage.english;
  }
}
