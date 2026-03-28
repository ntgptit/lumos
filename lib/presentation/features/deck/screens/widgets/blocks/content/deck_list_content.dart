import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/deck_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/deck_provider.dart';
import '../../dialogs/deck_dialogs.dart';
import 'deck_list_tile.dart';

class DeckListContent extends ConsumerWidget {
  const DeckListContent({
    required this.scrollController,
    required this.leadingSlivers,
    required this.providerArgs,
    required this.visibleDecks,
    required this.listBottomSpacing,
    required this.emptyState,
    super.key,
  });

  final ScrollController scrollController;
  final List<Widget> leadingSlivers;
  final ({int folderId, String searchQuery, String sortType}) providerArgs;
  final List<DeckNode> visibleDecks;
  final double listBottomSpacing;
  final Widget emptyState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double rowSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosPagedSliverList(
      controller: scrollController,
      leadingSlivers: leadingSlivers,
      trailingSlivers: <Widget>[
        SliverToBoxAdapter(child: SizedBox(height: listBottomSpacing)),
      ],
      itemCount: visibleDecks.length,
      itemBuilder: (BuildContext context, int index) {
        final DeckNode item = visibleDecks[index];
        return Padding(
          padding: EdgeInsets.only(bottom: rowSpacing),
          child: DeckListTile(
            item: item,
            onOpen: () {
              DeckDetailRouteData(
                folderId: providerArgs.folderId,
                deckId: item.id,
                deckName: item.name,
              ).push(context);
            },
            onRename: () => showDeckEditorDialog(
              context: context,
              titleBuilder: (AppLocalizations l10n) {
                return l10n.deckRenameTitle;
              },
              actionLabelBuilder: (AppLocalizations l10n) {
                return l10n.commonSave;
              },
              initialDeck: item,
              onSubmitted: (DeckUpsertInput input) {
                return ref
                    .read(
                      deckAsyncControllerProvider(
                        providerArgs.folderId,
                        providerArgs.searchQuery,
                        providerArgs.sortType,
                      ).notifier,
                    )
                    .updateDeck(deckId: item.id, input: input);
              },
            ),
            onDelete: () => showDeckConfirmDialog(
              context: context,
              titleBuilder: (AppLocalizations l10n) {
                return l10n.deckDeleteTitle;
              },
              messageBuilder: (AppLocalizations l10n) {
                return l10n.deckDeleteConfirm(item.name);
              },
              confirmLabelBuilder: (AppLocalizations l10n) {
                return l10n.commonDelete;
              },
              onConfirmed: () async {
                await ref
                    .read(
                      deckAsyncControllerProvider(
                        providerArgs.folderId,
                        providerArgs.searchQuery,
                        providerArgs.sortType,
                      ).notifier,
                    )
                    .deleteDeck(item.id);
              },
            ),
          ),
        );
      },
      emptySliver: emptyState,
    );
  }
}
