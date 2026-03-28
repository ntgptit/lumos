import 'package:lumos/core/utils/string_utils.dart';

extension NullableStringExt on String? {
  bool get isBlank => StringUtils.isBlank(this);
  bool get hasText => !isBlank;
  String get orEmpty => this ?? '';

  String? get trimmedOrNull => StringUtils.trimmedOrNull(this);
}

extension StringExt on String {
  String get capitalized => StringUtils.capitalize(this);
  String get normalizedWhitespace => StringUtils.normalizeWhitespace(this);

  String get capitalizedWords {
    return StringUtils.words(
      this,
    ).where((word) => word.isNotEmpty).map(StringUtils.capitalize).join(' ');
  }

  bool equalsIgnoreCase(String? other) {
    return StringUtils.equalsIgnoreCase(this, other);
  }

  String initials({int maxLength = 2}) {
    return StringUtils.initials(this, maxLength: maxLength);
  }

  String truncated({required int maxLength, String ellipsis = '...'}) {
    return StringUtils.truncate(this, maxLength: maxLength, ellipsis: ellipsis);
  }
}
