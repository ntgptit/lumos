import 'package:flutter/material.dart';

import 'lumos_empty_state.dart';

class LumosErrorStateConst {
  const LumosErrorStateConst._();

  static const String defaultTitle = 'Something went wrong';
  static const String defaultRetryLabel = 'Try again';
  static const IconData defaultIcon = Icons.error_outline_rounded;
}

class LumosErrorState extends StatelessWidget {
  const LumosErrorState({
    required this.errorMessage,
    super.key,
    this.onRetry,
    this.retryLabel = LumosErrorStateConst.defaultRetryLabel,
  });

  final String errorMessage;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return LumosEmptyState(
      title: LumosErrorStateConst.defaultTitle,
      message: errorMessage,
      icon: LumosErrorStateConst.defaultIcon,
      buttonLabel: retryLabel,
      onButtonPressed: onRetry,
    );
  }
}
