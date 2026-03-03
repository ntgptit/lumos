import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/flashcard_models.dart';

part 'flashcard_model.freezed.dart';
part 'flashcard_model.g.dart';

const int flashcardDataDefaultId = 0;
const int flashcardDataDefaultDeckId = 0;
const String flashcardDataDefaultFrontText = '';
const String flashcardDataDefaultBackText = '';
const String flashcardDataDefaultPronunciation = '';
const String flashcardDataDefaultNote = '';
const bool flashcardDataDefaultIsBookmarked = false;
const int flashcardDataDefaultPage = 0;
const int flashcardDataDefaultPageSize = 0;
const int flashcardDataDefaultTotalElements = 0;
const int flashcardDataDefaultTotalPages = 0;
const bool flashcardDataDefaultHasNext = false;
const bool flashcardDataDefaultHasPrevious = false;
const int flashcardDataDefaultEpochMilliseconds = 0;

@freezed
abstract class FlashcardAuditModel with _$FlashcardAuditModel {
  const factory FlashcardAuditModel({
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FlashcardAuditModel;

  factory FlashcardAuditModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardAuditModelFromJson(json);
}

@freezed
abstract class FlashcardModel with _$FlashcardModel {
  const factory FlashcardModel({
    @Default(flashcardDataDefaultId) int id,
    @Default(flashcardDataDefaultDeckId) int deckId,
    @Default(flashcardDataDefaultFrontText) String frontText,
    @Default(flashcardDataDefaultBackText) String backText,
    String? frontLangCode,
    String? backLangCode,
    @Default(flashcardDataDefaultPronunciation) String pronunciation,
    @Default(flashcardDataDefaultNote) String note,
    @Default(flashcardDataDefaultIsBookmarked) bool isBookmarked,
    FlashcardAuditModel? audit,
  }) = _FlashcardModel;

  factory FlashcardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardModelFromJson(json);
}

@freezed
abstract class FlashcardPageModel with _$FlashcardPageModel {
  const factory FlashcardPageModel({
    @Default(<FlashcardModel>[]) List<FlashcardModel> items,
    @Default(flashcardDataDefaultPage) int page,
    @Default(flashcardDataDefaultPageSize) int size,
    @Default(flashcardDataDefaultTotalElements) int totalElements,
    @Default(flashcardDataDefaultTotalPages) int totalPages,
    @Default(flashcardDataDefaultHasNext) bool hasNext,
    @Default(flashcardDataDefaultHasPrevious) bool hasPrevious,
  }) = _FlashcardPageModel;

  factory FlashcardPageModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardPageModelFromJson(json);
}

extension FlashcardModelMapper on FlashcardModel {
  FlashcardNode toEntity() {
    final DateTime createdAt = _resolveCreatedAt(audit);
    final DateTime updatedAt = _resolveUpdatedAt(audit);
    return FlashcardNode(
      id: id,
      deckId: deckId,
      frontText: frontText,
      backText: backText,
      frontLangCode: frontLangCode,
      backLangCode: backLangCode,
      pronunciation: pronunciation,
      note: note,
      isBookmarked: isBookmarked,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension FlashcardPageModelMapper on FlashcardPageModel {
  FlashcardPage toEntity() {
    final List<FlashcardNode> mappedItems = items
        .map((FlashcardModel model) => model.toEntity())
        .toList(growable: false);
    return FlashcardPage(
      items: mappedItems,
      page: page,
      size: size,
      totalElements: totalElements,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

DateTime _resolveCreatedAt(FlashcardAuditModel? audit) {
  final DateTime? createdAt = audit?.createdAt;
  if (createdAt != null) {
    return createdAt;
  }
  return DateTime.fromMillisecondsSinceEpoch(
    flashcardDataDefaultEpochMilliseconds,
    isUtc: true,
  );
}

DateTime _resolveUpdatedAt(FlashcardAuditModel? audit) {
  final DateTime? updatedAt = audit?.updatedAt;
  if (updatedAt != null) {
    return updatedAt;
  }
  return DateTime.fromMillisecondsSinceEpoch(
    flashcardDataDefaultEpochMilliseconds,
    isUtc: true,
  );
}
