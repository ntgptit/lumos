import 'package:lumos/core/errors/error_mapper.dart' as current;
import 'package:lumos/core/errors/failure.dart';

abstract final class ErrorMapper {
  static Failure map(Object error, {StackTrace? stackTrace}) {
    return current.ErrorMapper.map(error, stackTrace: stackTrace);
  }

  static Failure mapToFailure(Object error, {StackTrace? stackTrace}) {
    return map(error, stackTrace: stackTrace);
  }
}

extension ErrorMapperObjectCompat on Object {
  Failure toFailure({StackTrace? stackTrace}) {
    return ErrorMapper.map(this, stackTrace: stackTrace);
  }
}
