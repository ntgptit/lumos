import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/deck_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/deck_provider.dart';
import '../../dialogs/deck_dialogs.dart';
import 'deck_list_tile.dart';

class DeckListContent extends ConsumerWidget {
  const DeckListContent({
    required this.providerArgs,
    required this.visibleDecks,
    super.key,
  });

  final ({int folderId, String searchQuery, String sortType}) providerArgs;
  final List<DeckNode> visibleDecks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double bottomInset = ResponsiveDimensions.compactValue(
          context: context,
          baseValue: constraints.maxWidth < 380 ? LumosSpacing.xs : LumosSpacing.sm,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        return Column(
          children: visibleDecks
              .map(
                (DeckNode item) => Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: DeckListTile(
                    item: item,
                    onOpen: () {
                      DeckDetailRouteData(
                        folderId: providerArgs.folderId,
                        deckId: item.id,
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
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

