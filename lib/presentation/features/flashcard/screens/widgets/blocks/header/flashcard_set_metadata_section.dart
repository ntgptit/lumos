import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
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

abstract final class FlashcardSetMetadataSectionConst {
  FlashcardSetMetadataSectionConst._();

  static const double titleBottomSpacing = LumosSpacing.md;
  static const double rowSpacing = LumosSpacing.md;
  static const double ownerAvatarRadius = LumosSpacing.lg;
  static const double ownerNameRightSpacing = LumosSpacing.sm;
  static const double chipHorizontalPadding = LumosSpacing.md;
  static const double chipVerticalPadding = LumosSpacing.xs;
  static const double dividerHorizontalMargin = LumosSpacing.md;
  static const double dividerHeight = LumosSpacing.xxl;
}

class FlashcardSetMetadataSection extends StatelessWidget {
  const FlashcardSetMetadataSection({
    required this.title,
    required this.totalFlashcards,
    super.key,
  });

  final String title;
  final int totalFlashcards;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String ownerName = l10n.flashcardOwnerFallback;
    final double titleBottomSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.titleBottomSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double rowSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.rowSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double ownerAvatarRadius = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.ownerAvatarRadius,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double chipHorizontalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.chipHorizontalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double chipVerticalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.chipVerticalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dividerHorizontalMargin = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.dividerHorizontalMargin,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dividerHeight = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.dividerHeight,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosText(title, style: LumosTextStyle.titleMedium),
        SizedBox(height: titleBottomSpacing),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: ownerAvatarRadius,
              backgroundColor: colorScheme.secondaryContainer,
              child: IconTheme(
                data: IconThemeData(color: colorScheme.onSecondaryContainer),
                child: const LumosIcon(Icons.person_rounded),
              ),
            ),
            SizedBox(width: rowSpacing),
            LumosInlineText(
              ownerName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              width: FlashcardSetMetadataSectionConst.ownerNameRightSpacing,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadii.large,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: chipHorizontalPadding,
                  vertical: chipVerticalPadding,
                ),
                child: LumosInlineText(
                  l10n.flashcardPlusBadge,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: dividerHorizontalMargin),
              width: WidgetSizes.borderWidthRegular,
              height: dividerHeight,
              color: colorScheme.outlineVariant,
            ),
            Expanded(
              child: LumosInlineText(
                l10n.flashcardTotalLabel(totalFlashcards),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

