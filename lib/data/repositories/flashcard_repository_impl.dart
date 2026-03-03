import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/error/failures.dart';
import '../../core/utils/string_utils.dart';
import '../../domain/entities/flashcard_models.dart';
import '../../domain/repositories/flashcard_repository.dart';

part 'flashcard_repository_impl.g.dart';

abstract final class FlashcardRepositoryImplConst {
  FlashcardRepositoryImplConst._();

  static const String emptyValue = '';
  static const String frontTextRequiredMessage = 'Front text is required.';
  static const String frontTextMaxLengthMessage =
      'Front text must be at most ${FlashcardDomainConst.frontTextMaxLength} characters.';
  static const String backTextRequiredMessage = 'Back text is required.';
  static const String backTextMaxLengthMessage =
      'Back text must be at most ${FlashcardDomainConst.backTextMaxLength} characters.';
  static const String flashcardNotFoundMessage = 'Flashcard not found.';
  static const String flashcardDeckScopeInvalidMessage =
      'Flashcard does not belong to this deck.';
  static const int seedItemCount = 12;
  static const int simulatedLatencyInMs = 120;
}

class InMemoryFlashcardRepository implements FlashcardRepository {
  InMemoryFlashcardRepository();

  final Map<int, List<FlashcardNode>> _store = <int, List<FlashcardNode>>{};
  int _nextId = 1000;

