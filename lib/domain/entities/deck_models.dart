import 'package:flutter/foundation.dart';

@immutable
abstract final class DeckDomainConst {
  static const int nameMinLength = 1;
  static const int nameMaxLength = 120;
  static const int descriptionMaxLength = 400;
}

@immutable
class DeckNode {
  const DeckNode({
    required this.id,
    required this.folderId,
    required this.name,
    required this.description,
    required this.flashcardCount,
  });

  final int id;
  final int folderId;
  final String name;
  final String description;
  final int flashcardCount;
}

@immutable
class DeckUpsertInput {
  const DeckUpsertInput({required this.name, required this.description});

  final String name;
  final String description;

  DeckUpsertInput copyWith({String? name, String? description}) {
    return DeckUpsertInput(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  int get hashCode => Object.hash(name, description);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! DeckUpsertInput) {
      return false;
    }
    return other.name == name && other.description == description;
  }
}
