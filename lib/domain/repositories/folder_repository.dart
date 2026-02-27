import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/folder_models.dart';

abstract class FolderRepository {
  Future<Either<Failure, List<FolderNode>>> getFolders();

  Future<Either<Failure, List<BreadcrumbNode>>> getBreadcrumb({
    required int folderId,
  });

  Future<Either<Failure, Unit>> createFolder({
    required String name,
    required int? parentId,
  });

  Future<Either<Failure, Unit>> renameFolder({
    required int folderId,
    required String name,
  });

  Future<Either<Failure, Unit>> deleteFolder({required int folderId});
}
