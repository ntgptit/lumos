import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/deck_models.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../deck/providers/states/deck_state.dart';
import '../../../../../deck/screens/widgets/blocks/content/deck_list_tile.dart';
import '../../../../../deck/screens/widgets/states/deck_empty_view.dart';
import '../../../folder_content_support.dart';
import '../../states/folder_deck_loading.dart';
import '../../states/folder_error_banner.dart';

class FolderDeckListContent extends StatelessWidget {
  const FolderDeckListContent({
    required this.scrollController,
    required this.currentFolderId,
    required this.deckAsync,
    required this.searchQuery,
    required this.leadingSlivers,
    required this.onOpenDeck,
    required this.onRenameDeck,
    required this.onDeleteDeck,
    required this.deckErrorMessageBuilder,
    super.key,
  });

  final ScrollController scrollController;
  final int? currentFolderId;
  final Object? deckAsync;
  final String searchQuery;
  final List<Widget> leadingSlivers;
  final ValueChanged<DeckNode> onOpenDeck;
  final void Function(BuildContext context, DeckNode item) onRenameDeck;
  final void Function(BuildContext context, DeckNode item) onDeleteDeck;
  final String Function(Object error) deckErrorMessageBuilder;

  @override
  Widget build(BuildContext context) {
    final List<Widget> trailingSlivers = const <Widget>[
      SliverToBoxAdapter(
        child: SizedBox(height: FolderContentSupportConst.listBottomSpacing),
      ),
    ];
    if (currentFolderId == null || deckAsync == null) {
      return LumosPagedSliverList(
        controller: scrollController,
        leadingSlivers: leadingSlivers,
        trailingSlivers: trailingSlivers,
        itemCount: 0,
        itemBuilder: (BuildContext context, int index) {
          return const SizedBox.shrink();
        },
      );
    }
    final AsyncValue<DeckState> resolvedDeckAsync =
        deckAsync! as AsyncValue<DeckState>;
    return resolvedDeckAsync.when(
      loading: () {
        return LumosPagedSliverList(
          controller: scrollController,
          leadingSlivers: leadingSlivers,
          trailingSlivers: trailingSlivers,
          itemCount: 0,
          itemBuilder: (BuildContext context, int index) {
            return const SizedBox.shrink();
          },
          emptySliver: const FolderDeckLoading(),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return LumosPagedSliverList(
          controller: scrollController,
          leadingSlivers: leadingSlivers,
          trailingSlivers: trailingSlivers,
          itemCount: 0,
          itemBuilder: (BuildContext context, int index) {
            return const SizedBox.shrink();
          },
          emptySliver: FolderErrorBanner(
            message: deckErrorMessageBuilder(error),
          ),
        );
      },
      data: (DeckState deckState) {
        final List<Widget> deckLeadingSlivers = <Widget>[...leadingSlivers];
        if (deckState.inlineErrorMessage case final String message) {
          deckLeadingSlivers.add(
            SliverToBoxAdapter(child: FolderErrorBanner(message: message)),
          );
          deckLeadingSlivers.add(
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
          );
        }
        return LumosPagedSliverList(
          controller: scrollController,
          leadingSlivers: deckLeadingSlivers,
          trailingSlivers: trailingSlivers,
          itemCount: deckState.decks.length,
          itemBuilder: (BuildContext context, int index) {
            final DeckNode item = deckState.decks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: DeckListTile(
                item: item,
                onOpen: () => onOpenDeck(item),
                onRename: () => onRenameDeck(context, item),
                onDelete: () => onDeleteDeck(context, item),
              ),
            );
          },
          emptySliver: DeckEmptyView(isSearchResult: searchQuery.isNotEmpty),
        );
      },
    );
  }
}
