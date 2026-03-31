import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/feedback/lumos_retry_panel.dart';

class LibraryErrorView extends StatelessWidget {
  const LibraryErrorView({
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return ColoredBox(
      color: context.colorScheme.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          child: LumosScreenFrame(
            child: LumosRetryPanel(
              title: l10n.noResultsTitle,
              message: errorMessage,
              retryLabel: l10n.commonRetry,
              onRetry: onRetry,
            ),
          ),
        ),
      ),
    );
  }
}
