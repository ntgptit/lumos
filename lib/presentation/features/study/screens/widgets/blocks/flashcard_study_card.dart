import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../l10n/app_localizations.dart';
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

abstract final class FlashcardStudyCardConst {
  FlashcardStudyCardConst._();

  static const double contentHorizontalPadding = LumosSpacing.lg;
  static const double contentVerticalPadding = LumosSpacing.lg;
  static const double actionIconSize = LumosSpacing.xl;
  static const double hintIconSize = LumosSpacing.xl;
  static const double titleGap = LumosSpacing.sm;
  static const double bottomGap = LumosSpacing.sm;
  static const int backTextMaxLines = 8;
  static const int noteMaxLines = 4;
}

class FlashcardStudyCard extends StatelessWidget {
  const FlashcardStudyCard({
    required this.item,
    required this.isFlipped,
    required this.isStarred,
    required this.isAudioPlaying,
    required this.onFlipPressed,
    required this.onAudioPressed,
    required this.onStarPressed,
    super.key,
  });

  final FlashcardNode item;
  final bool isFlipped;
  final bool isStarred;
  final bool isAudioPlaying;
  final VoidCallback onFlipPressed;
  final VoidCallback onAudioPressed;
  final VoidCallback onStarPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final String normalizedNote = StringUtils.normalizeText(item.note);
    final bool hasNote = normalizedNote.isNotEmpty;
    final double contentHorizontalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.contentHorizontalPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double contentVerticalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.contentVerticalPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double actionIconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.actionIconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double titleGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.titleGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double bottomGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.bottomGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double hintIconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.hintIconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      onTap: onFlipPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: contentHorizontalPadding,
          vertical: contentVerticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                LumosIconButton(
                  onPressed: onAudioPressed,
                  tooltip: l10n.flashcardPlayAudioTooltip,
                  icon: Icons.volume_up_outlined,
                  size: actionIconSize,
                  selected: isAudioPlaying,
                  selectedIcon: Icons.graphic_eq_rounded,
                ),
                const Spacer(),
                LumosIconButton(
                  onPressed: onStarPressed,
                  tooltip: l10n.flashcardBookmarkTooltip,
                  icon: Icons.star_border,
                  size: actionIconSize,
                  selected: isStarred,
                  selectedIcon: Icons.star,
                ),
              ],
            ),
            SizedBox(height: titleGap),
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: AppDurations.medium,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  child: isFlipped
                      ? Column(
                          key: const ValueKey<String>('flashcard-back'),
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            LumosInlineText(
                              item.backText,
                              align: TextAlign.center,
                              style: theme.textTheme.titleMedium,
                              maxLines:
                                  FlashcardStudyCardConst.backTextMaxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (hasNote)
                              Padding(
                                padding: EdgeInsets.only(top: titleGap),
                                child: LumosInlineText(
                                  normalizedNote,
                                  align: TextAlign.center,
                                  style: theme.textTheme.bodyMedium,
                                  maxLines:
                                      FlashcardStudyCardConst.noteMaxLines,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        )
                      : LumosInlineText(
                          item.frontText,
                          key: const ValueKey<String>('flashcard-front'),
                          align: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                          maxLines: FlashcardStudyCardConst.backTextMaxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
            ),
            SizedBox(height: bottomGap),
            Center(
              child: LumosIcon(Icons.flip_to_back_rounded, size: hintIconSize),
            ),
          ],
        ),
      ),
    );
  }
}

