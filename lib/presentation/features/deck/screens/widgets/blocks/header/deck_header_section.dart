import 'package:flutter/material.dart';

import 'package:lumos/core/enums/sort_direction.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_pill.dart';

abstract final class DeckHeaderSectionConst {
  DeckHeaderSectionConst._();

  static const double headerGap = LumosSpacing.md;
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
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: DeckHeaderSectionConst.headerGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final String sortLabel = sortDirection == SortDirection.asc
        ? l10n.deckSortNameAscending
        : l10n.deckSortNameDescending;
    final Widget titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosText(
          l10n.deckManagerTitle,
          style: LumosTextStyle.headlineSmall,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: context.spacing.xs),
        LumosText(
          l10n.deckManagerSubtitle,
          style: LumosTextStyle.bodyMedium,
          tone: LumosTextTone.secondary,
        ),
      ],
    );
    final Widget badgeSection = Wrap(
      spacing: context.spacing.sm,
      runSpacing: context.spacing.sm,
      alignment: WrapAlignment.end,
      children: <Widget>[
        if (deckCount == null)
          LumosSkeletonBox(
            width: context.spacing.xxxl * 2,
            height: context.spacing.xl,
            borderRadius: context.shapes.pill,
          ),
        if (deckCount != null)
          LumosPill(
            child: LumosText(
              l10n.deckCount(deckCount!),
              style: LumosTextStyle.labelLarge,
            ),
          ),
        LumosPill(
          child: LumosText(sortLabel, style: LumosTextStyle.labelLarge),
        ),
      ],
    );
    return LumosSectionCard(
      variant: LumosCardVariant.filled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool useRowLayout =
                  constraints.isTablet || constraints.isDesktop;
              if (!useRowLayout) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    titleSection,
                    SizedBox(height: sectionGap),
                    badgeSection,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: titleSection),
                  SizedBox(width: sectionGap),
                  Flexible(child: badgeSection),
                ],
              );
            },
          ),
          SizedBox(height: sectionGap),
          LumosSearchBar(
            controller: searchController,
            hintText: l10n.deckSearchHint,
            clearTooltip: l10n.deckSearchClearTooltip,
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            onClear: onClearSearch,
            onSortPressed: onToggleSort,
          ),
          if (searchQuery.isNotEmpty) ...<Widget>[
            SizedBox(height: sectionGap),
            LumosText(
              l10n.deckSearchResultsFor(searchQuery),
              style: LumosTextStyle.bodyMedium,
              tone: LumosTextTone.secondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
