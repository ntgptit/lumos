import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../domain/entities/deck_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/deck_provider.dart';
import '../providers/states/deck_state.dart';
import 'widgets/blocks/content/deck_list_content.dart';
import 'widgets/blocks/footer/deck_create_button.dart';
import 'widgets/dialogs/deck_dialogs.dart';
import 'widgets/states/deck_empty_view.dart';
import 'widgets/states/deck_error_banner.dart';

abstract final class DeckContentConst {
  DeckContentConst._();

  static const double listBottomSpacing = LumosSpacing.canvas;
}

class DeckContent extends ConsumerWidget {
  const DeckContent({
    required this.scrollController,
    required this.leadingSlivers,
    required this.state,
    required this.providerArgs,
    super.key,
  });

  final ScrollController scrollController;
  final List<Widget> leadingSlivers;
  final DeckState state;
  final ({int folderId, String searchQuery, String sortType}) providerArgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double listBottomSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: DeckContentConst.listBottomSpacing,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final DeckAsyncController controller = ref.read(
      deckAsyncControllerProvider(
        providerArgs.folderId,
        providerArgs.searchQuery,
        providerArgs.sortType,
      ).notifier,
    );
    final List<DeckNode> visibleDecks = state.decks;
    final List<Widget> contentLeadingSlivers = <Widget>[...leadingSlivers];
    if (state.inlineErrorMessage case final String message) {
      contentLeadingSlivers.add(
        SliverToBoxAdapter(child: DeckErrorBanner(message: message)),
      );
      contentLeadingSlivers.add(
        SliverToBoxAdapter(child: SizedBox(height: LumosSpacing.md)),
      );
    }
    return Stack(
      children: <Widget>[
        AbsorbPointer(
          absorbing: state.isMutating,
          child: RefreshIndicator(
            onRefresh: controller.refresh,
            child: LumosScreenFrame(
              child: DeckListContent(
                scrollController: scrollController,
                leadingSlivers: contentLeadingSlivers,
                providerArgs: providerArgs,
                visibleDecks: visibleDecks,
                listBottomSpacing: listBottomSpacing,
                emptyState: DeckEmptyView(
                  isSearchResult: state.searchQuery.isNotEmpty,
                  buttonLabel: state.searchQuery.isNotEmpty
                      ? null
                      : l10n.deckNewDeck,
                  onButtonPressed: state.searchQuery.isNotEmpty
                      ? null
                      : () {
                          _showDeckEditorDialog(context: context, ref: ref);
                        },
                ),
              ),
            ),
          ),
        ),
        DeckCreateButton(
          horizontalInset: LumosScreenFrame.resolveHorizontalInset(context),
          label: l10n.deckNewDeck,
          isMutating: state.isMutating,
          onPressed: () => _showDeckEditorDialog(context: context, ref: ref),
        ),
        if (state.isMutating)
          Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(
                color: context.colorScheme.scrim,
                child: const Center(child: LumosLoadingIndicator()),
              ),
            ),
          ),
      ],
    );
  }

  void _showDeckEditorDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    showDeckEditorDialog(
      context: context,
      titleBuilder: (AppLocalizations l10n) => l10n.deckCreateTitle,
      actionLabelBuilder: (AppLocalizations l10n) => l10n.commonCreate,
      initialDeck: null,
      onSubmitted: (DeckUpsertInput input) {
        return ref
            .read(
              deckAsyncControllerProvider(
                providerArgs.folderId,
                providerArgs.searchQuery,
                providerArgs.sortType,
              ).notifier,
            )
            .createDeck(input);
      },
    );
  }
}
