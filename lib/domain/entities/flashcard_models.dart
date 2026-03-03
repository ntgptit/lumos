import 'package:flutter/foundation.dart';

enum FlashcardSortBy { createdAt, updatedAt, frontText }

enum FlashcardSortDirection { asc, desc }

@immutable
abstract final class FlashcardDomainConst {
  static const int frontTextMinLength = 1;
  static const int frontTextMaxLength = 300;
  static const int backTextMinLength = 1;
  static const int backTextMaxLength = 2000;
  static const int defaultPageSize = 20;
  static const int defaultPage = 0;
  static const int minPage = 0;
  static const int minPageSize = 1;
  static const int maxPageSize = 100;
  static const int audioPlayingIndicatorDurationMs = 1400;
  static const int previewItemLimit = 5;
}

@immutable
class FlashcardNode {
  const FlashcardNode({
    required this.id,
    required this.deckId,
    required this.frontText,
    required this.backText,
    required this.frontLangCode,
    required this.backLangCode,
    required this.pronunciation,
    required this.note,
    required this.isBookmarked,
    required this.createdAt,
    required this.updatedAt,
  });

  static const Object _frontLangCodeUnset = Object();
  static const Object _backLangCodeUnset = Object();

  final int id;
  final int deckId;
  final String frontText;
  final String backText;
  final String? frontLangCode;
  final String? backLangCode;
  final String pronunciation;
  final String note;
  final bool isBookmarked;
  final DateTime createdAt;
  final DateTime updatedAt;

  FlashcardNode copyWith({
    String? frontText,
    String? backText,
    Object? frontLangCode = _frontLangCodeUnset,
    Object? backLangCode = _backLangCodeUnset,
    String? pronunciation,
    String? note,
    bool? isBookmarked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final String? resolvedFrontLangCode =
        identical(frontLangCode, _frontLangCodeUnset)
        ? this.frontLangCode
        : frontLangCode as String?;
    final String? resolvedBackLangCode =
        identical(backLangCode, _backLangCodeUnset)
        ? this.backLangCode
        : backLangCode as String?;
    return FlashcardNode(
      id: id,
      deckId: deckId,
      frontText: frontText ?? this.frontText,
      backText: backText ?? this.backText,
      frontLangCode: resolvedFrontLangCode,
      backLangCode: resolvedBackLangCode,
      pronunciation: pronunciation ?? this.pronunciation,
      note: note ?? this.note,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@immutable
class FlashcardUpsertInput {
  const FlashcardUpsertInput({
    required this.frontText,
    required this.backText,
    required this.frontLangCode,
    required this.backLangCode,
  });

  static const Object _frontLangCodeUnset = Object();
  static const Object _backLangCodeUnset = Object();

  final String frontText;
  final String backText;
  final String? frontLangCode;
  final String? backLangCode;

  FlashcardUpsertInput copyWith({
    String? frontText,
    String? backText,
    Object? frontLangCode = _frontLangCodeUnset,
    Object? backLangCode = _backLangCodeUnset,
  }) {
    final String? resolvedFrontLangCode =
        identical(frontLangCode, _frontLangCodeUnset)
        ? this.frontLangCode
        : frontLangCode as String?;
    final String? resolvedBackLangCode =
        identical(backLangCode, _backLangCodeUnset)
        ? this.backLangCode
        : backLangCode as String?;
    return FlashcardUpsertInput(
      frontText: frontText ?? this.frontText,
      backText: backText ?? this.backText,
      frontLangCode: resolvedFrontLangCode,
      backLangCode: resolvedBackLangCode,
    );
  }

  @override
  int get hashCode =>
      Object.hash(frontText, backText, frontLangCode, backLangCode);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! FlashcardUpsertInput) {
      return false;
    }
    return other.frontText == frontText &&
        other.backText == backText &&
        other.frontLangCode == frontLangCode &&
        other.backLangCode == backLangCode;
  }
}

@immutable
class FlashcardQuery {
  const FlashcardQuery({
    required this.deckId,
    required this.pageSize,
    required this.searchQuery,
    required this.sortBy,
    required this.sortDirection,
  });

  final int deckId;
  final int pageSize;
  final String searchQuery;
  final FlashcardSortBy sortBy;
  final FlashcardSortDirection sortDirection;

  FlashcardQuery copyWith({
    int? pageSize,
    String? searchQuery,
    FlashcardSortBy? sortBy,
    FlashcardSortDirection? sortDirection,
  }) {
    return FlashcardQuery(
      deckId: deckId,
      pageSize: pageSize ?? this.pageSize,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }

  factory FlashcardQuery.initial({required int deckId}) {
    return FlashcardQuery(
      deckId: deckId,
      pageSize: FlashcardDomainConst.defaultPageSize,
      searchQuery: '',
      sortBy: FlashcardSortBy.createdAt,
      sortDirection: FlashcardSortDirection.desc,
    );
  }
}

@immutable
class FlashcardPage {
  const FlashcardPage({
    required this.items,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<FlashcardNode> items;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}
