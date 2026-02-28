import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../providers/states/folder_state.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

import 'folder_header_banner.dart';
import 'folder_header_navigation_section.dart';

class FolderHeader extends StatelessWidget {
  const FolderHeader({
    required this.currentDepth,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.sortType,
    required this.onSortTypeChanged,
    required this.onOpenParentFolder,
    super.key,
  });

  final int currentDepth;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final FolderSortType sortType;
  final ValueChanged<FolderSortType> onSortTypeChanged;
  final Future<void> Function() onOpenParentFolder;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosCard(
      variant: LumosCardVariant.filled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FolderHeaderBanner(l10n: l10n, currentDepth: currentDepth),
          const SizedBox(height: Insets.spacing12),
          FolderHeaderNavigationSection(
            l10n: l10n,
            currentDepth: currentDepth,
            searchQuery: searchQuery,
            onSearchChanged: onSearchChanged,
            sortType: sortType,
            onSortTypeChanged: onSortTypeChanged,
            onOpenParentFolder: onOpenParentFolder,
          ),
        ],
      ),
    );
  }
}
