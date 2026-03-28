import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
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
import '../providers/flashcard_provider.dart';
import '../providers/states/flashcard_state.dart';
import 'flashcard_content.dart';
import 'widgets/states/flashcard_loading_shell.dart';

abstract final class FlashcardScreenConst {
  FlashcardScreenConst._();

  static const EdgeInsets loadingMaskPadding = EdgeInsets.fromLTRB(
    LumosSpacing.lg,
    LumosSpacing.sm,
    LumosSpacing.lg,
    LumosSpacing.none,
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


