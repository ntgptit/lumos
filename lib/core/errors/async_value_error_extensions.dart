import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/core/errors/error_mapper.dart';
import 'package:lumos/core/errors/failure.dart';

extension AsyncValueErrorExtensions<T> on AsyncValue<T> {
  Widget whenWithLoading({
    required Widget Function(BuildContext context) loadingBuilder,
    required Widget Function(BuildContext context, T data) dataBuilder,
    required Widget Function(BuildContext context, Failure failure)
    errorBuilder,
  }) {
    return when(
      loading: () => Builder(builder: loadingBuilder),
      data: (data) => Builder(builder: (context) => dataBuilder(context, data)),
      error: (error, stackTrace) {
        final failure = ErrorMapper.map(error, stackTrace: stackTrace);
        return Builder(builder: (context) => errorBuilder(context, failure));
      },
    );
  }
}
