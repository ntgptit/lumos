import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/deck_models.dart';
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
    final double listBottomSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FolderContentSupportConst.listBottomSpacing,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
    final double emptyStateVerticalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double inlineErrorSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double rowSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final List<Widget> trailingSlivers = <Widget>[
      SliverToBoxAdapter(child: SizedBox(height: listBottomSpacing)),
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
          emptySliver: Padding(
            padding: EdgeInsets.symmetric(vertical: emptyStateVerticalPadding),
            child: const FolderDeckLoading(),
          ),
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
            SliverToBoxAdapter(child: SizedBox(height: inlineErrorSpacing)),
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
              padding: EdgeInsets.only(bottom: rowSpacing),
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

