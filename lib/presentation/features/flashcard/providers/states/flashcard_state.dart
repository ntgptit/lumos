import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/entities/flashcard_models.dart';

part 'flashcard_state.freezed.dart';

abstract final class FlashcardStateConst {
  FlashcardStateConst._();

  static const int firstPage = FlashcardDomainConst.defaultPage;
  static const int pageSize = FlashcardDomainConst.defaultPageSize;
  static const String emptySearchQuery = '';
}

enum FlashcardMutationType { none, creating, updating, deleting }

@freezed
abstract class FlashcardState with _$FlashcardState {
  const FlashcardState._();

  const factory FlashcardState({
    required int deckId,
    required String deckName,
    required String searchQuery,
    required FlashcardSortBy sortBy,
    required FlashcardSortDirection sortDirection,
    required List<FlashcardNode> items,
    required int page,
    required int size,
    required int totalElements,
    required int totalPages,
    required bool hasNext,
    required bool isLoadingMore,
    required bool isRefreshing,
    required bool isSearchVisible,
    required int previewIndex,
    required List<int> starredFlashcardIds,
    required int? playingFlashcardId,
    required bool isStudyCardFlipped,
    required FlashcardMutationType mutationType,
    required String? inlineErrorMessage,
  }) = _FlashcardState;

  bool get isMutating {
    return mutationType != FlashcardMutationType.none;
  }

  bool get hasItems {
    return items.isNotEmpty;
  }

  int get safePreviewIndex {
    if (items.isEmpty) {
      return 0;
    }
    final int maxIndex = items.length - 1;
    if (previewIndex > maxIndex) {
      return maxIndex;
    }
    if (previewIndex < 0) {
      return 0;
    }
    return previewIndex;
  }

  bool isStarred(int flashcardId) {
    return starredFlashcardIds.contains(flashcardId);
  }
}
