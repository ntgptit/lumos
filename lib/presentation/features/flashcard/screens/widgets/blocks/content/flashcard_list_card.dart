import 'package:flutter/material.dart';

import 'package:lumos/core/theme/foundation/app_typography_const.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../core/utils/string_utils.dart';
import '../../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
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

abstract final class FlashcardListCardConst {
  FlashcardListCardConst._();

  static const EdgeInsets cardPadding = EdgeInsets.fromLTRB(
    LumosSpacing.lg,
    LumosSpacing.md,
    LumosSpacing.md,
    LumosSpacing.md,
  );
  static const double textGap = LumosSpacing.xs;
  static const double iconSpacing = LumosSpacing.xs;
  static const double actionIconSize = IconSizes.iconMedium - LumosSpacing.xs;
  static const VisualDensity actionVisualDensity = VisualDensity.compact;
  static const double frontTextFontSize =
      AppTypographyConst.titleMediumFontSize + LumosSpacing.xxs;
  static const double frontTextHeight =
      AppTypographyConst.titleMediumLineHeight / frontTextFontSize;
  static const int backTextMaxLines = 4;
  static const int noteMaxLines = 3;
  static const String actionEdit = 'action-edit';
  static const String actionDelete = 'action-delete';
}

class FlashcardListCard extends StatelessWidget {
  const FlashcardListCard({
    required this.item,
    required this.isStarred,
    required this.isAudioPlaying,
    required this.onAudioPressed,
    required this.onStarPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    super.key,
  });

  final FlashcardNode item;
  final bool isStarred;
  final bool isAudioPlaying;
  final VoidCallback onAudioPressed;
  final VoidCallback onStarPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final String normalizedNote = StringUtils.normalizeText(item.note);
    final EdgeInsets cardPadding = ResponsiveDimensions.compactInsets(
      context: context,
      baseInsets: FlashcardListCardConst.cardPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double textGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardListCardConst.textGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double iconSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardListCardConst.iconSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double actionIconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardListCardConst.actionIconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double frontTextFontSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardListCardConst.frontTextFontSize,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    return LumosCard(
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: LumosInlineText(
                    item.frontText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: frontTextFontSize,
                      height: FlashcardListCardConst.frontTextHeight,
                      letterSpacing:
                          AppTypographyConst.titleMediumLetterSpacing,
                      fontWeight: AppTypographyConst.kFontWeightSemiBold,
                    ),
                  ),
                ),
                SizedBox(width: iconSpacing),
                Theme(
                  data: theme.copyWith(
                    visualDensity: FlashcardListCardConst.actionVisualDensity,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LumosIconButton(
                        onPressed: onAudioPressed,
                        tooltip: l10n.flashcardPlayAudioTooltip,
                        icon: Icons.volume_up_outlined,
                        size: actionIconSize,
                        selected: isAudioPlaying,
                        selectedIcon: Icons.graphic_eq_rounded,
                      ),
                      LumosIconButton(
                        onPressed: onStarPressed,
                        tooltip: l10n.flashcardBookmarkTooltip,
                        icon: Icons.star_border,
                        size: actionIconSize,
                        selected: isStarred,
                        selectedIcon: Icons.star,
                      ),
                      LumosPopupMenuButton<String>(
                        tooltip: l10n.flashcardMoreButtonTooltip,
                        onSelected: (String value) {
                          if (value == FlashcardListCardConst.actionEdit) {
                            onEditPressed();
                            return;
                          }
                          onDeletePressed();
                        },
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: FlashcardListCardConst.actionEdit,
                              child: LumosInlineText(l10n.flashcardEditTooltip),
                            ),
                            PopupMenuItem<String>(
                              value: FlashcardListCardConst.actionDelete,
                              child: LumosInlineText(
                                l10n.flashcardDeleteTooltip,
                              ),
                            ),
                          ];
                        },
                        icon: LumosIcon(
                          Icons.more_vert_rounded,
                          size: actionIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: textGap),
            LumosInlineText(
              item.backText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: FlashcardListCardConst.backTextMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
            if (normalizedNote.isNotEmpty) ...<Widget>[
              SizedBox(height: textGap),
              LumosInlineText(
                normalizedNote,
                style: theme.textTheme.bodySmall,
                maxLines: FlashcardListCardConst.noteMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

