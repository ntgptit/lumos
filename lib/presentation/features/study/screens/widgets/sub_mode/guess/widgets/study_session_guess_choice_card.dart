import 'package:flutter/material.dart';

import 'package:lumos/core/theme/foundation/app_typography_const.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
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
import '../../widgets/study_session_layout_metrics.dart';

const double studySessionGuessChoiceCardDefaultHeight = 64;
const double _guessChoiceLineHeight =
    AppTypographyConst.titleSmallLineHeight /
    AppTypographyConst.titleSmallFontSize;
const int _guessChoiceMaxLines = 2;
const EdgeInsetsGeometry _guessChoiceCardPadding = EdgeInsets.symmetric(
  horizontal: LumosSpacing.md,
  vertical: LumosSpacing.xs,
);

class StudySessionGuessChoiceCard extends StatelessWidget {
  const StudySessionGuessChoiceCard({
    required this.label,
    required this.onPressed,
    this.height,
    this.isSelected = false,
    this.isSuccessFeedback = false,
    this.isErrorFeedback = false,
    this.isInteractive = true,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final double? height;
  final bool isSelected;
  final bool isSuccessFeedback;
  final bool isErrorFeedback;
  final bool isInteractive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final double resolvedHeight =
        height ??
        StudySessionLayoutMetrics.compactHeight(
          context,
          baseValue: studySessionGuessChoiceCardDefaultHeight,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
    final EdgeInsets cardPadding = ResponsiveDimensions.compactInsets(
      context: context,
      baseInsets: _guessChoiceCardPadding as EdgeInsets,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final Color backgroundColor = isSuccessFeedback
        ? context.appColors.successContainer
        : isErrorFeedback
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHighest;
    final Color textColor = isSuccessFeedback
        ? context.appColors.onSuccessContainer
        : isErrorFeedback
        ? colorScheme.onErrorContainer
        : colorScheme.onSurfaceVariant;
    return LumosCard(
      margin: EdgeInsets.zero,
      onTap: isInteractive ? onPressed : null,
      isSelected: isSelected && !isSuccessFeedback && !isErrorFeedback,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: AppDurations.medium,
        curve: Curves.easeInOutCubic,
        decoration: BoxDecoration(
          color: isSuccessFeedback || isErrorFeedback
              ? backgroundColor
              : colorScheme.surface.withValues(alpha: AppOpacity.transparent),
          borderRadius: BorderRadii.xLarge,
        ),
        child: SizedBox(
          height: resolvedHeight,
          child: Padding(
            padding: cardPadding,
            child: Center(
              child: LumosInlineText(
                label,
                align: TextAlign.center,
                maxLines: _guessChoiceMaxLines,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  height: _guessChoiceLineHeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

