import 'package:flutter/foundation.dart';

@immutable
abstract final class FolderDomainConst {
  static const int nameMinLength = 1;
  static const int nameMaxLength = 120;
  static const int descriptionMaxLength = 400;
}

@immutable
class FolderNode {
  const FolderNode({
    required this.id,
    required this.name,
    required this.description,
    required this.parentId,
    required this.depth,
    required this.childFolderCount,
    required this.deckCount,
  });

  final int id;
  final String name;
  final String description;
  final int? parentId;
  final int depth;
  final int childFolderCount;
  final int deckCount;
}

@immutable
class FolderUpsertInput {
  static const Object _parentIdUnset = Object();

  const FolderUpsertInput({
    required this.name,
    required this.description,
    required this.parentId,
  });

  final String name;
  final String description;
  final int? parentId;

  FolderUpsertInput copyWith({
    String? name,
    String? description,
    Object? parentId = _parentIdUnset,
  }) {
    final int? resolvedParentId = identical(parentId, _parentIdUnset)
        ? this.parentId
        : parentId as int?;
    return FolderUpsertInput(
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: resolvedParentId,
    );
  }

  @override
  int get hashCode => Object.hash(name, description, parentId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! FolderUpsertInput) {
      return false;
    }
    return other.name == name &&
        other.description == description &&
        other.parentId == parentId;
  }
}
