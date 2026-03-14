import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/deck_models.dart';
import '../../../../../../../domain/entities/folder_models.dart';
import '../../../../providers/states/folder_state.dart';
import '../../states/folder_error_banner.dart';
import 'folder_deck_list_content.dart';
import 'folder_list_content.dart';
import '../header/folder_header.dart';

class FolderBrowserContent extends StatelessWidget {
  const FolderBrowserContent({
    required this.scrollController,
    required this.state,
    required this.visibleFolders,
    required this.currentFolderId,
    required this.canManageDecks,
    required this.deckAsync,
    required this.hasDecks,
    required this.deckCount,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.onOpenParentFolder,
    required this.onOpenRootFolder,
    required this.onOpenFolder,
    required this.onRenameFolder,
    required this.onDeleteFolder,
    required this.onOpenDeck,
    required this.onRenameDeck,
    required this.onDeleteDeck,
    required this.deckErrorMessageBuilder,
    super.key,
  });

  final ScrollController scrollController;
  final FolderState state;
  final List<FolderNode> visibleFolders;
  final int? currentFolderId;
  final bool canManageDecks;
  final Object? deckAsync;
  final bool hasDecks;
  final int deckCount;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final void Function(FolderSortBy sortBy, FolderSortType sortType)
  onSortChanged;
  final Future<void> Function() onOpenParentFolder;
  final Future<void> Function() onOpenRootFolder;
  final ValueChanged<FolderNode> onOpenFolder;
  final void Function(BuildContext context, FolderNode item) onRenameFolder;
  final void Function(BuildContext context, FolderNode item) onDeleteFolder;
  final ValueChanged<DeckNode> onOpenDeck;
  final void Function(BuildContext context, DeckNode item) onRenameDeck;
  final void Function(BuildContext context, DeckNode item) onDeleteDeck;
  final String Function(Object error) deckErrorMessageBuilder;

  @override
  Widget build(BuildContext context) {
    final List<Widget> leadingSlivers = <Widget>[
      SliverToBoxAdapter(
        child: FolderHeader(
          currentDepth: state.currentDepth,
          isDeckManager: hasDecks,
          deckCount: deckCount,
          isNavigatingParent: state.isNavigatingParent,
          isNavigatingRoot: state.isNavigatingRoot,
          searchQuery: searchQuery,
          onSearchChanged: onSearchChanged,
          sortBy: state.sortBy,
          sortType: state.sortType,
          onSortChanged: onSortChanged,
          onOpenParentFolder: onOpenParentFolder,
          onOpenRootFolder: onOpenRootFolder,
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
    ];
    if (state.inlineErrorMessage case final String message) {
      leadingSlivers.add(
        SliverToBoxAdapter(child: FolderErrorBanner(message: message)),
      );
      leadingSlivers.add(
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
      );
    }
    if (canManageDecks) {
      return FolderDeckListContent(
        scrollController: scrollController,
        currentFolderId: currentFolderId,
        deckAsync: deckAsync,
        searchQuery: searchQuery,
        leadingSlivers: leadingSlivers,
        onOpenDeck: onOpenDeck,
        onRenameDeck: onRenameDeck,
        onDeleteDeck: onDeleteDeck,
        deckErrorMessageBuilder: deckErrorMessageBuilder,
      );
    }
    return FolderListContent(
      scrollController: scrollController,
      visibleFolders: visibleFolders,
      searchQuery: searchQuery,
      showLoadMore: state.isLoadingMore,
      leadingSlivers: leadingSlivers,
      onOpenFolder: onOpenFolder,
      onRenameFolder: onRenameFolder,
      onDeleteFolder: onDeleteFolder,
    );
  }
}
