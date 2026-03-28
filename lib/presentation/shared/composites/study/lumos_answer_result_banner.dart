import 'package:flutter/material.dart';
import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_banner.dart';

enum AppAnswerResultKind { correct, incorrect, neutral }

class LumosAnswerResultBanner extends StatelessWidget {
  const LumosAnswerResultBanner({
    super.key,
    required this.message,
    this.title,
    this.kind = AppAnswerResultKind.neutral,
    this.actionLabel,
    this.onActionPressed,
    this.dense = false,
  });

  final String message;
  final String? title;
  final AppAnswerResultKind kind;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return LumosBanner(
      message: message,
      title: title ?? _defaultTitle(kind),
      type: _snackbarType(kind),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      dense: dense,
    );
  }

  String _defaultTitle(AppAnswerResultKind kind) {
    return switch (kind) {
      AppAnswerResultKind.correct => 'Correct',
      AppAnswerResultKind.incorrect => 'Incorrect',
      AppAnswerResultKind.neutral => 'Result',
    };
  }

  SnackbarType _snackbarType(AppAnswerResultKind kind) {
    return switch (kind) {
      AppAnswerResultKind.correct => SnackbarType.success,
      AppAnswerResultKind.incorrect => SnackbarType.error,
      AppAnswerResultKind.neutral => SnackbarType.info,
    };
  }
}
