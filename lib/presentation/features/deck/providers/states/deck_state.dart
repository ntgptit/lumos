import 'package:lumos/core/enums/sort_direction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/entities/deck_models.dart';

part 'deck_state.freezed.dart';

abstract final class DeckStateConst {
  DeckStateConst._();

  static const String sortByName = 'NAME';
  static const SortDirection defaultSortDirection = SortDirection.asc;
  static const int firstPage = 0;
  static const int pageSize = 50;
  static const int deckNameMinLength = DeckDomainConst.nameMinLength;
  static const int deckNameMaxLength = DeckDomainConst.nameMaxLength;
  static const int deckDescriptionMaxLength =
      DeckDomainConst.descriptionMaxLength;
}

enum DeckMutationType { none, creating, updating, deleting }

@freezed
abstract class DeckState with _$DeckState {
  const DeckState._();

  const factory DeckState({
    required int folderId,
    required String searchQuery,
    required List<DeckNode> decks,
    required DeckMutationType mutationType,
    required String? inlineErrorMessage,
  }) = _DeckState;

  bool get isMutating {
    return mutationType != DeckMutationType.none;
  }
}
