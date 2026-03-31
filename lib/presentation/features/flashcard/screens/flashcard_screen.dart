import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/errors/async_value_error_extensions.dart';
import 'package:lumos/core/errors/failures.dart';
import '../providers/flashcard_provider.dart';
import '../providers/states/flashcard_state.dart';
import 'flashcard_content.dart';
import 'widgets/states/flashcard_loading_shell.dart';

abstract final class FlashcardScreenConst {
  FlashcardScreenConst._();

  static const EdgeInsets loadingMaskPadding = EdgeInsets.fromLTRB(
    24,
    12,
    24,
    0,
  );
  static const double loadingMaskHeight = 6;
}

class FlashcardScreen extends ConsumerWidget {
  const FlashcardScreen({
    required this.deckId,
    required this.deckName,
    super.key,
  });

  final int deckId;
  final String deckName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<FlashcardState> flashcardAsync = ref.watch(
      flashcardAsyncControllerProvider(deckId, deckName),
    );
    return LumosScreenTransition(
      switchKey: ValueKey<String>(
        'flashcard-${flashcardAsync.runtimeType}-$deckId-$deckName',
      ),
      moveForward: true,
      child: flashcardAsync.whenWithLoading(
        loadingBuilder: (BuildContext context) {
          return FlashcardLoadingShell(deckName: deckName);
        },
        dataBuilder: (BuildContext context, FlashcardState state) {
          return FlashcardContent(state: state);
        },
        errorBuilder: (BuildContext context, Failure failure) {
          return LumosErrorState(
            errorMessage: failure.message,
            onRetry: () {
              ref
                  .read(
                    flashcardAsyncControllerProvider(deckId, deckName).notifier,
                  )
                  .refresh();
            },
          );
        },
      ),
    );
  }
}
