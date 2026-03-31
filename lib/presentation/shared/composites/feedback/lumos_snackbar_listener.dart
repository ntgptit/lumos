import 'package:flutter/material.dart';
import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';

class LumosSnackbarListener extends StatefulWidget {
  const LumosSnackbarListener({
    super.key,
    required this.message,
    this.title,
    this.type = SnackbarType.info,
    this.actionLabel,
    this.onActionPressed,
    required this.child,
  });

  final String? message;
  final String? title;
  final SnackbarType type;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Widget child;

  @override
  State<LumosSnackbarListener> createState() => _AppSnackbarListenerState();
}

class _AppSnackbarListenerState extends State<LumosSnackbarListener> {
  String? _lastShownMessage;
  String? _scheduledMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeShow();
  }

  @override
  void didUpdateWidget(covariant LumosSnackbarListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeShow();
  }

  void _maybeShow() {
    final message = widget.message;
    if (message == null || message.isEmpty || message == _lastShownMessage) {
      return;
    }

    if (_scheduledMessage == message) {
      return;
    }

    _scheduledMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) {
        _scheduledMessage = null;
        return;
      }

      _lastShownMessage = message;
      _scheduledMessage = null;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: AppElevationTokens.level0,
          content: LumosSnackbar(
            message: message,
            title: widget.title,
            type: _mapSnackbarType(widget.type),
            actionLabel: widget.actionLabel,
            onActionPressed: widget.onActionPressed,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  LumosSnackbarType _mapSnackbarType(SnackbarType type) {
    return switch (type) {
      SnackbarType.success => LumosSnackbarType.success,
      SnackbarType.error => LumosSnackbarType.error,
      SnackbarType.warning => LumosSnackbarType.warning,
      SnackbarType.info => LumosSnackbarType.info,
    };
  }
}
