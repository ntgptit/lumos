import 'package:flutter/material.dart';

import 'package:lumos/core/enums/sort_direction.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/deck/providers/states/library_state.dart';

import 'library_hero_banner.dart';

class LibraryHeaderSection extends StatelessWidget {
  const LibraryHeaderSection({
    required this.l10n,
    required this.searchController,
    required this.searchQuery,
    required this.sortBy,
    required this.sortDirection,
    required this.folderCount,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onClearSearch,
    required this.onOpenSort,
    super.key,
  });

  final AppLocalizations l10n;
  final TextEditingController searchController;
  final String searchQuery;
  final LibrarySortBy sortBy;
  final SortDirection sortDirection;
  final int? folderCount;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onClearSearch;
  final VoidCallback onOpenSort;

  @override
  Widget build(BuildContext context) {
    final double sectionGap = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );

    return LumosSectionCard(
      variant: LumosCardVariant.filled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LibraryHeroBanner(l10n: l10n, folderCount: folderCount),
          SizedBox(height: sectionGap),
          LumosSearchBar(
            controller: searchController,
            hintText: l10n.folderSearchHint,
            clearTooltip: l10n.folderSearchClearTooltip,
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            onClear: onClearSearch,
          ),
          SizedBox(height: sectionGap),
          Align(
            alignment: Alignment.centerLeft,
            child: LumosUtilityChipButton(
              label: _buildSortLabel(),
              onPressed: onOpenSort,
              leading: LumosIcon(
                Icons.sort_rounded,
                size: context.iconSize.sm,
              ),
              trailing: LumosIcon(
                Icons.keyboard_arrow_down_rounded,
                size: context.iconSize.sm,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildSortLabel() {
    if (sortBy == LibrarySortBy.createdAt) {
      if (sortDirection == SortDirection.desc) {
        return l10n.folderSortCreatedNewest;
      }
      return l10n.folderSortCreatedOldest;
    }
    if (sortDirection == SortDirection.desc) {
      return l10n.folderSortNameDescending;
    }
    return l10n.folderSortNameAscending;
  }
}
