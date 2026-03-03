import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../data/repositories/flashcard_repository_impl.dart';
import '../../../../domain/entities/flashcard_models.dart';
import '../../../../domain/repositories/flashcard_repository.dart';
import 'states/flashcard_state.dart';

part 'flashcard_provider.g.dart';

abstract final class FlashcardProviderConst {
  FlashcardProviderConst._();

  static const String unknownErrorMessage = 'Unknown error';
  static const String frontTextRequiredMessage = 'Front text is required.';
  static const String frontTextMaxLengthMessage =
      'Front text must be at most ${FlashcardDomainConst.frontTextMaxLength} characters.';
  static const String backTextRequiredMessage = 'Back text is required.';
  static const String backTextMaxLengthMessage =
      'Back text must be at most ${FlashcardDomainConst.backTextMaxLength} characters.';
}

class FlashcardSubmitResult {
  const FlashcardSubmitResult._({
    required this.isSuccess,
    this.formErrorMessage,
  });

  const FlashcardSubmitResult.success() : this._(isSuccess: true);

  const FlashcardSubmitResult.failure({String? formErrorMessage})
    : this._(isSuccess: false, formErrorMessage: formErrorMessage);

  final bool isSuccess;
  final String? formErrorMessage;
}

@Riverpod(keepAlive: true)
class FlashcardAsyncController extends _$FlashcardAsyncController {
  Timer? _audioPlayingTimer;
  int _queryRequestVersion = 0;

  @override
  Future<FlashcardState> build(int deckId, String deckName) async {
    ref.onDispose(() {
      _audioPlayingTimer?.cancel();
    });
    return _loadInitialState(deckId: deckId, deckName: deckName);
  }

  Future<void> refresh() async {
    await _reloadForQuery(isRefresh: true);
  }

  Future<void> loadMore() async {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    if (currentState.isLoadingMore) {
      return;
    }
    if (!currentState.hasNext) {
      return;
    }
    final int requestVersion = _queryRequestVersion;
    state = AsyncData<FlashcardState>(
      currentState.copyWith(isLoadingMore: true, inlineErrorMessage: null),
    );
    final FlashcardQuery query = _toQuery(currentState);
    final Either<Failure, FlashcardPage> result = await _repository()
        .getFlashcards(query: query, page: currentState.page + 1);
    if (_isStale(requestVersion)) {
      return;
    }
    if (result.isLeft()) {
      final Failure failure = _resolveFailure(result);
      state = AsyncData<FlashcardState>(
        currentState.copyWith(
          isLoadingMore: false,
          inlineErrorMessage: failure.message,
        ),
      );
      return;
    }
    final FlashcardPage pageResult = result.getOrElse(_emptyPage);
    final List<FlashcardNode> mergedItems = <FlashcardNode>[
      ...currentState.items,
      ...pageResult.items,
    ];
    state = AsyncData<FlashcardState>(
      currentState.copyWith(
        items: mergedItems,
        page: pageResult.page,
        size: pageResult.size,
        totalElements: pageResult.totalElements,
        totalPages: pageResult.totalPages,
        hasNext: pageResult.hasNext,
        isLoadingMore: false,
        inlineErrorMessage: null,
      ),
    );
  }

  Future<void> updateSearchQuery(String value) async {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    final String normalized = StringUtils.normalizeName(value);
    if (currentState.searchQuery == normalized) {
      return;
    }
    state = AsyncData<FlashcardState>(
      currentState.copyWith(
        searchQuery: normalized,
        previewIndex: FlashcardStateConst.firstPage,
        isStudyCardFlipped: false,
      ),
    );
    await _reloadForQuery(isRefresh: false);
  }

  Future<void> setSortBy(FlashcardSortBy sortBy) async {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    if (currentState.sortBy != sortBy) {
      final FlashcardSortDirection nextDirection =
          _resolveSortDirectionOnSortByChange(sortBy: sortBy);
      state = AsyncData<FlashcardState>(
        currentState.copyWith(sortBy: sortBy, sortDirection: nextDirection),
      );
      await _reloadForQuery(isRefresh: false);
      return;
    }
    if (sortBy != FlashcardSortBy.frontText) {
      return;
    }
    final FlashcardSortDirection toggledDirection = _toggleSortDirection(
      currentState.sortDirection,
    );
    state = AsyncData<FlashcardState>(
      currentState.copyWith(sortDirection: toggledDirection),
    );
    await _reloadForQuery(isRefresh: false);
  }

