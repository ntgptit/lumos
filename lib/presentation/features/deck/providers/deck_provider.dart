import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../data/repositories/deck_repository_impl.dart';
import '../../../../domain/entities/deck_models.dart';
import '../../../../domain/repositories/deck_repository.dart';
import 'states/deck_state.dart';

part 'deck_provider.g.dart';

abstract final class DeckProviderConst {
  DeckProviderConst._();

  static const String unknownErrorMessage = 'Unknown error';
}

class DeckSubmitResult {
  const DeckSubmitResult._({required this.isSuccess, this.nameErrorMessage});

  const DeckSubmitResult.success() : this._(isSuccess: true);

  const DeckSubmitResult.failure({String? nameErrorMessage})
    : this._(isSuccess: false, nameErrorMessage: nameErrorMessage);

  final bool isSuccess;
  final String? nameErrorMessage;
}

@Riverpod(keepAlive: true)
class DeckAsyncController extends _$DeckAsyncController {
  @override
  Future<DeckState> build(
    int folderId,
    String searchQuery,
    String sortType,
  ) async {
    return _loadState(
      folderId: folderId,
      searchQuery: searchQuery,
      sortType: sortType,
    );
  }

  Future<void> refresh() async {
    final DeckState nextState = await _loadState(
      folderId: folderId,
      searchQuery: searchQuery,
      sortType: sortType,
    );
    state = AsyncData<DeckState>(nextState);
  }

  Future<DeckSubmitResult> createDeck(DeckUpsertInput input) {
    return _runMutation(
      mutationType: DeckMutationType.creating,
      mutation: (DeckRepository repository) {
        return repository.createDeck(folderId: folderId, input: input);
      },
    );
  }

  Future<DeckSubmitResult> updateDeck({
    required int deckId,
    required DeckUpsertInput input,
  }) {
    return _runMutation(
      mutationType: DeckMutationType.updating,
      mutation: (DeckRepository repository) {
        return repository.updateDeck(
          folderId: folderId,
          deckId: deckId,
          input: input,
        );
      },
    );
  }

  Future<bool> deleteDeck(int deckId) async {
    final DeckSubmitResult result = await _runMutation(
      mutationType: DeckMutationType.deleting,
      mutation: (DeckRepository repository) {
        return repository.deleteDeck(folderId: folderId, deckId: deckId);
      },
    );
    return result.isSuccess;
  }

  Future<DeckSubmitResult> _runMutation({
    required DeckMutationType mutationType,
    required Future<Either<Failure, Unit>> Function(DeckRepository repository)
    mutation,
  }) async {
    final DeckState current =
        state.asData?.value ??
        await _loadState(
          folderId: folderId,
          searchQuery: searchQuery,
          sortType: sortType,
        );
    state = AsyncData<DeckState>(
      current.copyWith(mutationType: mutationType, inlineErrorMessage: null),
    );
    final DeckRepository repository = ref.read(deckRepositoryProvider);
    final Either<Failure, Unit> result = await mutation(repository);
    if (result.isLeft()) {
      final Failure failure = result.swap().getOrElse(
        () => const Failure.unknown(
          message: DeckProviderConst.unknownErrorMessage,
        ),
      );
      final String? nameErrorMessage = _resolveNameErrorMessage(
        mutationType: mutationType,
        failure: failure,
      );
      final String? inlineErrorMessage = _resolveInlineErrorMessage(
        mutationType: mutationType,
        failure: failure,
        nameErrorMessage: nameErrorMessage,
      );
      state = AsyncData<DeckState>(
        current.copyWith(
          mutationType: DeckMutationType.none,
          inlineErrorMessage: inlineErrorMessage,
        ),
      );
      return DeckSubmitResult.failure(nameErrorMessage: nameErrorMessage);
    }
    try {
      final DeckState nextState = await _loadState(
        folderId: folderId,
        searchQuery: searchQuery,
        sortType: sortType,
      );
      state = AsyncData<DeckState>(nextState);
      return const DeckSubmitResult.success();
    } catch (error, stackTrace) {
      state = AsyncError<DeckState>(error, stackTrace);
      return const DeckSubmitResult.failure();
    }
  }

  Future<DeckState> _loadState({
    required int folderId,
    required String searchQuery,
    required String sortType,
  }) async {
    final DeckRepository repository = ref.read(deckRepositoryProvider);
    final Either<Failure, List<DeckNode>> result = await repository.getDecks(
      folderId: folderId,
      searchQuery: searchQuery,
      sortBy: DeckStateConst.sortByName,
      sortType: sortType,
      page: DeckStateConst.firstPage,
      size: DeckStateConst.pageSize,
    );
    if (result.isLeft()) {
      final Failure failure = result.swap().getOrElse(
        () => const Failure.unknown(
          message: DeckProviderConst.unknownErrorMessage,
        ),
      );
      throw failure;
    }
    final List<DeckNode> decks = result.getOrElse(() => <DeckNode>[]);
    return DeckState(
      folderId: folderId,
      searchQuery: searchQuery,
      decks: decks,
      mutationType: DeckMutationType.none,
      inlineErrorMessage: null,
    );
  }

  String? _resolveNameErrorMessage({
    required DeckMutationType mutationType,
    required Failure failure,
  }) {
    if (mutationType == DeckMutationType.deleting) {
      return null;
    }
    if (failure is ValidationFailure) {
      return failure.message;
    }
    return null;
  }

  String? _resolveInlineErrorMessage({
    required DeckMutationType mutationType,
    required Failure failure,
    required String? nameErrorMessage,
  }) {
    if (mutationType == DeckMutationType.deleting) {
      return failure.message;
    }
    if (nameErrorMessage != null) {
      return null;
    }
    return failure.message;
  }
}
