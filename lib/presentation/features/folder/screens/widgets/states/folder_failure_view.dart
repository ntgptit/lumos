import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderFailureView extends StatelessWidget {
  const FolderFailureView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosErrorState(
      errorMessage: message,
      onRetry: onRetry,
      retryLabel: l10n.commonRetry,
    );
  }
}
