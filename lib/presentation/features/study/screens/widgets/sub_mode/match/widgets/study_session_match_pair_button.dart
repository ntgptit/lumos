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

const int _matchMeaningMaxLines = 5;
const int _matchWordMaxLines = 2;
const Duration _matchDisappearAnimationDuration = AppMotion.verySlow;
const double _matchMeaningLineHeight =
    AppTypographyConst.titleMediumLineHeight /
    AppTypographyConst.titleMediumFontSize;
const double _matchTermLineHeight =
    AppTypographyConst.titleLargeLineHeight /
    AppTypographyConst.titleLargeFontSize;

class StudySessionMatchPairButton extends StatelessWidget {
  const StudySessionMatchPairButton({
    required this.label,
    required this.isMatched,
    required this.isSelected,
    required this.isSuccessFeedback,
    required this.isErrorFeedback,
    required this.isDisappearing,
    required this.isMeaningCard,
    required this.isInteractionLocked,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isMatched;
  final bool isSelected;
  final bool isSuccessFeedback;
  final bool isErrorFeedback;
  final bool isDisappearing;
  final bool isMeaningCard;
  final bool isInteractionLocked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color backgroundColor = isSuccessFeedback
        ? context.appColors.successContainer
        : isErrorFeedback
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHighest;
    final Color textColor = isSuccessFeedback
        ? context.appColors.onSuccessContainer
        : isErrorFeedback
        ? colorScheme.onErrorContainer
        : isMatched
        ? colorScheme.primary
        : isMeaningCard
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactWidth = constraints.maxWidth < 180;
        final EdgeInsets contentPadding = StudySessionLayoutMetrics.cardPadding(
          context,
          horizontal: compactWidth ? LumosSpacing.lg : LumosSpacing.xl,
          vertical: compactWidth ? LumosSpacing.lg : LumosSpacing.xl,
        );
        final TextStyle? textStyle =
            (isMeaningCard
                    ? compactWidth
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.titleLarge
                    : compactWidth
                    ? theme.textTheme.bodyLarge
                    : theme.textTheme.titleMedium)
                ?.copyWith(
                  color: textColor,
                  fontWeight: isMeaningCard ? FontWeight.w500 : FontWeight.w300,
                  height: isMeaningCard
                      ? _matchTermLineHeight
                      : _matchMeaningLineHeight,
                );
        return AnimatedSlide(
          duration: _matchDisappearAnimationDuration,
          curve: Curves.easeInOutCubicEmphasized,
          offset: isDisappearing ? const Offset(0, 0.08) : Offset.zero,
          child: AnimatedScale(
            duration: _matchDisappearAnimationDuration,
            curve: Curves.easeInOutCubicEmphasized,
            scale: isDisappearing ? 0.92 : 1,
            child: AnimatedOpacity(
              duration: _matchDisappearAnimationDuration,
              curve: Curves.easeInOutCubicEmphasized,
              opacity: isDisappearing ? 0 : 1,
              child: LumosCard(
                onTap: isMatched || isInteractionLocked ? null : onPressed,
                isSelected:
                    (isSelected || isMatched) &&
                    !isSuccessFeedback &&
                    !isErrorFeedback,
                variant: LumosCardVariant.filled,
                borderRadius: BorderRadii.xLarge,
                padding: EdgeInsets.zero,
                child: AnimatedContainer(
                  duration: AppDurations.medium,
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
                    color: isSuccessFeedback || isErrorFeedback
                        ? backgroundColor
                        : colorScheme.surface.withValues(
                            alpha: AppOpacity.transparent,
                          ),
                    borderRadius: BorderRadii.xLarge,
                  ),
                  padding: contentPadding,
                  child: Center(
                    child: Align(
                      alignment: isMeaningCard
                          ? Alignment.center
                          : Alignment.centerLeft,
                      child: LumosInlineText(
                        label,
                        align: isMeaningCard
                            ? TextAlign.center
                            : TextAlign.left,
                        maxLines: isMeaningCard
                            ? _matchWordMaxLines
                            : _matchMeaningMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    ),
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

