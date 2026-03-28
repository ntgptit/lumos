import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class FolderErrorBanner extends StatelessWidget {
  const FolderErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(LumosSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: context.shapes.card,
      ),
      child: LumosText(
        message,
        style: LumosTextStyle.bodySmall,
        containerRole: LumosTextContainerRole.errorContainer,
      ),
    );
  }
}
