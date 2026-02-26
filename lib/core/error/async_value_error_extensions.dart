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
}
