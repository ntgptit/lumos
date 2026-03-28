import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumos/core/errors/error_mapper.dart';
import 'package:lumos/core/errors/failures.dart';
import '../../core/network/providers/network_providers.dart';
import '../../core/utils/string_utils.dart';
import '../../domain/entities/deck_models.dart';
import '../../domain/repositories/deck_repository.dart';
import '../models/deck_model.dart';

part 'deck_repository_impl.g.dart';

abstract final class DeckRepositoryImplConst {
  DeckRepositoryImplConst._();

  static const String foldersPath = '/api/v1/folders';
  static const String decksPathSegment = 'decks';
  static const String pageQueryKey = 'page';
  static const String sizeQueryKey = 'size';
  static const String searchQueryKey = 'searchQuery';
  static const String sortByQueryKey = 'sortBy';
  static const String sortTypeQueryKey = 'sortType';
  static const String nameField = 'name';
  static const String descriptionField = 'description';
  static const String messageField = 'message';
  static const String fieldErrorsField = 'fieldErrors';
  static const String nameFieldErrorKey = 'name';
  static const String emptyValue = '';
  static const String deckNameRequiredMessage = 'Deck name is required.';
  static const String deckNameMaxLengthMessage =
      'Deck name must be at most ${DeckDomainConst.nameMaxLength} characters.';
  static const String deckDescriptionMaxLengthMessage =
      'Deck description must be at most ${DeckDomainConst.descriptionMaxLength} characters.';
  static const String deckNameInvalidMessage = 'Deck name is invalid.';
  static const int badRequestStatusCode = 400;
  static const int conflictStatusCode = 409;
  static const int unprocessableEntityStatusCode = 422;
}

class DioDeckRepository implements DeckRepository {
  const DioDeckRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Either<Failure, List<DeckNode>>> getDecks({
    required int folderId,
    required String searchQuery,
    required String sortBy,
    required String sortType,
    required int page,
    required int size,
  }) async {
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      DeckRepositoryImplConst.pageQueryKey: page,
      DeckRepositoryImplConst.sizeQueryKey: size,
      DeckRepositoryImplConst.searchQueryKey: searchQuery,
      DeckRepositoryImplConst.sortByQueryKey: sortBy,
      DeckRepositoryImplConst.sortTypeQueryKey: sortType,
    };
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        _decksPath(folderId: folderId),
        queryParameters: queryParameters,
      );
      final List<Map<String, dynamic>> deckJsonList = _castList(response.data);
      final List<DeckNode> decks = deckJsonList
          .map(DeckModel.fromJson)
          .map((DeckModel model) => model.toEntity())
          .toList(growable: false);
      return right<Failure, List<DeckNode>>(decks);
    } on Object catch (error) {
      return left<Failure, List<DeckNode>>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createDeck({
    required int folderId,
    required DeckUpsertInput input,
  }) async {
    final DeckUpsertInput normalizedInput = _normalizeInput(input);
    final Failure? validationFailure = _validateInput(normalizedInput);
    if (validationFailure != null) {
      return left<Failure, Unit>(validationFailure);
    }
    try {
      await _dio.post<dynamic>(
        _decksPath(folderId: folderId),
        data: _toPayload(normalizedInput),
      );
      return right<Failure, Unit>(unit);
    } on Object catch (error) {
      return left<Failure, Unit>(_mapMutationFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateDeck({
    required int folderId,
    required int deckId,
    required DeckUpsertInput input,
  }) async {
    final DeckUpsertInput normalizedInput = _normalizeInput(input);
    final Failure? validationFailure = _validateInput(normalizedInput);
    if (validationFailure != null) {
      return left<Failure, Unit>(validationFailure);
    }
    try {
      await _dio.put<dynamic>(
        _deckPath(folderId: folderId, deckId: deckId),
        data: _toPayload(normalizedInput),
      );
      return right<Failure, Unit>(unit);
    } on Object catch (error) {
      return left<Failure, Unit>(_mapMutationFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDeck({
    required int folderId,
    required int deckId,
  }) async {
    try {
      await _dio.delete<dynamic>(_deckPath(folderId: folderId, deckId: deckId));
      return right<Failure, Unit>(unit);
    } on Object catch (error) {
      return left<Failure, Unit>(error.toFailure());
    }
  }

  DeckUpsertInput _normalizeInput(DeckUpsertInput input) {
    return DeckUpsertInput(
      name: StringUtils.normalizeName(input.name),
      description: StringUtils.normalizeText(input.description),
    );
  }

  Failure? _validateInput(DeckUpsertInput input) {
    if (input.name == DeckRepositoryImplConst.emptyValue) {
      return const Failure.validation(
        message: DeckRepositoryImplConst.deckNameRequiredMessage,
      );
    }
    if (input.name.length > DeckDomainConst.nameMaxLength) {
      return const Failure.validation(
        message: DeckRepositoryImplConst.deckNameMaxLengthMessage,
      );
    }
    if (input.description.length > DeckDomainConst.descriptionMaxLength) {
      return const Failure.validation(
        message: DeckRepositoryImplConst.deckDescriptionMaxLengthMessage,
      );
    }
    return null;
  }

  Map<String, dynamic> _toPayload(DeckUpsertInput input) {
    return <String, dynamic>{
      DeckRepositoryImplConst.nameField: input.name,
      DeckRepositoryImplConst.descriptionField: input.description,
    };
  }

  String _decksPath({required int folderId}) {
    return '${DeckRepositoryImplConst.foldersPath}/$folderId/${DeckRepositoryImplConst.decksPathSegment}';
  }

  String _deckPath({required int folderId, required int deckId}) {
    return '${_decksPath(folderId: folderId)}/$deckId';
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
    if (statusCode == DeckRepositoryImplConst.badRequestStatusCode) {
      return true;
    }
    if (statusCode == DeckRepositoryImplConst.conflictStatusCode) {
      return true;
    }
    if (statusCode == DeckRepositoryImplConst.unprocessableEntityStatusCode) {
      return true;
    }
    return false;
  }

  String _extractValidationMessage(dynamic rawValue) {
    final Map<String, dynamic> payload = _castMap(rawValue);
    if (payload.isEmpty) {
      return DeckRepositoryImplConst.deckNameInvalidMessage;
    }
    final Map<String, dynamic> fieldErrors = _castMap(
      payload[DeckRepositoryImplConst.fieldErrorsField],
    );
    final String? fieldNameError = _readString(
      fieldErrors[DeckRepositoryImplConst.nameFieldErrorKey],
    );
    if (fieldNameError != null) {
      return fieldNameError;
    }
    final String? message = _readString(
      payload[DeckRepositoryImplConst.messageField],
    );
    if (message != null) {
      return message;
    }
    return DeckRepositoryImplConst.deckNameInvalidMessage;
  }

  String? _readString(dynamic rawValue) {
    if (rawValue is! String) {
      return null;
    }
    final String normalized = StringUtils.normalizeName(rawValue);
    if (normalized == DeckRepositoryImplConst.emptyValue) {
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
DeckRepository deckRepository(Ref ref) {
  final Dio dio = ref.watch(dioClientProvider);
  return DioDeckRepository(dio: dio);
}

