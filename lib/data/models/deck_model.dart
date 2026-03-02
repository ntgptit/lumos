import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/deck_models.dart';

part 'deck_model.freezed.dart';
part 'deck_model.g.dart';

const int deckDataDefaultId = 0;
const int deckDataDefaultFolderId = 0;
const String deckDataDefaultName = '';
const String deckDataDefaultDescription = '';
const int deckDataDefaultFlashcardCount = 0;

@freezed
abstract class DeckModel with _$DeckModel {
  const factory DeckModel({
    @Default(deckDataDefaultId) int id,
    @Default(deckDataDefaultFolderId) int folderId,
    @Default(deckDataDefaultName) String name,
    @Default(deckDataDefaultDescription) String description,
    @Default(deckDataDefaultFlashcardCount) int flashcardCount,
  }) = _DeckModel;

  factory DeckModel.fromJson(Map<String, dynamic> json) =>
      _$DeckModelFromJson(json);
}

extension DeckModelMapper on DeckModel {
  DeckNode toEntity() {
    return DeckNode(
      id: id,
      folderId: folderId,
      name: name,
      description: description,
      flashcardCount: flashcardCount,
    );
  }
}
