import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_mapper.dart';
import 'failures.dart';

/// AsyncValue helpers for centralized error UI behavior.
extension AsyncValueErrorX<T> on AsyncValue<T> {
  Failure? get failureOrNull {
    return whenOrNull(
      error: (Object error, StackTrace stackTrace) {
        return error.toFailure();
      },
    );
  }

  /// Shows a snackbar when the current state is error.
  void showErrorSnackbarIfAny({
    required BuildContext context,
    SnackBarAction? action,
  }) {
    final Failure? failure = failureOrNull;
    if (failure == null) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure.message), action: action));
  }

  Widget whenWithLoading({
    required Widget Function(BuildContext context, T data) dataBuilder,
    required Widget Function(BuildContext context) loadingBuilder,
    Widget Function(BuildContext context, Failure failure)? errorBuilder,
  }) {
    return when(
      data: (T data) => Builder(
        builder: (BuildContext context) {
          return dataBuilder(context, data);
        },
      ),
      loading: () => Builder(
        builder: (BuildContext context) {
          return loadingBuilder(context);
        },
      ),
      error: (Object error, StackTrace stackTrace) => Builder(
        builder: (BuildContext context) {
          final Failure failure = error.toFailure();
          final errorBuilderOrFallback = errorBuilder;
          if (errorBuilderOrFallback != null) {
            return errorBuilderOrFallback(context, failure);
          }
          return Center(child: Text(failure.message));
        },
      ),
    );
  }
}
