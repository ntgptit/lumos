import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';

class FlashcardEmptyView extends StatelessWidget {
  const FlashcardEmptyView({
    required this.isSearchResult,
    required this.onCreatePressed,
    super.key,
  });

  final bool isSearchResult;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String title = isSearchResult
        ? l10n.flashcardSearchEmptyTitle
        : l10n.flashcardEmptyTitle;
    final String message = isSearchResult
        ? l10n.flashcardSearchEmptySubtitle
        : l10n.flashcardEmptySubtitle;
    return LumosEmptyState(
      title: title,
      message: message,
      icon: isSearchResult ? Icons.search_off_rounded : Icons.style_outlined,
      buttonLabel: isSearchResult ? null : l10n.flashcardCreateButton,
      onButtonPressed: isSearchResult ? null : onCreatePressed,
    );
  }
}

