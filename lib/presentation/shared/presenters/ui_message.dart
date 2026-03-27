import 'package:flutter/material.dart';
import 'package:lumos/core/enums/snackbar_type.dart';

@immutable
class UiMessage {
  const UiMessage({
    required this.message,
    this.title,
    this.type = SnackbarType.info,
    this.actionLabel,
    this.onActionPressed,
    this.duration,
  });

  final String message;
  final String? title;
  final SnackbarType type;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Duration? duration;

  bool get hasAction => actionLabel != null && onActionPressed != null;

  UiMessage copyWith({
    String? message,
    String? title,
    SnackbarType? type,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration? duration,
  }) {
    return UiMessage(
      message: message ?? this.message,
      title: title ?? this.title,
      type: type ?? this.type,
      actionLabel: actionLabel ?? this.actionLabel,
      onActionPressed: onActionPressed ?? this.onActionPressed,
      duration: duration ?? this.duration,
    );
  }
}
