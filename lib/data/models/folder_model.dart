import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/folder_models.dart';

part 'folder_model.freezed.dart';
part 'folder_model.g.dart';

const int folderDataDefaultId = 0;
const String folderDataDefaultName = '';
const int folderDataDefaultDepth = 0;
const int folderDataDefaultChildFolderCount = 0;

@freezed
abstract class FolderModel with _$FolderModel {
  const factory FolderModel({
    @Default(folderDataDefaultId) int id,
    @Default(folderDataDefaultName) String name,
    int? parentId,
    @Default(folderDataDefaultDepth) int depth,
    @Default(folderDataDefaultChildFolderCount) int childFolderCount,
  }) = _FolderModel;

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);
}

extension FolderModelMapper on FolderModel {
  FolderNode toEntity() {
    return FolderNode(
      id: id,
      name: name,
      parentId: parentId,
      depth: depth,
      childFolderCount: childFolderCount,
    );
  }
}
