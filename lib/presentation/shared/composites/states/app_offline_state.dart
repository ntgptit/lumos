import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/app_error_state.dart';

class AppOfflineState extends StatelessWidget {
  const AppOfflineState({
    super.key,
    this.onRetry,
    this.retryLabel,
    this.message,
    this.maxWidth,
  });

  final VoidCallback? onRetry;
  final String? retryLabel;
  final String? message;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return AppErrorState(
      title: context.l10n.offlineTitle,
      message: message ?? context.l10n.offlineMessage,
      primaryActionLabel: retryLabel ?? context.l10n.offlineRetryLabel,
      onPrimaryAction: onRetry,
      maxWidth: maxWidth,
    );
  }
}
