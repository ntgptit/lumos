import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../../domain/entities/deck_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/deck_provider.dart';
import '../providers/states/deck_state.dart';
import 'widgets/blocks/deck_tile.dart';
import 'widgets/dialogs/deck_dialogs.dart';
import 'widgets/states/deck_empty_view.dart';

abstract final class DeckContentConst {
  DeckContentConst._();

  static const double listBottomSpacing = Insets.spacing64;
}

class DeckContent extends ConsumerWidget {
  const DeckContent({
    required this.state,
    required this.providerArgs,
    super.key,
  });

  final DeckState state;
  final ({int folderId, String searchQuery}) providerArgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final DeckAsyncController controller = ref.read(
      deckAsyncControllerProvider(
        providerArgs.folderId,
        providerArgs.searchQuery,
      ).notifier,
    );
    final List<DeckNode> visibleDecks = state.decks;
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              if (state.inlineErrorMessage case final String message)
                _DeckErrorBanner(message: message),
              if (state.inlineErrorMessage != null)
                const SizedBox(height: Insets.spacing12),
              ..._buildDeckTiles(
                context: context,
                ref: ref,
                providerArgs: providerArgs,
                visibleDecks: visibleDecks,
              ),
              if (visibleDecks.isEmpty)
                DeckEmptyView(isSearchResult: state.searchQuery.isNotEmpty),
              const SizedBox(height: DeckContentConst.listBottomSpacing),
            ],
          ),
        ),
        if (!state.isMutating)
          Positioned(
            right: LumosScreenFrame.resolveHorizontalInset(context),
            bottom: Insets.gapBetweenSections,
            child: LumosFloatingActionButton(
              onPressed: () => showDeckEditorDialog(
                context: context,
                titleBuilder: (AppLocalizations l10n) => l10n.deckCreateTitle,
                actionLabelBuilder: (AppLocalizations l10n) =>
                    l10n.commonCreate,
                initialDeck: null,
                onSubmitted: (DeckUpsertInput input) {
                  return ref
                      .read(
                        deckAsyncControllerProvider(
                          providerArgs.folderId,
                          providerArgs.searchQuery,
                        ).notifier,
                      )
                      .createDeck(input);
                },
              ),
              icon: Icons.style_outlined,
              label: l10n.deckNewDeck,
            ),
          ),
        if (state.isMutating)
          Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(
                color: Theme.of(context).colorScheme.scrim,
                child: const Center(child: LumosLoadingIndicator()),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildDeckTiles({
    required BuildContext context,
    required WidgetRef ref,
    required ({int folderId, String searchQuery}) providerArgs,
    required List<DeckNode> visibleDecks,
  }) {
    return visibleDecks
        .map((DeckNode item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Insets.spacing8),
            child: DeckTile(
              item: item,
              onOpen: () {},
              onRename: () => showDeckEditorDialog(
                context: context,
                titleBuilder: (AppLocalizations l10n) => l10n.deckRenameTitle,
                actionLabelBuilder: (AppLocalizations l10n) => l10n.commonSave,
                initialDeck: item,
                onSubmitted: (DeckUpsertInput input) {
                  return ref
                      .read(
                        deckAsyncControllerProvider(
                          providerArgs.folderId,
                          providerArgs.searchQuery,
                        ).notifier,
                      )
                      .updateDeck(deckId: item.id, input: input);
                },
              ),
              onDelete: () => showDeckConfirmDialog(
                context: context,
                titleBuilder: (AppLocalizations l10n) => l10n.deckDeleteTitle,
                messageBuilder: (AppLocalizations l10n) {
                  return l10n.deckDeleteConfirm(item.name);
                },
                confirmLabelBuilder: (AppLocalizations l10n) =>
                    l10n.commonDelete,
                onConfirmed: () async {
                  await ref
                      .read(
                        deckAsyncControllerProvider(
                          providerArgs.folderId,
                          providerArgs.searchQuery,
                        ).notifier,
                      )
                      .deleteDeck(item.id);
                },
              ),
            ),
          );
        })
        .toList(growable: false);
  }
}

class _DeckErrorBanner extends StatelessWidget {
  const _DeckErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Insets.spacing12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadii.medium,
      ),
      child: LumosText(
        message,
        style: LumosTextStyle.bodySmall,
        containerRole: LumosTextContainerRole.errorContainer,
      ),
    );
  }
}