  @override
  Future<Either<Failure, FlashcardPage>> getFlashcards({
    required FlashcardQuery query,
    required int page,
  }) async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: FlashcardRepositoryImplConst.simulatedLatencyInMs,
      ),
    );
    final int safePage = _resolvePage(page);
    final int safePageSize = _resolvePageSize(query.pageSize);
    final List<FlashcardNode> allItems = _resolveDeckItems(query.deckId);
    final List<FlashcardNode> filteredItems = _filterItems(
      items: allItems,
      searchQuery: query.searchQuery,
    );
    final List<FlashcardNode> sortedItems = _sortItems(
      items: filteredItems,
      sortBy: query.sortBy,
      sortDirection: query.sortDirection,
    );
    final int totalElements = sortedItems.length;
    final int totalPages = _resolveTotalPages(
      totalElements: totalElements,
      pageSize: safePageSize,
    );
    final int start = safePage * safePageSize;
    if (start >= totalElements) {
      return right<Failure, FlashcardPage>(
        FlashcardPage(
          items: const <FlashcardNode>[],
          page: safePage,
          size: safePageSize,
          totalElements: totalElements,
          totalPages: totalPages,
          hasNext: false,
          hasPrevious: safePage > FlashcardDomainConst.defaultPage,
        ),
      );
    }
    final int end = math.min(start + safePageSize, totalElements);
    final List<FlashcardNode> pageItems = sortedItems.sublist(start, end);
    return right<Failure, FlashcardPage>(
      FlashcardPage(
        items: pageItems,
        page: safePage,
        size: safePageSize,
        totalElements: totalElements,
        totalPages: totalPages,
        hasNext: end < totalElements,
        hasPrevious: safePage > FlashcardDomainConst.defaultPage,
      ),
    );
  }

  @override
  Future<Either<Failure, FlashcardNode>> createFlashcard({
    required int deckId,
    required FlashcardUpsertInput input,
  }) async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: FlashcardRepositoryImplConst.simulatedLatencyInMs,
      ),
    );
    final FlashcardUpsertInput normalizedInput = _normalizeInput(input);
    final Failure? validationFailure = _validateInput(normalizedInput);
    if (validationFailure != null) {
      return left<Failure, FlashcardNode>(validationFailure);
    }
    final DateTime timestamp = DateTime.now().toUtc();
    final FlashcardNode createdNode = FlashcardNode(
      id: _nextId++,
      deckId: deckId,
      frontText: normalizedInput.frontText,
      backText: normalizedInput.backText,
      frontLangCode: normalizedInput.frontLangCode,
      backLangCode: normalizedInput.backLangCode,
      pronunciation: FlashcardRepositoryImplConst.emptyValue,
      note: FlashcardRepositoryImplConst.emptyValue,
      isBookmarked: false,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
    final List<FlashcardNode> items = _resolveDeckItems(deckId);
    _store[deckId] = <FlashcardNode>[createdNode, ...items];
    return right<Failure, FlashcardNode>(createdNode);
  }

  @override
  Future<Either<Failure, FlashcardNode>> updateFlashcard({
    required int deckId,
    required int flashcardId,
    required FlashcardUpsertInput input,
  }) async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: FlashcardRepositoryImplConst.simulatedLatencyInMs,
      ),
    );
    final FlashcardUpsertInput normalizedInput = _normalizeInput(input);
    final Failure? validationFailure = _validateInput(normalizedInput);
    if (validationFailure != null) {
      return left<Failure, FlashcardNode>(validationFailure);
    }
    final List<FlashcardNode> items = _resolveDeckItems(deckId);
    final int targetIndex = items.indexWhere((FlashcardNode node) {
      return node.id == flashcardId;
    });
    if (targetIndex < 0) {
      return left<Failure, FlashcardNode>(
        const Failure.notFound(
          message: FlashcardRepositoryImplConst.flashcardNotFoundMessage,
        ),
      );
    }
    final FlashcardNode targetNode = items[targetIndex];
    if (targetNode.deckId != deckId) {
      return left<Failure, FlashcardNode>(
        const Failure.validation(
          message:
              FlashcardRepositoryImplConst.flashcardDeckScopeInvalidMessage,
        ),
      );
    }
    final FlashcardNode updatedNode = targetNode.copyWith(
      frontText: normalizedInput.frontText,
      backText: normalizedInput.backText,
      frontLangCode: normalizedInput.frontLangCode,
      backLangCode: normalizedInput.backLangCode,
      updatedAt: DateTime.now().toUtc(),
    );
    final List<FlashcardNode> nextItems = <FlashcardNode>[...items];
    nextItems[targetIndex] = updatedNode;
    _store[deckId] = nextItems;
    return right<Failure, FlashcardNode>(updatedNode);
  }

  @override
  Future<Either<Failure, Unit>> deleteFlashcard({
    required int deckId,
    required int flashcardId,
  }) async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: FlashcardRepositoryImplConst.simulatedLatencyInMs,
      ),
    );
    final List<FlashcardNode> items = _resolveDeckItems(deckId);
    final int beforeCount = items.length;
    final List<FlashcardNode> nextItems = items
        .where((FlashcardNode node) {
          return node.id != flashcardId;
        })
        .toList(growable: false);
    if (beforeCount == nextItems.length) {
      return left<Failure, Unit>(
        const Failure.notFound(
          message: FlashcardRepositoryImplConst.flashcardNotFoundMessage,
        ),
      );
    }
    _store[deckId] = nextItems;
    return right<Failure, Unit>(unit);
  }

  List<FlashcardNode> _resolveDeckItems(int deckId) {
    final List<FlashcardNode>? existingItems = _store[deckId];
    if (existingItems != null) {
      return List<FlashcardNode>.from(existingItems);
    }
    final List<FlashcardNode> seededItems = _buildSeedItems(deckId: deckId);
    _store[deckId] = seededItems;
    return List<FlashcardNode>.from(seededItems);
  }

  List<FlashcardNode> _buildSeedItems({required int deckId}) {
    final DateTime baseTimestamp = DateTime.utc(2026, 1, 1, 0, 0, 0);
    return List<FlashcardNode>.generate(
      FlashcardRepositoryImplConst.seedItemCount,
      (int index) {
        final int id = _nextId++;
        final int displayNumber = index + 1;
        final DateTime createdAt = baseTimestamp.add(
          Duration(days: displayNumber),
        );
        final DateTime updatedAt = createdAt.add(const Duration(hours: 6));
        return FlashcardNode(
          id: id,
          deckId: deckId,
          frontText: 'Term $displayNumber',
          backText: 'Meaning for term $displayNumber',
          frontLangCode: null,
          backLangCode: null,
          pronunciation: '/term-$displayNumber/',
          note: 'Deck $deckId sample card $displayNumber',
          isBookmarked: displayNumber.isEven,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
      },
    );
  }

  List<FlashcardNode> _filterItems({
    required List<FlashcardNode> items,
    required String searchQuery,
  }) {
    final String normalizedSearch = StringUtils.normalizeLower(searchQuery);
    if (normalizedSearch.isEmpty) {
      return items;
    }
    return items
        .where((FlashcardNode item) {
          final String frontText = StringUtils.normalizeLower(item.frontText);
          final String backText = StringUtils.normalizeLower(item.backText);
          if (frontText.contains(normalizedSearch)) {
            return true;
          }
          if (backText.contains(normalizedSearch)) {
            return true;
          }
          return false;
        })
        .toList(growable: false);
  }

  List<FlashcardNode> _sortItems({
    required List<FlashcardNode> items,
    required FlashcardSortBy sortBy,
    required FlashcardSortDirection sortDirection,
  }) {
    final List<FlashcardNode> nextItems = <FlashcardNode>[...items];
    nextItems.sort((FlashcardNode left, FlashcardNode right) {
      final int baseCompare = _compareBySortBy(
        left: left,
        right: right,
        sortBy: sortBy,
      );
      if (sortDirection == FlashcardSortDirection.asc) {
        return baseCompare;
      }
      return -baseCompare;
    });
    return nextItems;
  }

  int _compareBySortBy({
    required FlashcardNode left,
    required FlashcardNode right,
    required FlashcardSortBy sortBy,
  }) {
    if (sortBy == FlashcardSortBy.createdAt) {
      return left.createdAt.compareTo(right.createdAt);
    }
    if (sortBy == FlashcardSortBy.updatedAt) {
      return left.updatedAt.compareTo(right.updatedAt);
    }
    final int compareFrontText = StringUtils.compareNormalizedLower(
      left.frontText,
      right.frontText,
    );
    if (compareFrontText != 0) {
      return compareFrontText;
    }
    return left.id.compareTo(right.id);
  }

  FlashcardUpsertInput _normalizeInput(FlashcardUpsertInput input) {
    return FlashcardUpsertInput(
      frontText: StringUtils.normalizeName(input.frontText),
      backText: StringUtils.normalizeName(input.backText),
      frontLangCode: input.frontLangCode,
      backLangCode: input.backLangCode,
    );
  }

  Failure? _validateInput(FlashcardUpsertInput input) {
    if (input.frontText.length < FlashcardDomainConst.frontTextMinLength) {
      return const Failure.validation(
        message: FlashcardRepositoryImplConst.frontTextRequiredMessage,
      );
    }
    if (input.frontText.length > FlashcardDomainConst.frontTextMaxLength) {
      return const Failure.validation(
        message: FlashcardRepositoryImplConst.frontTextMaxLengthMessage,
      );
    }
    if (input.backText.length < FlashcardDomainConst.backTextMinLength) {
      return const Failure.validation(
        message: FlashcardRepositoryImplConst.backTextRequiredMessage,
      );
    }
    if (input.backText.length > FlashcardDomainConst.backTextMaxLength) {
      return const Failure.validation(
        message: FlashcardRepositoryImplConst.backTextMaxLengthMessage,
      );
    }
    return null;
  }

  int _resolvePage(int page) {
    if (page < FlashcardDomainConst.minPage) {
      return FlashcardDomainConst.minPage;
    }
    return page;
  }

  int _resolvePageSize(int pageSize) {
    if (pageSize < FlashcardDomainConst.minPageSize) {
      return FlashcardDomainConst.defaultPageSize;
    }
    if (pageSize > FlashcardDomainConst.maxPageSize) {
      return FlashcardDomainConst.maxPageSize;
    }
    return pageSize;
  }

  int _resolveTotalPages({required int totalElements, required int pageSize}) {
    if (totalElements == 0) {
      return 0;
    }
    return ((totalElements - 1) ~/ pageSize) + 1;
  }
}

@Riverpod(keepAlive: true)
FlashcardRepository flashcardRepository(Ref ref) {
  return InMemoryFlashcardRepository();
}
