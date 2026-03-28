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

const double _recallAnswerLineHeight =
    AppTypographyConst.titleLargeLineHeight /
    AppTypographyConst.titleLargeFontSize;
const double _recallHiddenAnswerWidth = 88;
const double _recallHiddenAnswerHeight = 18;
const double _recallHiddenAnswerBlurRadius = 28;
const double _recallHiddenAnswerSpreadRadius = 6;

class StudySessionRecallAnswerPanel extends StatelessWidget {
  const StudySessionRecallAnswerPanel({
    required this.content,
    required this.isRevealed,
    super.key,
  });

  final String content;
  final bool isRevealed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final EdgeInsets cardPadding = StudySessionLayoutMetrics.cardPadding(
      context,
      horizontal: LumosSpacing.xl,
      vertical: LumosSpacing.xl,
    );
    final double hiddenAnswerWidth = StudySessionLayoutMetrics.compactHeight(
      context,
      baseValue: _recallHiddenAnswerWidth,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double hiddenAnswerHeight = StudySessionLayoutMetrics.compactHeight(
      context,
      baseValue: _recallHiddenAnswerHeight,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double hiddenAnswerBlurRadius =
        StudySessionLayoutMetrics.compactHeight(
          context,
          baseValue: _recallHiddenAnswerBlurRadius,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
    final double hiddenAnswerSpreadRadius =
        StudySessionLayoutMetrics.compactHeight(
          context,
          baseValue: _recallHiddenAnswerSpreadRadius,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
    final Widget panelContent = isRevealed
        ? Padding(
            key: const ValueKey<String>('revealed-answer'),
            padding: cardPadding,
            child: Center(
              child: SingleChildScrollView(
                child: LumosInlineText(
                  content,
                  align: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                    height: _recallAnswerLineHeight,
                  ),
                ),
              ),
            ),
          )
        : Center(
            key: const ValueKey<String>('hidden-answer'),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(
                  alpha: AppOpacity.stateHover,
                ),
                borderRadius: BorderRadii.pill,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(
                      alpha: AppOpacity.scrimLight,
                    ),
                    blurRadius: hiddenAnswerBlurRadius,
                    spreadRadius: hiddenAnswerSpreadRadius,
                  ),
                ],
              ),
              child: SizedBox(
                width: hiddenAnswerWidth,
                height: hiddenAnswerHeight,
              ),
            ),
          );
    return StudySessionContentCard(
      variant: LumosCardVariant.filled,
      child: AnimatedSwitcher(
        duration: AppDurations.medium,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: panelContent,
      ),
    );
  }
}

