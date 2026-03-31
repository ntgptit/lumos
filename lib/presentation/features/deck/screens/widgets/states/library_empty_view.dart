import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/l10n/app_localizations.dart';

class LibraryEmptyView extends StatelessWidget {
  const LibraryEmptyView({
    required this.searchQuery,
    required this.onOpenFolders,
    super.key,
  });

  final String searchQuery;
  final VoidCallback onOpenFolders;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (searchQuery.isNotEmpty) {
      return LumosEmptyState(
        icon: Icons.search_off_rounded,
        title: l10n.noResultsTitle,
        message: l10n.librarySearchEmptyMessage,
      );
    }
    return LumosEmptyState(
      icon: Icons.folder_copy_outlined,
      title: l10n.folderEmptyTitle,
      message: l10n.deckLibraryEntryMessage,
      buttonLabel: l10n.deckLibraryEntryAction,
      onButtonPressed: onOpenFolders,
    );
  }
}
