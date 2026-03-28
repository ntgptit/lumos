import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../l10n/app_localizations.dart';

const EdgeInsetsGeometry _flashcardLoadingMaskPadding = EdgeInsets.fromLTRB(
  LumosSpacing.lg,
  LumosSpacing.sm,
  LumosSpacing.lg,
  LumosSpacing.none,
);
const double _flashcardLoadingMaskHeight = WidgetSizes.progressTrackHeight;

class FlashcardLoadingShell extends StatelessWidget {
  const FlashcardLoadingShell({required this.deckName, super.key});

  final String deckName;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String normalizedDeckName = StringUtils.normalizeName(deckName);
    final String title = normalizedDeckName.isEmpty
        ? l10n.flashcardTitle
        : normalizedDeckName;
    return Scaffold(
      appBar: LumosAppBar(title: title),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: _flashcardLoadingMaskPadding,
            child: ClipRRect(
              borderRadius: BorderRadii.medium,
              child: const LumosLoadingIndicator(
                isLinear: true,
                size: _flashcardLoadingMaskHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