  Future<void> setSortDirection(FlashcardSortDirection direction) async {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    if (currentState.sortDirection == direction) {
      return;
    }
    state = AsyncData<FlashcardState>(
      currentState.copyWith(sortDirection: direction),
    );
    await _reloadForQuery(isRefresh: false);
  }

  Future<void> applySort({
    required FlashcardSortBy sortBy,
    required FlashcardSortDirection direction,
  }) async {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    if (currentState.sortBy == sortBy &&
        currentState.sortDirection == direction) {
      return;
    }
    state = AsyncData<FlashcardState>(
      currentState.copyWith(sortBy: sortBy, sortDirection: direction),
    );
    await _reloadForQuery(isRefresh: false);
  }

  void toggleSearchVisibility() {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    state = AsyncData<FlashcardState>(
      currentState.copyWith(isSearchVisible: !currentState.isSearchVisible),
    );
  }

  void setPreviewIndex(int index) {
    if (index < FlashcardStateConst.firstPage) {
      return;
    }
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    if (currentState.previewIndex == index) {
      return;
    }
    state = AsyncData<FlashcardState>(
      currentState.copyWith(previewIndex: index, isStudyCardFlipped: false),
    );
  }

  void toggleStar(int flashcardId) {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    final List<int> nextIds = <int>[...currentState.starredFlashcardIds];
    if (nextIds.contains(flashcardId)) {
      nextIds.remove(flashcardId);
      state = AsyncData<FlashcardState>(
        currentState.copyWith(starredFlashcardIds: nextIds),
      );
      return;
    }
    nextIds.add(flashcardId);
    state = AsyncData<FlashcardState>(
      currentState.copyWith(starredFlashcardIds: nextIds),
    );
  }

  void toggleStudyCardFlipped() {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    state = AsyncData<FlashcardState>(
      currentState.copyWith(
        isStudyCardFlipped: !currentState.isStudyCardFlipped,
      ),
    );
  }

  void resetStudyCardFlipped() {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    if (!currentState.isStudyCardFlipped) {
      return;
    }
    state = AsyncData<FlashcardState>(
      currentState.copyWith(isStudyCardFlipped: false),
    );
  }

  void startAudioPlayingIndicator(int flashcardId) {
    if (flashcardId <= FlashcardStateConst.firstPage) {
      return;
    }
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    _audioPlayingTimer?.cancel();
    state = AsyncData<FlashcardState>(
      currentState.copyWith(playingFlashcardId: flashcardId),
    );
    _audioPlayingTimer = Timer(
      const Duration(
        milliseconds: FlashcardDomainConst.audioPlayingIndicatorDurationMs,
      ),
      clearAudioPlayingIndicator,
    );
  }

  void clearAudioPlayingIndicator() {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    if (currentState.playingFlashcardId == null) {
      return;
    }
    state = AsyncData<FlashcardState>(
      currentState.copyWith(playingFlashcardId: null),
    );
  }

