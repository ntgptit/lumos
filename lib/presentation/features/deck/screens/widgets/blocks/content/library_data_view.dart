import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/domain/entities/folder_models.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/deck/providers/states/library_state.dart';
import 'package:lumos/presentation/features/deck/screens/widgets/blocks/content/library_folder_tile.dart';
import 'package:lumos/presentation/features/deck/screens/widgets/blocks/header/library_header_section.dart';
import 'package:lumos/presentation/features/deck/screens/widgets/states/library_empty_view.dart';

class LibraryDataView extends StatelessWidget {
  const LibraryDataView({
    required this.scrollController,
    required this.searchController,
    required this.state,
    required this.onRefresh,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onClearSearch,
    required this.onOpenSort,
    required this.onOpenFolder,
    required this.onOpenFolders,
    super.key,
  });

  final ScrollController scrollController;
  final TextEditingController searchController;
  final LibraryState state;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onClearSearch;
  final VoidCallback onOpenSort;
  final ValueChanged<FolderNode> onOpenFolder;
  final VoidCallback onOpenFolders;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double horizontalInset = LumosScreenFrame.resolveHorizontalInset(
      context,
    );
    final double verticalInset = context.layout.pageVerticalPadding;
    final double listGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return ColoredBox(
      color: context.colorScheme.surface,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: LumosPagedSliverList(
            controller: scrollController,
            leadingSlivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalInset,
                    verticalInset,
                    horizontalInset,
                    listGap,
                  ),
                  child: LibraryHeaderSection(
                    l10n: l10n,
                    searchController: searchController,
                    searchQuery: state.searchQuery,
                    sortBy: state.sortBy,
                    sortDirection: state.sortDirection,
                    folderCount: state.folders.length,
                    onSearchChanged: onSearchChanged,
                    onSearchSubmitted: onSearchSubmitted,
                    onClearSearch: onClearSearch,
                    onOpenSort: onOpenSort,
                  ),
                ),
              ),
            ],
            itemCount: state.folders.length,
            itemBuilder: (BuildContext context, int index) {
              final FolderNode folder = state.folders[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalInset,
                  0,
                  horizontalInset,
                  index == state.folders.length - 1 ? 0 : listGap,
                ),
                child: LibraryFolderTile(
                  folder: folder,
                  onOpen: () => onOpenFolder(folder),
                ),
              );
            },
            emptySliver: LibraryEmptyView(
              searchQuery: state.searchQuery,
              onOpenFolders: onOpenFolders,
            ),
            trailingSlivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalInset,
                    listGap,
                    horizontalInset,
                    verticalInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (state.isLoadingMore)
                        const Center(child: LumosLoadingIndicator()),
                      if (state.inlineErrorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(top: context.spacing.sm),
                          child: LumosText(
                            state.inlineErrorMessage!,
                            style: LumosTextStyle.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
