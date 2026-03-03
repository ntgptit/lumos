import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/flashcard_models.dart';

abstract class FlashcardRepository {
  Future<Either<Failure, FlashcardPage>> getFlashcards({
    required FlashcardQuery query,
    required int page,
  });

  Future<Either<Failure, FlashcardNode>> createFlashcard({
    required int deckId,
    required FlashcardUpsertInput input,
  });

  Future<Either<Failure, FlashcardNode>> updateFlashcard({
    required int deckId,
    required int flashcardId,
    required FlashcardUpsertInput input,
  });

  Future<Either<Failure, Unit>> deleteFlashcard({
    required int deckId,
    required int flashcardId,
  });
}
