import 'package:flutter/material.dart';
import 'package:lumos/core/enums/snackbar_type.dart';

class SnackbarService {
  const SnackbarService(this.messengerKey);

  final GlobalKey<ScaffoldMessengerState> messengerKey;

  ScaffoldMessengerState? get messenger => messengerKey.currentState;
  bool get isAvailable => messenger != null;

  void show(
    String message, {
    SnackbarType type = SnackbarType.info,
    SnackBarAction? action,
    Duration? duration,
    bool clearCurrent = true,
  }) {
    final messenger = this.messenger;
    if (messenger == null) {
      return;
    }

    if (clearCurrent) {
      messenger.hideCurrentSnackBar();
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        duration: duration ?? type.defaultDuration,
      ),
    );
  }

  void clear() {
    messenger?.clearSnackBars();
  }
}
