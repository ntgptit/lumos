import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/folder_models.dart';
import '../../../folder_content_support.dart';
import '../../states/folder_empty_view.dart';
import '../../states/folder_load_more_indicator.dart';
import 'folder_list_tile.dart';

class FolderListContent extends StatelessWidget {
  const FolderListContent({
    required this.scrollController,
    required this.visibleFolders,
    required this.searchQuery,
    required this.showLoadMore,
    required this.leadingSlivers,
    required this.onOpenFolder,
    required this.onRenameFolder,
    required this.onDeleteFolder,
    super.key,
  });

  final ScrollController scrollController;
  final List<FolderNode> visibleFolders;
  final String searchQuery;
  final bool showLoadMore;
  final List<Widget> leadingSlivers;
  final ValueChanged<FolderNode> onOpenFolder;
  final void Function(BuildContext context, FolderNode item) onRenameFolder;
  final void Function(BuildContext context, FolderNode item) onDeleteFolder;

  @override
  Widget build(BuildContext context) {
    final double loadMoreTopSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FolderContentSupportConst.loadMoreTopSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double loadMoreBottomSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FolderContentSupportConst.loadMoreBottomSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double listBottomSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FolderContentSupportConst.listBottomSpacing,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
    final double rowSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final List<Widget> trailingSlivers = <Widget>[
      if (showLoadMore)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              top: loadMoreTopSpacing,
              bottom: loadMoreBottomSpacing,
            ),
            child: const FolderLoadMoreIndicator(),
          ),
        ),
      SliverToBoxAdapter(child: SizedBox(height: listBottomSpacing)),
    ];
    return LumosPagedSliverList(
      controller: scrollController,
      leadingSlivers: leadingSlivers,
      trailingSlivers: trailingSlivers,
      itemCount: visibleFolders.length,
      itemBuilder: (BuildContext context, int index) {
        final FolderNode item = visibleFolders[index];
        return Padding(
          padding: EdgeInsets.only(bottom: rowSpacing),
          child: FolderListTile(
            item: item,
            onOpen: () => onOpenFolder(item),
            onRename: () => onRenameFolder(context, item),
            onDelete: () => onDeleteFolder(context, item),
          ),
        );
      },
      emptySliver: FolderEmptyView(isSearchResult: searchQuery.isNotEmpty),
    );
  }
}

