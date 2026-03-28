import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/errors/async_value_error_extensions.dart';
import 'package:lumos/core/errors/failures.dart';
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
import 'deck_content.dart';

class DeckScreen extends ConsumerWidget {
  const DeckScreen({
    required this.folderId,
    this.searchQuery = '',
    this.sortType = DeckStateConst.sortTypeAscending,
    super.key,
  });

  final int folderId;
  final String searchQuery;
  final String sortType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DeckState> deckAsync = ref.watch(
      deckAsyncControllerProvider(folderId, searchQuery, sortType),
    );
    return LumosScreenTransition(
      switchKey: ValueKey<String>(
        'deck-${deckAsync.runtimeType}-$folderId-$searchQuery-$sortType',
      ),
      moveForward: true,
      child: deckAsync.whenWithLoading(
        loadingBuilder: (BuildContext context) {
          return const Center(child: LumosLoadingIndicator());
        },
        dataBuilder: (BuildContext context, DeckState state) {
          return DeckContent(
            state: state,
            providerArgs: (
              folderId: folderId,
              searchQuery: searchQuery,
              sortType: sortType,
            ),
          );
        },
        errorBuilder: (BuildContext context, Failure failure) {
          return LumosErrorState(
            errorMessage: failure.message,
            onRetry: () {
              ref
                  .read(
                    deckAsyncControllerProvider(
                      folderId,
                      searchQuery,
                      sortType,
                    ).notifier,
                  )
                  .refresh();
            },
          );
        },
      ),
    );
  }
}


