import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderEmptyView extends StatelessWidget {
  const FolderEmptyView({required this.isSearchResult, super.key});

  final bool isSearchResult;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String title = isSearchResult
        ? l10n.folderSearchEmptyTitle
        : l10n.folderEmptyTitle;
    final String message = isSearchResult
        ? l10n.folderSearchEmptySubtitle
        : l10n.folderEmptySubtitle;
    final IconData icon = isSearchResult
        ? Icons.search_off_rounded
        : Icons.folder_copy_outlined;
    return LumosEmptyState(title: title, message: message, icon: icon);
  }
}