  Future<FlashcardSubmitResult> createFlashcard(
    FlashcardUpsertInput input,
  ) async {
    final FlashcardUpsertInput normalizedInput = _normalizeInput(input);
    final String? validationMessage = _validateInput(normalizedInput);
    if (validationMessage != null) {
      return FlashcardSubmitResult.failure(formErrorMessage: validationMessage);
    }
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return const FlashcardSubmitResult.failure();
    }
    state = AsyncData<FlashcardState>(
      currentState.copyWith(
        mutationType: FlashcardMutationType.creating,
        inlineErrorMessage: null,
      ),
    );
    final Either<Failure, FlashcardNode> result = await _repository()
        .createFlashcard(deckId: currentState.deckId, input: normalizedInput);
    if (result.isLeft()) {
      final Failure failure = _resolveFailure(result);
      state = AsyncData<FlashcardState>(
        currentState.copyWith(
          mutationType: FlashcardMutationType.none,
          inlineErrorMessage: failure.message,
        ),
      );
      return FlashcardSubmitResult.failure(formErrorMessage: failure.message);
    }
    await _reloadForQuery(isRefresh: true);
    return const FlashcardSubmitResult.success();
  }

  Future<FlashcardSubmitResult> updateFlashcard({
    required int flashcardId,
    required FlashcardUpsertInput input,
  }) async {
    final FlashcardUpsertInput normalizedInput = _normalizeInput(input);
    final String? validationMessage = _validateInput(normalizedInput);
    if (validationMessage != null) {
      return FlashcardSubmitResult.failure(formErrorMessage: validationMessage);
    }
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return const FlashcardSubmitResult.failure();
    }
    final List<FlashcardNode> optimisticItems = currentState.items
        .map((FlashcardNode item) {
          if (item.id != flashcardId) {
            return item;
          }
          return item.copyWith(
            frontText: normalizedInput.frontText,
            backText: normalizedInput.backText,
            frontLangCode: normalizedInput.frontLangCode,
            backLangCode: normalizedInput.backLangCode,
            updatedAt: DateTime.now().toUtc(),
          );
        })
        .toList(growable: false);
    final FlashcardState snapshot = currentState;
    state = AsyncData<FlashcardState>(
      currentState.copyWith(
        items: optimisticItems,
        mutationType: FlashcardMutationType.updating,
        inlineErrorMessage: null,
      ),
    );
    final Either<Failure, FlashcardNode> result = await _repository()
        .updateFlashcard(
          deckId: currentState.deckId,
          flashcardId: flashcardId,
          input: normalizedInput,
        );
    if (result.isLeft()) {
      final Failure failure = _resolveFailure(result);
      state = AsyncData<FlashcardState>(
        snapshot.copyWith(
          mutationType: FlashcardMutationType.none,
          inlineErrorMessage: failure.message,
        ),
      );
      return FlashcardSubmitResult.failure(formErrorMessage: failure.message);
    }
    await _reloadForQuery(isRefresh: true);
    return const FlashcardSubmitResult.success();
  }

  Future<bool> deleteFlashcard(int flashcardId) async {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return false;
    }
    final List<FlashcardNode> optimisticItems = currentState.items
        .where((FlashcardNode item) {
          return item.id != flashcardId;
        })
        .toList(growable: false);
    final FlashcardState snapshot = currentState;
    state = AsyncData<FlashcardState>(
      currentState.copyWith(
        items: optimisticItems,
        mutationType: FlashcardMutationType.deleting,
        inlineErrorMessage: null,
      ),
    );
    final Either<Failure, Unit> result = await _repository().deleteFlashcard(
      deckId: currentState.deckId,
      flashcardId: flashcardId,
    );
    if (result.isLeft()) {
      final Failure failure = _resolveFailure(result);
      state = AsyncData<FlashcardState>(
        snapshot.copyWith(
          mutationType: FlashcardMutationType.none,
          inlineErrorMessage: failure.message,
        ),
      );
      return false;
    }
    await _reloadForQuery(isRefresh: true);
    return true;
  }

  Future<FlashcardState> _loadInitialState({
    required int deckId,
    required String deckName,
  }) async {
    final FlashcardQuery query = FlashcardQuery.initial(deckId: deckId);
    final Either<Failure, FlashcardPage> result = await _repository()
        .getFlashcards(query: query, page: FlashcardStateConst.firstPage);
    if (result.isLeft()) {
      throw _resolveFailure(result);
    }
    final FlashcardPage page = result.getOrElse(_emptyPage);
    return FlashcardState(
      deckId: deckId,
      deckName: deckName,
      searchQuery: query.searchQuery,
      sortBy: query.sortBy,
      sortDirection: query.sortDirection,
      items: page.items,
      page: page.page,
      size: page.size,
      totalElements: page.totalElements,
      totalPages: page.totalPages,
      hasNext: page.hasNext,
      isLoadingMore: false,
      isRefreshing: false,
      isSearchVisible: false,
      previewIndex: FlashcardStateConst.firstPage,
      starredFlashcardIds: const <int>[],
      playingFlashcardId: null,
      isStudyCardFlipped: false,
      mutationType: FlashcardMutationType.none,
      inlineErrorMessage: null,
    );
  }

  Future<void> _reloadForQuery({required bool isRefresh}) async {
    final FlashcardState? currentState = _currentStateOrNull();
    if (currentState == null) {
      return;
    }
    final int requestVersion = _nextQueryRequestVersion();
    state = AsyncData<FlashcardState>(
      currentState.copyWith(
        page: FlashcardStateConst.firstPage,
        isLoadingMore: false,
        isRefreshing: true,
        mutationType: FlashcardMutationType.none,
        inlineErrorMessage: null,
      ),
    );
    final FlashcardQuery query = _toQuery(currentState);
    final Either<Failure, FlashcardPage> result = await _repository()
        .getFlashcards(query: query, page: FlashcardStateConst.firstPage);
    if (_isStale(requestVersion)) {
      return;
    }
    if (result.isLeft()) {
      final Failure failure = _resolveFailure(result);
      final FlashcardState latestState = _currentStateOrNull() ?? currentState;
      state = AsyncData<FlashcardState>(
        latestState.copyWith(
          isRefreshing: false,
          mutationType: FlashcardMutationType.none,
          inlineErrorMessage: failure.message,
        ),
      );
      return;
    }
    final FlashcardPage pageResult = result.getOrElse(_emptyPage);
    final FlashcardState latestState = _currentStateOrNull() ?? currentState;
    state = AsyncData<FlashcardState>(
      latestState.copyWith(
        items: pageResult.items,
        page: pageResult.page,
        size: pageResult.size,
        totalElements: pageResult.totalElements,
        totalPages: pageResult.totalPages,
        hasNext: pageResult.hasNext,
        isLoadingMore: false,
        isRefreshing: false,
        mutationType: FlashcardMutationType.none,
        inlineErrorMessage: null,
      ),
    );
    if (!isRefresh) {
      return;
    }
  }

  FlashcardRepository _repository() {
    return ref.read(flashcardRepositoryProvider);
  }

  FlashcardState? _currentStateOrNull() {
    return state.asData?.value;
  }

  FlashcardQuery _toQuery(FlashcardState value) {
    return FlashcardQuery(
      deckId: value.deckId,
      pageSize: value.size,
      searchQuery: value.searchQuery,
      sortBy: value.sortBy,
      sortDirection: value.sortDirection,
    );
  }

  FlashcardSortDirection _resolveSortDirectionOnSortByChange({
    required FlashcardSortBy sortBy,
  }) {
    if (sortBy == FlashcardSortBy.frontText) {
      return FlashcardSortDirection.asc;
    }
    return FlashcardSortDirection.desc;
  }

  FlashcardSortDirection _toggleSortDirection(FlashcardSortDirection value) {
    if (value == FlashcardSortDirection.asc) {
      return FlashcardSortDirection.desc;
    }
    return FlashcardSortDirection.asc;
  }

  FlashcardUpsertInput _normalizeInput(FlashcardUpsertInput input) {
    return FlashcardUpsertInput(
      frontText: StringUtils.normalizeName(input.frontText),
      backText: StringUtils.normalizeName(input.backText),
      frontLangCode: input.frontLangCode,
      backLangCode: input.backLangCode,
    );
  }

  String? _validateInput(FlashcardUpsertInput input) {
    if (input.frontText.length < FlashcardDomainConst.frontTextMinLength) {
      return FlashcardProviderConst.frontTextRequiredMessage;
    }
    if (input.frontText.length > FlashcardDomainConst.frontTextMaxLength) {
      return FlashcardProviderConst.frontTextMaxLengthMessage;
    }
    if (input.backText.length < FlashcardDomainConst.backTextMinLength) {
      return FlashcardProviderConst.backTextRequiredMessage;
    }
    if (input.backText.length > FlashcardDomainConst.backTextMaxLength) {
      return FlashcardProviderConst.backTextMaxLengthMessage;
    }
    return null;
  }

  int _nextQueryRequestVersion() {
    _queryRequestVersion++;
    return _queryRequestVersion;
  }

  bool _isStale(int requestVersion) {
    return requestVersion != _queryRequestVersion;
  }

  Failure _resolveFailure<T>(Either<Failure, T> result) {
    return result.swap().getOrElse(
      () => const Failure.unknown(
        message: FlashcardProviderConst.unknownErrorMessage,
      ),
    );
  }

  FlashcardPage _emptyPage() {
    return const FlashcardPage(
      items: <FlashcardNode>[],
      page: FlashcardStateConst.firstPage,
      size: FlashcardStateConst.pageSize,
      totalElements: 0,
      totalPages: 0,
      hasNext: false,
      hasPrevious: false,
    );
  }
}
