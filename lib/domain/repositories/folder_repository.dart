import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/folder_models.dart';

abstract class FolderRepository {
  Future<Either<Failure, List<FolderNode>>> getFolders({
    required int? parentId,
    required String searchQuery,
    required String sortBy,
    required String sortType,
    required int page,
    required int size,
  });

  Future<Either<Failure, Unit>> createFolder({
    required FolderUpsertInput input,
  });

  Future<Either<Failure, Unit>> updateFolder({
    required int folderId,
    required FolderUpsertInput input,
  });

  Future<Either<Failure, Unit>> deleteFolder({required int folderId});
}
