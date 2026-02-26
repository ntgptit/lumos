import 'package:flutter/foundation.dart';

@immutable
class FolderNode {
  const FolderNode({
    required this.id,
    required this.name,
    required this.parentId,
    required this.depth,
  });

  final int id;
  final String name;
  final int? parentId;
  final int depth;
}

@immutable
class BreadcrumbNode {
  const BreadcrumbNode({required this.id, required this.name});

  final int id;
  final String name;
}
