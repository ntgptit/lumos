import '../../../../core/utils/string_utils.dart';

class StudyFillAnswerComparison {
  const StudyFillAnswerComparison({
    required this.correctAnswer,
    required this.prefix,
    required this.errorSuffix,
  });

  final String correctAnswer;
  final String prefix;
  final String errorSuffix;

  static StudyFillAnswerComparison? resolve({
    required String content,
    required String? submittedAnswer,
    required int? mismatchStartIndex,
  }) {
    final int? rawHighlightStartIndex = mismatchStartIndex;
    if (rawHighlightStartIndex == null) {
      return null;
    }
    final String normalizedContent = StringUtils.normalizeName(content);
    final String normalizedSubmitted = StringUtils.normalizeName(
      submittedAnswer ?? '',
    );
    final int highlightStartIndex = _resolveHighlightStartIndex(
      highlightStartIndex: rawHighlightStartIndex,
      normalizedContent: normalizedContent,
    );
    final String prefix = _resolvePrefix(
      normalizedSubmitted: normalizedSubmitted,
      highlightStartIndex: highlightStartIndex,
    );
    final String errorSuffix = _resolveErrorSuffix(
      normalizedContent: normalizedContent,
      normalizedSubmitted: normalizedSubmitted,
      highlightStartIndex: highlightStartIndex,
    );
    return StudyFillAnswerComparison(
      correctAnswer: normalizedContent,
      prefix: prefix,
      errorSuffix: errorSuffix,
    );
  }

  static int _resolveHighlightStartIndex({
    required int highlightStartIndex,
    required String normalizedContent,
  }) {
    if (normalizedContent.isEmpty) {
      return 0;
    }
    if (highlightStartIndex < 0) {
      return 0;
    }
    if (highlightStartIndex > normalizedContent.length) {
      return normalizedContent.length;
    }
    return highlightStartIndex;
  }

  static String _resolvePrefix({
    required String normalizedSubmitted,
    required int highlightStartIndex,
  }) {
    if (normalizedSubmitted.isEmpty) {
      return '';
    }
    return StringUtils.prefix(normalizedSubmitted, highlightStartIndex);
  }

  static String _resolveErrorSuffix({
    required String normalizedContent,
    required String normalizedSubmitted,
    required int highlightStartIndex,
  }) {
    if (normalizedSubmitted.isEmpty) {
      return normalizedContent;
    }
    if (highlightStartIndex < normalizedSubmitted.length) {
      return StringUtils.suffix(normalizedSubmitted, highlightStartIndex);
    }
    if (highlightStartIndex < normalizedContent.length) {
      return StringUtils.suffix(normalizedContent, highlightStartIndex);
    }
    if (normalizedSubmitted.length > normalizedContent.length) {
      return StringUtils.suffix(normalizedSubmitted, normalizedContent.length);
    }
    return StringUtils.trailingCharacter(normalizedSubmitted);
  }
}
