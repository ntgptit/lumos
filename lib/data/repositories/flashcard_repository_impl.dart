import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumos/core/errors/failures.dart';
import '../../core/network/providers/network_providers.dart';
import '../../core/utils/string_utils.dart';
import '../../domain/entities/flashcard_models.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../models/flashcard_model.dart';

part 'flashcard_repository_impl.g.dart';

abstract final class FlashcardRepositoryImplConst {
  FlashcardRepositoryImplConst._();

  static const String decksPath = '/api/v1/decks';
  static const String flashcardsPathSegment = 'flashcards';
  static const String pageQueryKey = 'page';
  static const String sizeQueryKey = 'size';
  static const String searchQueryKey = 'searchQuery';
  static const String sortByQueryKey = 'sortBy';
  static const String sortTypeQueryKey = 'sortType';
  static const String sortByCreatedAt = 'CREATED_AT';
  static const String sortByUpdatedAt = 'UPDATED_AT';
  static const String sortByFrontText = 'FRONT_TEXT';
  static const String sortTypeAscending = 'ASC';
  static const String sortTypeDescending = 'DESC';
  static const String frontTextField = 'frontText';
  static const String backTextField = 'backText';
  static const String frontLangCodeField = 'frontLangCode';
  static const String backLangCodeField = 'backLangCode';
  static const String messageField = 'message';
  static const String fieldErrorsField = 'fieldErrors';
  static const String frontTextFieldErrorKey = 'frontText';
  static const String backTextFieldErrorKey = 'backText';
  static const String frontLangCodeFieldErrorKey = 'frontLangCode';
  static const String backLangCodeFieldErrorKey = 'backLangCode';
  static const String emptyValue = '';
  static const String frontTextRequiredMessage = 'Front text is required.';
  static const String frontTextMaxLengthMessage =
      'Front text must be at most ${FlashcardDomainConst.frontTextMaxLength} characters.';
  static const String backTextRequiredMessage = 'Back text is required.';
  static const String backTextMaxLengthMessage =
      'Back text must be at most ${FlashcardDomainConst.backTextMaxLength} characters.';
  static const String flashcardInputInvalidMessage = 'Flashcard input is invalid.';
  static const int badRequestStatusCode = 400;
  static const int conflictStatusCode = 409;
  static const int unprocessableEntityStatusCode = 422;
}

