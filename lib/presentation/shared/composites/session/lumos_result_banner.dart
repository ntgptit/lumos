import 'package:flutter/material.dart';
import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_banner.dart';

enum AppAnswerResultKind { correct, incorrect, neutral }

class LumosResultBanner extends StatelessWidget {
  const LumosResultBanner({
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
    final resolvedTitle = title ?? _defaultTitle(context: context, kind: kind);
    return LumosBanner(
      message: message,
      title: resolvedTitle,
      type: _snackbarType(kind),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      dense: dense,
    );
  }

  String _defaultTitle({
    required BuildContext context,
    required AppAnswerResultKind kind,
  }) {
    final AppLocalizations l10n = context.l10n;
    return switch (kind) {
      AppAnswerResultKind.correct => l10n.commonCorrect,
      AppAnswerResultKind.incorrect => l10n.commonIncorrect,
      AppAnswerResultKind.neutral => l10n.commonResult,
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
