import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../domain/entities/deck_models.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';
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
                const SizedBox(height: LumosSpacing.md),
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

