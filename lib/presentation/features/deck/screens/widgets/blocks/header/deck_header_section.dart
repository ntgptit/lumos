import 'package:flutter/material.dart';

import 'package:lumos/core/enums/sort_direction.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/l10n/app_localizations.dart';

import 'deck_hero_banner.dart';

abstract final class DeckHeaderSectionConst {
  DeckHeaderSectionConst._();

  static const double sectionGap =
      12;
}

class DeckHeaderSection extends StatelessWidget {
  const DeckHeaderSection({
    required this.searchController,
    required this.searchQuery,
    required this.sortDirection,
    required this.deckCount,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onClearSearch,
    required this.onToggleSort,
    super.key,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final SortDirection sortDirection;
  final int? deckCount;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onClearSearch;
  final VoidCallback onToggleSort;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double sectionGap = context.compactValue(
      baseValue: DeckHeaderSectionConst.sectionGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );

    return LumosSectionCard(
      variant: LumosCardVariant.filled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DeckHeroBanner(l10n: l10n, deckCount: deckCount),
          SizedBox(height: sectionGap),
          LumosSearchBar(
            controller: searchController,
            hintText: l10n.deckSearchHint,
            clearTooltip: l10n.deckSearchClearTooltip,
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            onClear: onClearSearch,
          ),
          SizedBox(height: sectionGap),
          Align(
            alignment: Alignment.centerLeft,
            child: LumosUtilityChipButton(
              label: _buildSortLabel(l10n: l10n),
              onPressed: onToggleSort,
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

  String _buildSortLabel({required AppLocalizations l10n}) {
    if (sortDirection == SortDirection.asc) {
      return l10n.deckSortNameAscending;
    }
    return l10n.deckSortNameDescending;
  }
}
