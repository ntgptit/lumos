import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
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

abstract final class FlashcardListHeaderConst {
  FlashcardListHeaderConst._();

  static const double titleBottomSpacing = LumosSpacing.xs;
  static const double sortGap = LumosSpacing.sm;
}

class FlashcardListHeader extends StatelessWidget {
  const FlashcardListHeader({
    required this.title,
    required this.subtitle,
    required this.sortLabel,
    required this.onSortPressed,
    super.key,
  });

  final String title;
  final String subtitle;
  final String sortLabel;
  final VoidCallback onSortPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final double titleBottomSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardListHeaderConst.titleBottomSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sortGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardListHeaderConst.sortGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final EdgeInsets sortPadding = ResponsiveDimensions.compactInsets(
      context: context,
      baseInsets: const EdgeInsets.symmetric(
        horizontal: LumosSpacing.sm,
        vertical: LumosSpacing.xs,
      ),
    );
    final Widget titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosInlineText(title, style: theme.textTheme.titleMedium),
        SizedBox(height: titleBottomSpacing),
        LumosInlineText(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
    final Widget sortAction = InkWell(
      onTap: onSortPressed,
      borderRadius: BorderRadii.large,
      child: Padding(
        padding: sortPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LumosInlineText(sortLabel, style: theme.textTheme.titleMedium),
            SizedBox(width: sortGap),
            const LumosIcon(Icons.tune_rounded),
          ],
        ),
      ),
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 360) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titleSection,
              SizedBox(height: sortGap),
              sortAction,
            ],
          );
        }
        return Row(
          children: <Widget>[
            Expanded(child: titleSection),
            SizedBox(width: sortGap),
            sortAction,
          ],
        );
      },
    );
  }
}

