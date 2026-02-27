import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/error/error_mapper.dart';
import '../../core/error/failures.dart';
import '../../core/network/providers/network_providers.dart';
import '../../core/utils/string_utils.dart';
import '../../domain/entities/folder_models.dart';

part 'folder_repository.g.dart';

class FolderRepositoryConst {
  const FolderRepositoryConst._();

  static const int maxFetchSize = 500;
}

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

class DioFolderRepository implements FolderRepository {
  const DioFolderRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Either<Failure, List<FolderNode>>> getFolders() async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        '/api/v1/folders',
        queryParameters: <String, dynamic>{
          'page': 0,
          'size': FolderRepositoryConst.maxFetchSize,
          'sort': 'name,asc',
        },
      );
      final Map<String, dynamic> body = _castMap(response.data);
      final List<dynamic> content = _castList(body['content']);
      final List<FolderNode> folders = content
          .whereType<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> item) {
            final Map<String, dynamic> json = item.cast<String, dynamic>();
            final int id = (json['id'] as num?)?.toInt() ?? 0;
            final String name = (json['name'] as String?) ?? '';
            final int? parentId = (json['parentId'] as num?)?.toInt();
            final int depth = (json['depth'] as num?)?.toInt() ?? 0;
            return FolderNode(
              id: id,
              name: name,
              parentId: parentId,
              depth: depth,
            );
          })
          .toList();
      return right(folders);
    } on Object catch (error) {
      return left(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<BreadcrumbNode>>> getBreadcrumb({
    required int folderId,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        '/api/v1/folders/$folderId/breadcrumb',
      );
      final Map<String, dynamic> body = _castMap(response.data);
      final List<dynamic> content = _castList(body['items']);
      final List<BreadcrumbNode> breadcrumbs = content
          .whereType<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> item) {
            final Map<String, dynamic> json = item.cast<String, dynamic>();
            final int id = (json['id'] as num?)?.toInt() ?? 0;
            final String name = (json['name'] as String?) ?? '';
            return BreadcrumbNode(id: id, name: name);
          })
          .toList();
      return right(breadcrumbs);
    } on Object catch (error) {
      return left(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createFolder({
    required String name,
    required int? parentId,
  }) async {
    final String normalizedName = _normalizeName(name);
    if (normalizedName.isEmpty) {
      return left(
        const Failure.validation(message: 'Folder name is required.'),
      );
    }
    try {
      await _dio.post<dynamic>(
        '/api/v1/folders',
        data: <String, dynamic>{'name': normalizedName, 'parentId': parentId},
      );
      return right(unit);
    } on Object catch (error) {
      return left(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> renameFolder({
    required int folderId,
    required String name,
  }) async {
    final String normalizedName = _normalizeName(name);
    if (normalizedName.isEmpty) {
      return left(
        const Failure.validation(message: 'Folder name is required.'),
      );
    }
    try {
      await _dio.patch<dynamic>(
        '/api/v1/folders/$folderId/rename',
        data: <String, dynamic>{'name': normalizedName},
      );
      return right(unit);
    } on Object catch (error) {
      return left(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteFolder({required int folderId}) async {
    try {
      await _dio.delete<dynamic>('/api/v1/folders/$folderId');
      return right(unit);
    } on Object catch (error) {
      return left(error.toFailure());
    }
  }

  String _normalizeName(String rawValue) {
    return StringUtils.normalizeName(rawValue);
  }

  Map<String, dynamic> _castMap(dynamic rawValue) {
    if (rawValue is Map<dynamic, dynamic>) {
      return rawValue.cast<String, dynamic>();
    }
    return <String, dynamic>{};
  }

  List<dynamic> _castList(dynamic rawValue) {
    if (rawValue is List<dynamic>) {
      return rawValue;
    }
    return <dynamic>[];
  }
}

@Riverpod(keepAlive: true)
FolderRepository folderRepository(Ref ref) {
  final Dio dio = ref.watch(dioClientProvider);
  return DioFolderRepository(dio: dio);
}
