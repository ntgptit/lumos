import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/error/async_value_error_extensions.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/flashcard_provider.dart';
import '../providers/states/flashcard_state.dart';
import 'flashcard_content.dart';
import 'widgets/states/flashcard_loading_shell.dart';

abstract final class FlashcardScreenConst {
  FlashcardScreenConst._();

  static const EdgeInsets loadingMaskPadding = EdgeInsets.fromLTRB(
    AppSpacing.lg,
    AppSpacing.sm,
    AppSpacing.lg,
    AppSpacing.none,
  );
  static const double loadingMaskHeight = WidgetSizes.progressTrackHeight;
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
