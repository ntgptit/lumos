import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/error/error_mapper.dart';
import '../../core/error/failures.dart';
import '../../core/network/providers/network_providers.dart';
import '../../core/utils/string_utils.dart';
import '../../domain/entities/folder_models.dart';
import '../../domain/repositories/folder_repository.dart';
import '../models/folder_model.dart';

part 'folder_repository_impl.g.dart';

abstract final class FolderRepositoryImplConst {
  FolderRepositoryImplConst._();

  static const String foldersPath = '/api/v1/folders';
  static const String pageQueryKey = 'page';
  static const String sizeQueryKey = 'size';
  static const String parentIdQueryKey = 'parentId';
  static const String searchQueryKey = 'searchQuery';
  static const String sortByQueryKey = 'sortBy';
  static const String sortTypeQueryKey = 'sortType';
  static const String nameField = 'name';
  static const String parentIdField = 'parentId';
  static const String emptyValue = '';
  static const String folderNameRequiredMessage = 'Folder name is required.';
  static const String folderNameMaxLengthMessage =
      'Folder name must be at most 120 characters.';
  static const String folderNameInvalidMessage = 'Folder name is invalid.';
  static const String messageField = 'message';
  static const String fieldErrorsField = 'fieldErrors';
  static const String nameFieldErrorKey = 'name';
  static const int folderNameMaxLength = 120;
  static const int badRequestStatusCode = 400;
  static const int conflictStatusCode = 409;
  static const int unprocessableEntityStatusCode = 422;
}

class DioFolderRepository implements FolderRepository {
  const DioFolderRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Either<Failure, List<FolderNode>>> getFolders({
    required int? parentId,
    required String searchQuery,
    required String sortBy,
    required String sortType,
    required int page,
    required int size,
  }) async {
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      FolderRepositoryImplConst.pageQueryKey: page,
      FolderRepositoryImplConst.sizeQueryKey: size,
      FolderRepositoryImplConst.searchQueryKey: searchQuery,
      FolderRepositoryImplConst.sortByQueryKey: sortBy,
      FolderRepositoryImplConst.sortTypeQueryKey: sortType,
    };
    if (parentId != null) {
      queryParameters[FolderRepositoryImplConst.parentIdQueryKey] = parentId;
    }
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        FolderRepositoryImplConst.foldersPath,
        queryParameters: queryParameters,
      );
      final List<Map<String, dynamic>> folderJsonList = _castList(
        response.data,
      );
      final List<FolderNode> folders = folderJsonList
          .map(FolderModel.fromJson)
          .map((FolderModel model) => model.toEntity())
          .toList(growable: false);
      return right<Failure, List<FolderNode>>(folders);
    } on Object catch (error) {
      return left<Failure, List<FolderNode>>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createFolder({
    required String name,
    required int? parentId,
  }) async {
    final String normalizedName = _normalizeName(name);
    if (normalizedName == FolderRepositoryImplConst.emptyValue) {
      return left<Failure, Unit>(
        const Failure.validation(
          message: FolderRepositoryImplConst.folderNameRequiredMessage,
        ),
      );
    }
    if (normalizedName.length > FolderRepositoryImplConst.folderNameMaxLength) {
      return left<Failure, Unit>(
        const Failure.validation(
          message: FolderRepositoryImplConst.folderNameMaxLengthMessage,
        ),
      );
    }
    try {
      await _dio.post<dynamic>(
        FolderRepositoryImplConst.foldersPath,
        data: <String, dynamic>{
          FolderRepositoryImplConst.nameField: normalizedName,
          FolderRepositoryImplConst.parentIdField: parentId,
        },
      );
      return right<Failure, Unit>(unit);
    } on Object catch (error) {
      return left<Failure, Unit>(_mapMutationFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> renameFolder({
    required int folderId,
    required String name,
  }) async {
    final String normalizedName = _normalizeName(name);
    if (normalizedName == FolderRepositoryImplConst.emptyValue) {
      return left<Failure, Unit>(
        const Failure.validation(
          message: FolderRepositoryImplConst.folderNameRequiredMessage,
        ),
      );
    }
    if (normalizedName.length > FolderRepositoryImplConst.folderNameMaxLength) {
      return left<Failure, Unit>(
        const Failure.validation(
          message: FolderRepositoryImplConst.folderNameMaxLengthMessage,
        ),
      );
    }
    try {
      await _dio.patch<dynamic>(
        '${_folderPath(folderId: folderId)}/rename',
        data: <String, dynamic>{
          FolderRepositoryImplConst.nameField: normalizedName,
        },
      );
      return right<Failure, Unit>(unit);
    } on Object catch (error) {
      return left<Failure, Unit>(_mapMutationFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteFolder({required int folderId}) async {
    try {
      await _dio.delete<dynamic>(_folderPath(folderId: folderId));
      return right<Failure, Unit>(unit);
    } on Object catch (error) {
      return left<Failure, Unit>(error.toFailure());
    }
  }

  String _normalizeName(String rawValue) {
    return StringUtils.normalizeName(rawValue);
  }

  String _folderPath({required int folderId}) {
    return '${FolderRepositoryImplConst.foldersPath}/$folderId';
  }

  Failure _mapMutationFailure(Object error) {
    if (error is! DioException) {
      return error.toFailure();
    }
    final int? statusCode = error.response?.statusCode;
    if (!_isValidationStatus(statusCode)) {
      return error.toFailure();
    }
    return Failure.validation(
      message: _extractValidationMessage(error.response?.data),
      statusCode: statusCode,
    );
  }

  bool _isValidationStatus(int? statusCode) {
    if (statusCode == FolderRepositoryImplConst.badRequestStatusCode) {
      return true;
    }
    if (statusCode == FolderRepositoryImplConst.conflictStatusCode) {
      return true;
    }
    if (statusCode == FolderRepositoryImplConst.unprocessableEntityStatusCode) {
      return true;
    }
    return false;
  }

  String _extractValidationMessage(dynamic rawValue) {
    final Map<String, dynamic> payload = _castMap(rawValue);
    if (payload.isEmpty) {
      return FolderRepositoryImplConst.folderNameInvalidMessage;
    }
    final Map<String, dynamic> fieldErrors = _castMap(
      payload[FolderRepositoryImplConst.fieldErrorsField],
    );
    final String? fieldNameError = _readString(
      fieldErrors[FolderRepositoryImplConst.nameFieldErrorKey],
    );
    if (fieldNameError != null) {
      return fieldNameError;
    }
    final String? message = _readString(
      payload[FolderRepositoryImplConst.messageField],
    );
    if (message != null) {
      return message;
    }
    return FolderRepositoryImplConst.folderNameInvalidMessage;
  }

  String? _readString(dynamic rawValue) {
    if (rawValue is! String) {
      return null;
    }
    final String normalized = StringUtils.normalizeName(rawValue);
    if (normalized == FolderRepositoryImplConst.emptyValue) {
      return null;
    }
    return normalized;
  }

  Map<String, dynamic> _castMap(dynamic rawValue) {
    if (rawValue is Map<dynamic, dynamic>) {
      return rawValue.cast<String, dynamic>();
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _castList(dynamic rawValue) {
    if (rawValue is! List<dynamic>) {
      return <Map<String, dynamic>>[];
    }
    return rawValue.map(_castMap).toList(growable: false);
  }
}

@Riverpod(keepAlive: true)
FolderRepository folderRepository(Ref ref) {
  final Dio dio = ref.watch(dioClientProvider);
  return DioFolderRepository(dio: dio);
}
