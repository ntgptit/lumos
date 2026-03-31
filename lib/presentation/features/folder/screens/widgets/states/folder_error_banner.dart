import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class FolderErrorBanner extends StatelessWidget {
  const FolderErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(
        context.spacing.md,
      ),
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
