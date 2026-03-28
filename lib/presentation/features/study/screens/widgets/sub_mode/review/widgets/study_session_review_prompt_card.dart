import 'package:flutter/material.dart';

import 'package:lumos/core/theme/foundation/app_typography_const.dart';
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
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double _reviewPromptIconSize = IconSizes.iconMedium;
const double _reviewPromptLineHeight =
    AppTypographyConst.titleLargeLineHeight /
    AppTypographyConst.titleLargeFontSize;

class StudySessionReviewPromptCard extends StatelessWidget {
  const StudySessionReviewPromptCard({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight = constraints.maxHeight < 260;
        final double iconSize = ResponsiveDimensions.compactValue(
          context: context,
          baseValue: compactHeight
              ? IconSizes.iconSmall
              : _reviewPromptIconSize,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        final EdgeInsets cardPadding = StudySessionLayoutMetrics.cardPadding(
          context,
          horizontal: compactHeight ? LumosSpacing.lg : LumosSpacing.xl,
          vertical: compactHeight ? LumosSpacing.lg : LumosSpacing.xl,
        );
        final EdgeInsets topTrailingPadding =
            StudySessionLayoutMetrics.topTrailingPadding(
              context,
              top: compactHeight ? LumosSpacing.md : LumosSpacing.lg,
              right: compactHeight ? LumosSpacing.md : LumosSpacing.lg,
            );
        return StudySessionContentCard(
          variant: LumosCardVariant.filled,
          topTrailing: LumosIcon(Icons.edit_outlined, size: iconSize),
          topTrailingPadding: topTrailingPadding,
          child: Padding(
            padding: cardPadding,
            child: Center(
              child: SingleChildScrollView(
                child: LumosInlineText(
                  content,
                  align: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                    height: _reviewPromptLineHeight,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

