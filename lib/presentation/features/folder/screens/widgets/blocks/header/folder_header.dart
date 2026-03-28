import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/theme/tokens/visual/elevation_tokens.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/states/folder_state.dart';

import 'folder_header_banner.dart';
import 'folder_header_navigation_section.dart';

class FolderHeader extends StatelessWidget {
  const FolderHeader({
    required this.currentDepth,
    required this.isDeckManager,
    required this.deckCount,
    required this.isNavigatingParent,
    required this.isNavigatingRoot,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.sortBy,
    required this.sortType,
    required this.onSortChanged,
    required this.onOpenParentFolder,
    required this.onOpenRootFolder,
    super.key,
  });

  final int currentDepth;
  final bool isDeckManager;
  final int deckCount;
  final bool isNavigatingParent;
  final bool isNavigatingRoot;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final FolderSortBy sortBy;
  final FolderSortType sortType;
  final void Function(FolderSortBy sortBy, FolderSortType sortType)
  onSortChanged;
  final Future<void> Function() onOpenParentFolder;
  final Future<void> Function() onOpenRootFolder;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      variant: LumosCardVariant.filled,
      elevation: AppElevationTokens.level1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FolderHeaderBanner(
            l10n: l10n,
            currentDepth: currentDepth,
            isDeckManager: isDeckManager,
            deckCount: deckCount,
          ),
          SizedBox(height: sectionGap),
          FolderHeaderNavigationSection(
            l10n: l10n,
            currentDepth: currentDepth,
            isDeckManager: isDeckManager,
            isNavigatingParent: isNavigatingParent,
            isNavigatingRoot: isNavigatingRoot,
            searchQuery: searchQuery,
            onSearchChanged: onSearchChanged,
            sortBy: sortBy,
            sortType: sortType,
            onSortChanged: onSortChanged,
            onOpenParentFolder: onOpenParentFolder,
            onOpenRootFolder: onOpenRootFolder,
          ),
        ],
      ),
    );
  }
}

