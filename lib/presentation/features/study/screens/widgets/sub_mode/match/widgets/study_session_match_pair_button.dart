import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const int _matchMeaningMaxLines = 5;
const int _matchWordMaxLines = 2;
const Duration _matchDisappearAnimationDuration = AppMotion.verySlow;
const double _matchMeaningLineHeight =
    AppTypographyConst.titleMediumLineHeight /
    AppTypographyConst.titleMediumFontSize;
const double _matchTermLineHeight =
    AppTypographyConst.titleLargeLineHeight /
    AppTypographyConst.titleLargeFontSize;
const EdgeInsetsGeometry _matchCardContentPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xl,
);

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
    final TextStyle? textStyle =
        (isMeaningCard
                ? theme.textTheme.titleLarge
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
                color:
                    isSuccessFeedback || isErrorFeedback
                    ? backgroundColor
                    : colorScheme.surface.withValues(
                        alpha: AppOpacity.transparent,
                      ),
                borderRadius: BorderRadii.xLarge,
              ),
              padding: _matchCardContentPadding,
              child: Center(
                child: Align(
                  alignment: isMeaningCard
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: LumosInlineText(
                    label,
                    align: isMeaningCard ? TextAlign.center : TextAlign.left,
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
  }
}