class DioFlashcardRepository implements FlashcardRepository {
  const DioFlashcardRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Either<Failure, FlashcardPage>> getFlashcards({
    required FlashcardQuery query,
    required int page,
  }) async {
    final int safePage = _resolvePage(page);
    final int safePageSize = _resolvePageSize(query.pageSize);
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      FlashcardRepositoryImplConst.pageQueryKey: safePage,
      FlashcardRepositoryImplConst.sizeQueryKey: safePageSize,
      FlashcardRepositoryImplConst.searchQueryKey: query.searchQuery,
      FlashcardRepositoryImplConst.sortByQueryKey: _toSortByToken(query.sortBy),
      FlashcardRepositoryImplConst.sortTypeQueryKey: _toSortTypeToken(
        query.sortDirection,
      ),
    };
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        _flashcardsPath(deckId: query.deckId),
        queryParameters: queryParameters,
      );
      final Map<String, dynamic> payload = _castMap(response.data);
      final FlashcardPageModel pageModel = FlashcardPageModel.fromJson(payload);
      return right<Failure, FlashcardPage>(pageModel.toEntity());
    } on Object catch (error) {
      return left<Failure, FlashcardPage>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, FlashcardNode>> createFlashcard({
    required int deckId,
    required FlashcardUpsertInput input,
  }) async {
    final FlashcardUpsertInput normalizedInput = _normalizeInput(input);
    final Failure? validationFailure = _validateInput(normalizedInput);
    if (validationFailure != null) {
      return left<Failure, FlashcardNode>(validationFailure);
    }
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        _flashcardsPath(deckId: deckId),
        data: _toPayload(normalizedInput),
      );
      final Map<String, dynamic> payload = _castMap(response.data);
      final FlashcardModel model = FlashcardModel.fromJson(payload);
      return right<Failure, FlashcardNode>(model.toEntity());
    } on Object catch (error) {
      return left<Failure, FlashcardNode>(_mapMutationFailure(error));
    }
  }

  @override
  Future<Either<Failure, FlashcardNode>> updateFlashcard({
    required int deckId,
    required int flashcardId,
    required FlashcardUpsertInput input,
  }) async {
    final FlashcardUpsertInput normalizedInput = _normalizeInput(input);
    final Failure? validationFailure = _validateInput(normalizedInput);
    if (validationFailure != null) {
      return left<Failure, FlashcardNode>(validationFailure);
    }
    try {
      final Response<dynamic> response = await _dio.put<dynamic>(
        _flashcardPath(deckId: deckId, flashcardId: flashcardId),
        data: _toPayload(normalizedInput),
      );
      final Map<String, dynamic> payload = _castMap(response.data);
      final FlashcardModel model = FlashcardModel.fromJson(payload);
      return right<Failure, FlashcardNode>(model.toEntity());
    } on Object catch (error) {
      return left<Failure, FlashcardNode>(_mapMutationFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteFlashcard({
    required int deckId,
    required int flashcardId,
  }) async {
    try {
      await _dio.delete<dynamic>(
        _flashcardPath(deckId: deckId, flashcardId: flashcardId),
      );
      return right<Failure, Unit>(unit);
    } on Object catch (error) {
      return left<Failure, Unit>(error.toFailure());
    }
  }

  FlashcardUpsertInput _normalizeInput(FlashcardUpsertInput input) {
    final String? normalizedFrontLangCode = _normalizeLanguageCode(
      input.frontLangCode,
    );
    final String? normalizedBackLangCode = _normalizeLanguageCode(
      input.backLangCode,
    );
    return FlashcardUpsertInput(
      frontText: StringUtils.normalizeText(input.frontText),
      backText: StringUtils.normalizeText(input.backText),
      frontLangCode: normalizedFrontLangCode,
      backLangCode: normalizedBackLangCode,
    );
  }

  String? _normalizeLanguageCode(String? rawValue) {
    if (rawValue == null) {
      return null;
    }
    final String normalized = StringUtils.normalizeName(rawValue);
    if (normalized == FlashcardRepositoryImplConst.emptyValue) {
      return null;
    }
    return normalized;
  }

  Failure? _validateInput(FlashcardUpsertInput input) {
    if (input.frontText.length < FlashcardDomainConst.frontTextMinLength) {
      return const Failure.validation(
        message: FlashcardRepositoryImplConst.frontTextRequiredMessage,
      );
    }
    if (input.frontText.length > FlashcardDomainConst.frontTextMaxLength) {
      return const Failure.validation(
        message: FlashcardRepositoryImplConst.frontTextMaxLengthMessage,
      );
    }
    if (input.backText.length < FlashcardDomainConst.backTextMinLength) {
      return const Failure.validation(
        message: FlashcardRepositoryImplConst.backTextRequiredMessage,
      );
    }
    if (input.backText.length > FlashcardDomainConst.backTextMaxLength) {
      return const Failure.validation(
        message: FlashcardRepositoryImplConst.backTextMaxLengthMessage,
      );
    }
    return null;
  }

  Map<String, dynamic> _toPayload(FlashcardUpsertInput input) {
    return <String, dynamic>{
      FlashcardRepositoryImplConst.frontTextField: input.frontText,
      FlashcardRepositoryImplConst.backTextField: input.backText,
      FlashcardRepositoryImplConst.frontLangCodeField: input.frontLangCode,
      FlashcardRepositoryImplConst.backLangCodeField: input.backLangCode,
    };
  }

  String _flashcardsPath({required int deckId}) {
    return '${FlashcardRepositoryImplConst.decksPath}/$deckId/${FlashcardRepositoryImplConst.flashcardsPathSegment}';
  }

  String _flashcardPath({required int deckId, required int flashcardId}) {
    return '${_flashcardsPath(deckId: deckId)}/$flashcardId';
  }

  String _toSortByToken(FlashcardSortBy sortBy) {
    if (sortBy == FlashcardSortBy.updatedAt) {
      return FlashcardRepositoryImplConst.sortByUpdatedAt;
    }
    if (sortBy == FlashcardSortBy.frontText) {
      return FlashcardRepositoryImplConst.sortByFrontText;
    }
    return FlashcardRepositoryImplConst.sortByCreatedAt;
  }

  String _toSortTypeToken(FlashcardSortDirection sortDirection) {
    if (sortDirection == FlashcardSortDirection.asc) {
      return FlashcardRepositoryImplConst.sortTypeAscending;
    }
    return FlashcardRepositoryImplConst.sortTypeDescending;
  }

  int _resolvePage(int page) {
    if (page < FlashcardDomainConst.minPage) {
      return FlashcardDomainConst.minPage;
    }
    return page;
  }

  int _resolvePageSize(int pageSize) {
    if (pageSize < FlashcardDomainConst.minPageSize) {
      return FlashcardDomainConst.defaultPageSize;
    }
    if (pageSize > FlashcardDomainConst.maxPageSize) {
      return FlashcardDomainConst.maxPageSize;
    }
    return pageSize;
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
    if (statusCode == FlashcardRepositoryImplConst.badRequestStatusCode) {
      return true;
    }
    if (statusCode == FlashcardRepositoryImplConst.conflictStatusCode) {
      return true;
    }
    if (statusCode == FlashcardRepositoryImplConst.unprocessableEntityStatusCode) {
      return true;
    }
    return false;
  }

  String _extractValidationMessage(dynamic rawValue) {
    final Map<String, dynamic> payload = _castMap(rawValue);
    if (payload.isEmpty) {
      return FlashcardRepositoryImplConst.flashcardInputInvalidMessage;
    }
    final Map<String, dynamic> fieldErrors = _castMap(
      payload[FlashcardRepositoryImplConst.fieldErrorsField],
    );
    final String? frontTextMessage = _readString(
      fieldErrors[FlashcardRepositoryImplConst.frontTextFieldErrorKey],
    );
    if (frontTextMessage != null) {
      return frontTextMessage;
    }
    final String? backTextMessage = _readString(
      fieldErrors[FlashcardRepositoryImplConst.backTextFieldErrorKey],
    );
    if (backTextMessage != null) {
      return backTextMessage;
    }
    final String? frontLangCodeMessage = _readString(
      fieldErrors[FlashcardRepositoryImplConst.frontLangCodeFieldErrorKey],
    );
    if (frontLangCodeMessage != null) {
      return frontLangCodeMessage;
    }
    final String? backLangCodeMessage = _readString(
      fieldErrors[FlashcardRepositoryImplConst.backLangCodeFieldErrorKey],
    );
    if (backLangCodeMessage != null) {
      return backLangCodeMessage;
    }
    final String? message = _readString(
      payload[FlashcardRepositoryImplConst.messageField],
    );
    if (message != null) {
      return message;
    }
    return FlashcardRepositoryImplConst.flashcardInputInvalidMessage;
  }

  String? _readString(dynamic rawValue) {
    if (rawValue is! String) {
      return null;
    }
    final String normalized = StringUtils.normalizeName(rawValue);
    if (normalized == FlashcardRepositoryImplConst.emptyValue) {
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
}

@Deprecated('Use DioFlashcardRepository')
typedef InMemoryFlashcardRepository = DioFlashcardRepository;

@Riverpod(keepAlive: true)
FlashcardRepository flashcardRepository(Ref ref) {
  final Dio dio = ref.watch(dioClientProvider);
  return DioFlashcardRepository(dio: dio);
}

