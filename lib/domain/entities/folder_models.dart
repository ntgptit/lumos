import 'package:flutter/foundation.dart';

@immutable
class FolderNode {
  const FolderNode({
    required this.id,
    required this.name,
    required this.parentId,
    required this.depth,
    required this.childFolderCount,
  });

  final int id;
  final String name;
  final int? parentId;
  final int depth;
  final int childFolderCount;
}
