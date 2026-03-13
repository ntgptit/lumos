import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _matchCardMinHeight = WidgetSizes.minTouchTarget * 3.5;
const int _matchMeaningMaxLines = 6;
const int _matchWordMaxLines = 2;
const Duration _matchDisappearAnimationDuration = AppDurations.medium;
const EdgeInsetsGeometry _matchCardContentPadding = EdgeInsets.all(
  AppSpacing.lg,
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
                ? theme.textTheme.titleMedium
                : theme.textTheme.headlineSmall)
            ?.copyWith(
              color: textColor,
              fontWeight: isMeaningCard ? FontWeight.w500 : FontWeight.w600,
              height: isMeaningCard ? 1.3 : 1.15,
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
                    : Colors.transparent,
                borderRadius: BorderRadii.xLarge,
              ),
              padding: _matchCardContentPadding,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _matchCardMinHeight),
                child: Center(
                  child: LumosInlineText(
                    label,
                    align: TextAlign.center,
                    maxLines: isMeaningCard
                        ? _matchMeaningMaxLines
                        : _matchWordMaxLines,
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
