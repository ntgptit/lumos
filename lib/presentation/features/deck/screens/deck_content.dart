import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../domain/entities/deck_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/deck_provider.dart';
import '../providers/states/deck_state.dart';
import 'widgets/blocks/content/deck_list_content.dart';
import 'widgets/blocks/footer/deck_create_button.dart';
import 'widgets/dialogs/deck_dialogs.dart';
import 'widgets/states/deck_empty_view.dart';
import 'widgets/states/deck_error_banner.dart';

abstract final class DeckContentConst {
  DeckContentConst._();

  static const double listBottomSpacing = AppSpacing.canvas;
}

class DeckContent extends ConsumerWidget {
  const DeckContent({
    required this.state,
    required this.providerArgs,
    super.key,
  });

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
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              if (state.inlineErrorMessage case final String message)
                DeckErrorBanner(message: message),
              if (state.inlineErrorMessage != null)
                const SizedBox(height: AppSpacing.md),
              DeckListContent(
                providerArgs: providerArgs,
                visibleDecks: visibleDecks,
              ),
              if (visibleDecks.isEmpty) ...<Widget>[
                DeckEmptyView(isSearchResult: state.searchQuery.isNotEmpty),
              ],
              SizedBox(height: listBottomSpacing),
            ],
          ),
        ),
        DeckCreateButton(
          horizontalInset: LumosScreenFrame.resolveHorizontalInset(context),
          label: l10n.deckNewDeck,
          isMutating: state.isMutating,
          onPressed: () {
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
          },
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
}
