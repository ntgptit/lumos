import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';

class DeckEmptyView extends StatelessWidget {
  const DeckEmptyView({required this.isSearchResult, super.key});

  final bool isSearchResult;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String title = isSearchResult
        ? l10n.deckSearchEmptyTitle
        : l10n.deckEmptyTitle;
    final String message = isSearchResult
        ? l10n.deckSearchEmptySubtitle
        : l10n.deckEmptySubtitle;
    final IconData icon = isSearchResult
        ? Icons.search_off_rounded
        : Icons.style_outlined;
    return LumosEmptyState(title: title, message: message, icon: icon);
  }
}

