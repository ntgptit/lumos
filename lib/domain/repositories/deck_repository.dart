import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/deck_models.dart';

abstract class DeckRepository {
  Future<Either<Failure, List<DeckNode>>> getDecks({
    required int folderId,
    required String searchQuery,
    required String sortBy,
    required String sortType,
    required int page,
    required int size,
  });

  Future<Either<Failure, Unit>> createDeck({
    required int folderId,
    required DeckUpsertInput input,
  });

  Future<Either<Failure, Unit>> updateDeck({
    required int folderId,
    required int deckId,
    required DeckUpsertInput input,
  });

  Future<Either<Failure, Unit>> deleteDeck({
    required int folderId,
    required int deckId,
  });
}
