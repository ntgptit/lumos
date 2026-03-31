import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/enums/sort_direction.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/deck/providers/states/library_state.dart';
import 'package:lumos/presentation/features/deck/screens/widgets/blocks/header/library_header_section.dart';
import 'package:lumos/presentation/shared/composites/feedback/lumos_skeleton_list_item.dart';

abstract final class LibraryLoadingViewConst {
  LibraryLoadingViewConst._();

  static const int skeletonCount = 4;
}

class LibraryLoadingView extends StatelessWidget {
  const LibraryLoadingView({required this.searchController, super.key});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double sectionGap = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return ColoredBox(
      color: context.colorScheme.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          child: LumosScreenFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LibraryHeaderSection(
                  l10n: l10n,
                  searchController: searchController,
                  searchQuery: LibraryStateConst.emptySearchQuery,
                  sortBy: LibrarySortBy.name,
                  sortDirection: SortDirection.asc,
                  folderCount: null,
                  onSearchChanged: (_) {},
                  onSearchSubmitted: (_) {},
                  onClearSearch: () {},
                  onOpenSort: () {},
                ),
                SizedBox(height: sectionGap),
                for (
                  int index = 0;
                  index < LibraryLoadingViewConst.skeletonCount;
                  index++
                ) ...<Widget>[
                  const LumosCard(
                    margin: EdgeInsets.zero,
                    child: LumosSkeletonListItem(showTrailing: false),
                  ),
                  if (index < LibraryLoadingViewConst.skeletonCount - 1)
                    SizedBox(height: sectionGap),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
