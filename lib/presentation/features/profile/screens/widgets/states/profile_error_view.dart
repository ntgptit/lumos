import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../l10n/app_localizations.dart';

class ProfileErrorView extends StatelessWidget {
  const ProfileErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(LumosSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LumosText(message, style: LumosTextStyle.bodyMedium),
            const SizedBox(height: LumosSpacing.md),
            LumosPrimaryButton(onPressed: onRetry, label: l10n.commonRetry),
          ],
        ),
      ),
    );
  }
}

