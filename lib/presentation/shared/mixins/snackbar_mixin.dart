import 'package:flutter/material.dart';
import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';

mixin SnackbarMixin<T extends StatefulWidget> on State<T> {
  void showAppSnackbar({
    required String message,
    String? title,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration? duration,
    bool clearCurrent = true,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    if (clearCurrent) {
      messenger.hideCurrentSnackBar();
    }

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: AppElevationTokens.level0,
        duration: duration ?? type.defaultDuration,
        content: LumosSnackbar(
          message: message,
          title: title,
          type: type,
          actionLabel: actionLabel,
          onActionPressed: onActionPressed,
        ),
      ),
    );
  }

  void clearAppSnackbars() {
    ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
  }
}
