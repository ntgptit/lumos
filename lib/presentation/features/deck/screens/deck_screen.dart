import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/async_value_error_extensions.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/widgets/lumos_widgets.dart';
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
